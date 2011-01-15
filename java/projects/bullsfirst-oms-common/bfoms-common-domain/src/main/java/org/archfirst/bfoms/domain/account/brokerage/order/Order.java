/**
 * Copyright 2010 Archfirst
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.archfirst.bfoms.domain.account.brokerage.order;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccount;
import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccountRepository;
import org.archfirst.bfoms.domain.account.brokerage.Trade;
import org.archfirst.bfoms.domain.pricing.Instrument;
import org.archfirst.bfoms.domain.pricing.PricingService;
import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.bfoms.interfaceout.exchange.ExchangeAdapter;
import org.archfirst.common.datetime.DateTimeUtil;
import org.archfirst.common.domain.DomainEntity;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.archfirst.common.quantity.DecimalQuantityMin;
import org.hibernate.annotations.Parameter;
import org.hibernate.annotations.Type;
import org.joda.time.DateTime;

/**
 * Order
 *
 * @author Naresh Bhatia
 */
@Entity
@Table(name="Orders") // Oracle gets confused with table named "Order"
public class Order extends DomainEntity implements Comparable<Order> {
    private static final long serialVersionUID = 1L;
    private static final Money FIXED_FEE = new Money("10.00");
    
    private DateTime creationTime;
    private OrderSide side;
    private Instrument instrument;
    private DecimalQuantity quantity;
    private OrderType type;
    private Money limitPrice;
    private OrderTerm term;
    private boolean allOrNone;
    private OrderStatus status = OrderStatus.PendingNew;
    private BrokerageAccount account;
    private Set<Execution> executions = new HashSet<Execution>();
    
    // ----- Constructors -----
    private Order() {
    }
    
    public Order(
            OrderSide side,
            Instrument instrument,
            DecimalQuantity quantity,
            OrderType type,
            Money limitPrice,
            OrderTerm term,
            boolean allOrNone) {
        this.side = side;
        this.instrument = instrument;
        this.quantity = quantity;
        this.type = type;
        this.limitPrice = limitPrice;
        this.term = term;
        this.allOrNone = allOrNone;
    }

    // ----- Commands -----
    /**
     * Processes the specified execution report and returns a trade if the
     * order is closed as the result of this execution report.
     * 
     * @param executionReport
     * @return a trade if the order is closed, otherwise null
     */
    public Trade processExecutionReport(
            ExecutionReport executionReport,
            BrokerageAccountRepository accountRepository) {
        
        // Check if status change is valid, i.e ExecutionReport is coming
        // in the right sequence
        OrderStatus newStatus = executionReport.getOrderStatus();
        if (isStatusChangeValid(newStatus)) {
            this.status = executionReport.getOrderStatus();
        }
        else {
            throw new IllegalArgumentException(
                    "Can't change status from " + this.status + " to " + newStatus);
        }

        // If ExecutionReportType is Trade, then add an execution to this order
        if (executionReport.getType() == ExecutionReportType.Trade) {
            this.addExecution(
                    new Execution(
                            new DateTime(),
                            executionReport.getLastQty(),
                            executionReport.getLastPrice()));
            // Check if leaves quantity is matching, i.e ExecutionReport is
            // coming in the right sequence
            if (!this.getLeavesQty().eq(executionReport.getLeavesQty())) {
                throw new IllegalArgumentException(
                        "Leaves quantity of " + this.getLeavesQty() +
                        " does not match execution report quantity of " +
                        executionReport.getLeavesQty());
            }
        }
        
        // If order is closed, return a trade
        Trade trade = null;
        if (isClosed() && !executions.isEmpty()) {
            trade = new Trade(
                    new DateTime(),
                    this.side,
                    this.instrument,
                    this.getCumQty(),
                    this.getTotalPriceOfExecutions(),
                    this.getFees(),
                    this);
        }
        return trade;
    }
    
    public void cancel(ExchangeAdapter exchangeAdapter) {
        OrderStatus newStatus = OrderStatus.PendingCancel;
        if (isStatusChangeValid(newStatus)) {
            exchangeAdapter.cancelOrder(this);
        }
        else {
            throw new IllegalArgumentException(
                    "Can't change status from " + this.status + " to " + newStatus);
        }
        
        this.status = OrderStatus.PendingCancel;
    }

    public void cancelRequestRejected(OrderStatus newStatus) {
        this.status = newStatus;
    }

    // ----- Queries and Read-Only Operations -----
    @Transient
    public DecimalQuantity getLeavesQty() {
        return quantity.minus(getCumQty());
    }
    
    @Transient
    public DecimalQuantity getCumQty() {
        DecimalQuantity cumQty = new DecimalQuantity();
        for (Execution execution : executions) {
            cumQty = cumQty.plus(execution.getQuantity());
        }
        return cumQty; 
    }
    
    @Transient
    public Money getTotalPriceOfExecutions() {
        Money totalPrice = new Money("0.00");
        for (Execution execution : executions) {
            totalPrice = totalPrice.plus(
                    execution.getPrice().times(execution.getQuantity()));
        }
        return totalPrice.scaleToCurrency();
    }
    
    @Transient
    public Money getWeightedAveragePriceOfExecutions() {
        if (executions.size() == 0) {
            return new Money("0.00");
        }

        // Calculate weighted average
        Money totalPrice = new Money("0.00");
        DecimalQuantity totalQuantity = new DecimalQuantity();
        for (Execution execution : executions) {
            totalPrice = totalPrice.plus(
                    execution.getPrice().times(execution.getQuantity()));
            totalQuantity = totalQuantity.plus(execution.getQuantity());
        }
        totalPrice = totalPrice.scaleToCurrency();
        return totalPrice.div(totalQuantity, Constants.PRICE_SCALE);
    }
    
    @Transient
    private Money getFees() {
        return FIXED_FEE;
    }
    
    /**
     * Returns estimated price and compliance of the order.
     * 
     * @param pricingService
     * @return
     */
    public OrderEstimate calculateOrderEstimate(PricingService pricingService) {

        // Perform order level compliance
        if (type == OrderType.Limit && limitPrice == null) {
            return new OrderEstimate(OrderCompliance.LimitOrderWithNoLimitPrice);
        }
        
        // Calculate estimated values
        Money unitPrice = (type == OrderType.Market) ?
                pricingService.getMarketPrice(instrument) : limitPrice;
        Money estimatedValue = unitPrice.times(quantity).scaleToCurrency();
        Money fees = getFees();
        Money estimatedValueInclFees = (side==OrderSide.Buy) ?
                estimatedValue.plus(fees) : estimatedValue.minus(fees);
        return new OrderEstimate(estimatedValue, fees, estimatedValueInclFees);
    }
    
    /** Returns true if this order is active (New or PartiallyFilled) */
    @Transient
    public boolean isActive() {
        return
            (status==OrderStatus.New) ||
            (status==OrderStatus.PartiallyFilled) ||
            (status==OrderStatus.PendingNew) ||
            (status==OrderStatus.PendingCancel);
    }

    /** Returns true if this order is closed (Filled, Canceled or DoneForDay) */
    @Transient
    public boolean isClosed() {
        return
            (status==OrderStatus.Filled) ||
            (status==OrderStatus.Canceled) ||
            (status==OrderStatus.DoneForDay);
    }

    private boolean isStatusChangeValid(OrderStatus newStatus) {
        boolean result = false;
        switch (this.status) {
            case PendingNew:
                if (newStatus==OrderStatus.New)
                    result=true;
                break;
            case New:
            case PartiallyFilled:
                if (newStatus==OrderStatus.PartiallyFilled ||
                    newStatus==OrderStatus.Filled ||
                    newStatus==OrderStatus.PendingCancel ||
                    newStatus==OrderStatus.Canceled ||
                    newStatus==OrderStatus.DoneForDay)
                    result=true;
                break;
            case PendingCancel:
                if (newStatus==OrderStatus.Canceled)
                    result=true;
                break;
            case Filled:
            case Canceled:
            case DoneForDay:
            default:
                break;
        }
        
        return result;
    }
    
    @Override
    public int compareTo(Order that) {
        return this.id.compareTo(that.getId());
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append(DateTimeUtil.toStringTimestamp(creationTime)).append(" ");
        builder.append(id).append(": ");
        builder.append(side).append(" ");
        builder.append(instrument);
        builder.append(", quantity=").append(quantity);
        builder.append(", cumQy=").append(this.getCumQty());
        builder.append(", orderType=").append(type);
        builder.append(", limitPrice=").append(limitPrice);
        builder.append(", term=").append(term);
        builder.append(", allOrNone=").append(allOrNone);
        builder.append(", status=").append(status);
        return builder.toString();
    }

    // ----- Getters and Setters -----
    @Type(type = "org.joda.time.contrib.hibernate.PersistentDateTime")
    @Column(nullable = false)
    public DateTime getCreationTime() {
        return creationTime;
    }
    // Allow BrokerageAccount to access this method
    public void setCreationTime(DateTime creationTime) {
        this.creationTime = creationTime;
    }

    @NotNull
    @Type(
        type = "org.archfirst.common.hibernate.GenericEnumUserType",
        parameters = {
            @Parameter (
                name  = "enumClass",
                value = "org.archfirst.bfoms.domain.account.brokerage.order.OrderSide")
            }
        )
    @Column(nullable = false, length=Constants.ENUM_COLUMN_LENGTH)
    public OrderSide getSide() {
        return side;
    }
    private void setSide(OrderSide side) {
        this.side = side;
    }

    @NotNull
    @ManyToOne
    public Instrument getInstrument() {
        return instrument;
    }
    private void setInstrument(Instrument instrument) {
        this.instrument = instrument;
    }

    @NotNull
    @DecimalQuantityMin(value="1")
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name="value",
            column = @Column(
                    name="quantity",
                    precision=Constants.QUANTITY_PRECISION,
                    scale=Constants.QUANTITY_SCALE))})
    public DecimalQuantity getQuantity() {
        return quantity;
    }
    private void setQuantity(DecimalQuantity quantity) {
        this.quantity = quantity;
    }

    @NotNull
    @Type(
        type = "org.archfirst.common.hibernate.GenericEnumUserType",
        parameters = {
            @Parameter (
                name  = "enumClass",
                value = "org.archfirst.bfoms.domain.account.brokerage.order.OrderType")
            }
        )
    @Column(nullable = false, length=Constants.ENUM_COLUMN_LENGTH)
    public OrderType getType() {
        return type;
    }
    private void setType(OrderType type) {
        this.type = type;
    }

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name="amount",
            column = @Column(
                    name="limit_price_amount",
                    precision=Constants.PRICE_PRECISION,
                    scale=Constants.PRICE_SCALE)),
        @AttributeOverride(name="currency",
            column = @Column(
                    name="limit_price_currency",
                    length=Money.CURRENCY_LENGTH))
     })
    public Money getLimitPrice() {
        return limitPrice;
    }
    private void setLimitPrice(Money limitPrice) {
        this.limitPrice = limitPrice;
    }

    @NotNull
    @Type(
        type = "org.archfirst.common.hibernate.GenericEnumUserType",
        parameters = {
            @Parameter (
                name  = "enumClass",
                value = "org.archfirst.bfoms.domain.account.brokerage.order.OrderTerm")
            }
        )
    @Column(nullable = false, length=Constants.ENUM_COLUMN_LENGTH)
    public OrderTerm getTerm() {
        return term;
    }
    private void setTerm(OrderTerm term) {
        this.term = term;
    }

    public boolean isAllOrNone() {
        return allOrNone;
    }
    private void setAllOrNone(boolean allOrNone) {
        this.allOrNone = allOrNone;
    }

    @NotNull
    @Type(
        type = "org.archfirst.common.hibernate.GenericEnumUserType",
        parameters = {
            @Parameter (
                name  = "enumClass",
                value = "org.archfirst.bfoms.domain.account.brokerage.order.OrderStatus")
            }
        )
    @Column(nullable = false, length=Constants.ENUM_COLUMN_LENGTH)
    public OrderStatus getStatus() {
        return status;
    }
    private void setStatus(OrderStatus status) {
        this.status = status;
    }
    
    @ManyToOne
    public BrokerageAccount getAccount() {
        return account;
    }
    // Allow BrokerageAccount to access this method
    public void setAccount(BrokerageAccount account) {
        this.account = account;
    }
    
    @OneToMany(mappedBy="order",  cascade=CascadeType.ALL)
    public Set<Execution> getExecutions() {
        return executions;
    }
    private void setExecutions(Set<Execution> executions) {
        this.executions = executions;
    }

    private void addExecution(Execution execution) {
        executions.add(execution);
        execution.setOrder(this);
    }
}