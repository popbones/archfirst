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

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import org.archfirst.bfoms.domain.account.Transaction;
import org.archfirst.bfoms.domain.account.brokerage.order.Order;
import org.archfirst.bfoms.domain.account.brokerage.order.OrderSide;
import org.archfirst.bfoms.domain.pricing.Instrument;
import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.archfirst.common.quantity.DecimalQuantityMin;
import org.hibernate.annotations.Parameter;
import org.hibernate.annotations.Type;
import org.joda.time.DateTime;

/**
 * Trade
 *
 * @author Naresh Bhatia
 */
@Entity
public class Trade extends Transaction {
    private static final long serialVersionUID = 1L;
    private static final String TYPE = "Trade";
    
    private OrderSide side;
    private Instrument instrument;
    private DecimalQuantity quantity;
    private Money totalPrice;
    private Money fees;
    private Order order;

    // ----- Constructors -----
    protected Trade() {
    }

    public Trade(
            DateTime creationTime,
            OrderSide side,
            Instrument instrument,
            DecimalQuantity quantity,
            Money totalPrice,
            Money fees,
            Order order) {
        super(creationTime);
        this.side = side;
        this.instrument = instrument;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
        this.fees = fees;
        this.order = order;
    }

    // ----- Commands -----

    // ----- Queries and Read-Only Operations -----
    @Transient
    public Money getPricePerShare() {
        return totalPrice.div(quantity, Constants.PRICE_SCALE);
    }

    // ----- Getters and Setters -----
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

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name="amount",
            column = @Column(
                    name="total_price_amount",
                    precision=Constants.MONEY_PRECISION,
                    scale=Constants.MONEY_SCALE)),
        @AttributeOverride(name="currency",
            column = @Column(
                    name="total_price_currency",
                    length=Money.CURRENCY_LENGTH))
     })
    public Money getTotalPrice() {
        return totalPrice;
    }
    private void setTotalPrice(Money totalPrice) {
        this.totalPrice = totalPrice;
    }

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name="amount",
            column = @Column(
                    name="fees_amount",
                    precision=Constants.MONEY_PRECISION,
                    scale=Constants.MONEY_SCALE)),
        @AttributeOverride(name="currency",
            column = @Column(
                    name="fees_currency",
                    length=Money.CURRENCY_LENGTH))
     })
    public Money getFees() {
        return fees;
    }
    private void setFees(Money fees) {
        this.fees = fees;
    }

    @NotNull
    @ManyToOne
    public Order getOrder() {
        return order;
    }
    private void setOrder(Order order) {
        this.order = order;
    }

    @Override
    @Transient
    public String getType() {
        return TYPE;
    }

    @Override
    @Transient
    public String getDescription() {
        StringBuilder builder = new StringBuilder();
        builder.append((side==OrderSide.Buy) ? "Bought " : "Sold ");
        builder.append(quantity).append(" shares of ");
        builder.append(instrument).append(" @ ");
        builder.append(getPricePerShare());
        return builder.toString();
    }

    @Override
    @Transient
    public Money getAmount() {
        Money transactionAmount = totalPrice.plus(fees);
        return (side==OrderSide.Sell) ?
                transactionAmount : transactionAmount.negate();
    }
}