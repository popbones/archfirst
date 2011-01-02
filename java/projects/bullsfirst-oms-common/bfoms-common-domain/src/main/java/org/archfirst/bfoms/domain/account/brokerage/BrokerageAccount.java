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
package org.archfirst.bfoms.domain.account.brokerage;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.OneToMany;
import javax.persistence.Transient;

import org.archfirst.bfoms.domain.account.AccountStatus;
import org.archfirst.bfoms.domain.account.BaseAccount;
import org.archfirst.bfoms.domain.account.OwnershipType;
import org.archfirst.bfoms.domain.account.brokerage.order.ExecutionReport;
import org.archfirst.bfoms.domain.account.brokerage.order.Order;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderCompliance;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderEstimate;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderSide;
import org.archfirst.bfoms.domain.account.position.AccountPosition;
import org.archfirst.bfoms.domain.account.position.CashPosition;
import org.archfirst.bfoms.domain.account.position.InstrumentPosition;
import org.archfirst.bfoms.domain.pricing.Instrument;
import org.archfirst.bfoms.domain.pricing.PricingService;
import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.hibernate.annotations.Parameter;
import org.hibernate.annotations.Type;
import org.joda.time.DateTime;

/**
 * BrokerageAccount
 *
 * @author Naresh Bhatia
 */
@Entity
public class BrokerageAccount extends BaseAccount {
    private static final long serialVersionUID = 1L;
    
    private OwnershipType ownershipType = OwnershipType.Individual;
    private Money cashPosition = new Money("0.00");
    private Set<Order> orders = new HashSet<Order>();
    private Set<Lot> lots = new HashSet<Lot>();

    // ----- Constructors -----
    private BrokerageAccount() {
    }

    // Allow access only from AccountService
    BrokerageAccount(String name, AccountStatus status,
            OwnershipType ownershipType, Money cashPosition) {
        super(name, status);
        this.ownershipType = ownershipType;
        this.cashPosition = cashPosition;
    }

    // ----- Commands -----
    @Override
    protected void deposit(Money amount) {
        cashPosition = cashPosition.plus(amount);
    }

    @Override
    protected void withdraw(Money amount) {
        cashPosition = cashPosition.minus(amount);
    }

    @Override
    protected void deposit(
            Instrument instrument,
            DecimalQuantity quantity,
            Money pricePaidPerShare,
            Allocatable allocatable,
            BrokerageAccountRepository accountRepository) {
        List<Lot> lots =
            accountRepository.findActiveLots(this, instrument);
        DecimalQuantity quantityLeftToDeposit = quantity;

        // First deposit to lots that have negative quantity
        for (Lot lot : lots) {
            DecimalQuantity lotQuantity = lot.getQuantity();
            if (lotQuantity.isMinus()) {
                DecimalQuantity depositQuantity = lotQuantity.negate();
                lot.buy(depositQuantity, pricePaidPerShare);
                allocatable.allocate(depositQuantity, lot);
                quantityLeftToDeposit = quantityLeftToDeposit.minus(depositQuantity);
                if (quantityLeftToDeposit.isZero()) {
                    break;
                }
            }
        }

        if (quantityLeftToDeposit.isPlus()) {
            this.createLot(
                    instrument,
                    quantityLeftToDeposit,
                    pricePaidPerShare,
                    allocatable,
                    accountRepository);
        }
    }

    @Override
    protected void withdraw(
            Instrument instrument,
            DecimalQuantity quantity,
            Allocatable allocatable,
            BrokerageAccountRepository accountRepository) {
        List<Lot> lots =
            accountRepository.findActiveLots(this, instrument);
        DecimalQuantity quantityLeftToWithdraw = quantity;
        for (Lot lot : lots) {
            DecimalQuantity lotQuantity = lot.getQuantity();
            if (lotQuantity.isMinus()) {
                continue;
            }
            DecimalQuantity withdrawQuantity =
                (lotQuantity.gteq(quantityLeftToWithdraw)) ?
                        quantityLeftToWithdraw : lotQuantity;
            lot.sell(withdrawQuantity);
            allocatable.allocate(withdrawQuantity.negate(), lot);
            quantityLeftToWithdraw = quantityLeftToWithdraw.minus(withdrawQuantity);
            if (quantityLeftToWithdraw.isZero()) {
                break;
            }
        }
        if (quantityLeftToWithdraw.isPlus()) {
            // This should ideally not happen, but it could if a long standing
            // sell order gets executed. Just create a lot with negative quantity.
            this.createLot(
                    instrument,
                    quantityLeftToWithdraw.negate(),
                    new Money("0.00"),
                    allocatable,
                    accountRepository);
        }
    }
    
    private void createLot(
            Instrument instrument,
            DecimalQuantity quantity,
            Money pricePaidPerShare,
            Allocatable allocatable,
            BrokerageAccountRepository accountRepository) {
        Lot lot = new Lot(
                new DateTime(),
                instrument,
                quantity,
                pricePaidPerShare);
        this.addLot(lot, accountRepository);
        allocatable.allocate(quantity, lot);
    }

    public void placeOrder(Order order, BrokerageAccountRepository accountRepository) {
        order.setCreationTime(new DateTime());
        this.addOrder(order, accountRepository);
    }
    
    public void processExecutionReport(
            ExecutionReport executionReport, BrokerageAccountRepository accountRepository) {
        Order order =
            accountRepository.findOrder(executionReport.getClientOrderId());
        Trade trade = order.processExecutionReport(executionReport, accountRepository);
        if (trade != null) {
            if (trade.getSide() == OrderSide.Buy) {
                this.withdraw(
                        trade.getAmount().negate());
                this.deposit(
                        trade.getInstrument(),
                        trade.getQuantity(),
                        trade.getPricePerShare(),
                        trade,
                        accountRepository);
            }
            else {
                this.withdraw(
                        trade.getInstrument(),
                        trade.getQuantity(),
                        trade,
                        accountRepository);
                this.deposit(
                        trade.getAmount());
            }
            this.addTransaction(trade);
        }
    }

    // ----- Queries and Read-Only Operations -----
    public AccountPosition calculatePosition(
            BrokerageAccountRepository accountRepository, PricingService pricingService) {
        List<Lot> lots = accountRepository.findActiveLots(this);
        AccountPosition accountPosition = this.assemblePosition(lots, pricingService);
        accountPosition.calculate();
        return accountPosition;
    }
    
    private AccountPosition assemblePosition(
            List<Lot> lots, PricingService pricingService) {
        AccountPosition accountPosition = new AccountPosition(id, name);
        Instrument instrument = null;
        InstrumentPosition instrumentPosition = null;
        for (Lot lot : lots) {
            // If there is a change in instrument, then create a new instumentPosition
            if (instrument==null || !instrument.equals(lot.getInstrument())) {
                instrument = lot.getInstrument();
                instrumentPosition = new InstrumentPosition(
                        instrument.getName(),
                        instrument.getSymbol(),
                        pricingService.getMarketPrice(instrument));
                accountPosition.addChild(instrumentPosition);
            }
            
            instrumentPosition.addChild(lot.assemblePosition(pricingService));
        }
        
        // Lastly add a cash position
        accountPosition.addChild(new CashPosition(cashPosition));
        
        return accountPosition;
    }

    @Override
    public boolean isCashAvailable(
            Money amount,
            BrokerageAccountRepository accountRepository,
            PricingService pricingService) {
        return amount.lteq(
                calculateCashAvailable(accountRepository, pricingService));
    }
    
    public Money calculateCashAvailable(
            BrokerageAccountRepository accountRepository, PricingService pricingService) {

        Money cashAvailable = cashPosition;
        
        // Reduce cash available by estimated cost of buy orders
        List<Order> orders = accountRepository.findActiveBuyOrders(this);
        for (Order order : orders) {
            OrderEstimate orderEstimate =
                order.calculateOrderEstimate(pricingService);
            cashAvailable =
                cashAvailable.minus(orderEstimate.getEstimatedValueInclFees());
        }
        
        return cashAvailable;
    }
    

    @Override
    public boolean isSecurityAvailable(
            Instrument instrument,
            DecimalQuantity quantity,
            BrokerageAccountRepository accountRepository) {
        return quantity.lteq(
                calculateSecurityAvailable(instrument, accountRepository));
    }
    
    public DecimalQuantity calculateSecurityAvailable(
            Instrument instrument, BrokerageAccountRepository accountRepository) {

        DecimalQuantity securityAvailable =
            accountRepository.getNumberOfShares(this, instrument);

        // Reduce security available by estimated quantity of sell orders
        List<Order> orders =
            accountRepository.findActiveSellOrders(this, instrument);
        for (Order order : orders) {
            securityAvailable = securityAvailable.minus(order.getQuantity());
        }
        
        return securityAvailable;
    }

    public OrderEstimate calculateOrderEstimate(
            Order order,
            BrokerageAccountRepository accountRepository,
            PricingService pricingService) {

        OrderEstimate orderEstimate = order.calculateOrderEstimate(pricingService);

        // Determine account level compliance
        if (orderEstimate.getCompliance() == null) {
            OrderCompliance compliance = (order.getSide() == OrderSide.Buy) ?
                    calculateBuyOrderCompliance(order, accountRepository, pricingService) :
                    calculateSellOrderCompliance(order, accountRepository);
            orderEstimate.setCompliance(compliance);
        }

        return orderEstimate;
    }
    
    private OrderCompliance calculateBuyOrderCompliance(
            Order order,
            BrokerageAccountRepository accountRepository,
            PricingService pricingService) {

        // Check if sufficient cash is available
        OrderEstimate orderEstimate = order.calculateOrderEstimate(pricingService);
        return isCashAvailable(
                orderEstimate.getEstimatedValueInclFees(),
                accountRepository,
                pricingService) ?
                    OrderCompliance.Compliant :
                    OrderCompliance.InsufficientFunds;
    }

    private OrderCompliance calculateSellOrderCompliance(
            Order order, BrokerageAccountRepository accountRepository) {

        // Check if sufficient securities are available
        return isSecurityAvailable(
                order.getInstrument(), order.getQuantity(), accountRepository) ?
                OrderCompliance.Compliant : OrderCompliance.InsufficientQuantity;
    }


    @Transient
    public String getDisplayString() {
        return toString();
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append(name).append(" - ");
        builder.append(id).append(" | ");
        builder.append(cashPosition);
        return builder.toString();
    }

    // ----- Getters and Setters -----
    @Type(
        type = "org.archfirst.common.hibernate.GenericEnumUserType",
        parameters = {
            @Parameter (
                name  = "enumClass",
                value = "org.archfirst.bfoms.domain.trading.OwnershipType")
            }
    )
    @Column(length=Constants.ENUM_COLUMN_LENGTH)
    public OwnershipType getOwnershipType() {
        return ownershipType;
    }
    private void setOwnershipType(OwnershipType ownershipType) {
        this.ownershipType = ownershipType;
    }

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name="amount",
            column = @Column(
                    name="cashpos_amount",
                    precision=Constants.MONEY_PRECISION,
                    scale=Constants.MONEY_SCALE)),
        @AttributeOverride(name="currency",
            column = @Column(
                    name="cashpos_currency",
                    length=Money.CURRENCY_LENGTH))
     })
    public Money getCashPosition() {
        return cashPosition;
    }
    private void setCashPosition(Money cashPosition) {
        this.cashPosition = cashPosition;
    }

    @OneToMany(mappedBy="account",  cascade=CascadeType.ALL)
    public Set<Order> getOrders() {
        return orders;
    }
    private void setOrders(Set<Order> orders) {
        this.orders = orders;
    }

    private void addOrder(Order order, BrokerageAccountRepository accountRepository) {
        order.setAccount(this);
        accountRepository.persist(order);
        accountRepository.flush(); // get order id before adding to set
        orders.add(order);
    }

    @OneToMany(mappedBy="account",  cascade=CascadeType.ALL)
    public Set<Lot> getLots() {
        return lots;
    }
    private void setLots(Set<Lot> lots) {
        this.lots = lots;
    }
    
    private void addLot(Lot lot, BrokerageAccountRepository accountRepository) {
        lot.setAccount(this);
        accountRepository.persist(lot);
        accountRepository.flush(); // get lot id before adding to set
        lots.add(lot);
    }
}