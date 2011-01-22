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
package org.archfirst.bfoms.domain.marketdata;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.validation.constraints.NotNull;

import org.archfirst.bfoms.domain.util.Constants;
import org.archfirst.common.datetime.DateTimeUtil;
import org.archfirst.common.domain.DomainEntity;
import org.archfirst.common.money.Money;
import org.hibernate.annotations.Type;
import org.joda.time.DateTime;

/**
 * MarketPrice
 *
 * @author Naresh Bhatia
 */
@Entity
public class MarketPrice extends DomainEntity {
    private static final long serialVersionUID = 1L;

    private String symbol;
    private Money price;
    private DateTime effective;

    // ----- Constructors -----
    private MarketPrice() {
    }

    public MarketPrice(String symbol, Money price, DateTime effective) {
        this.symbol = symbol;
        this.price = price;
        this.effective = effective;
    }

    // ----- Commands -----
    /**
     * Business method to change market price. Also updates the effective date
     * @param price
     */
    public void change(Money price) {
        this.price = price;
        this.effective = new DateTime();
    }

    // ----- Queries and Read-Only Operations -----
    /**
     * Returns this object as a set of properties. For example:
     * <code>
     *     instrument=AAPL 
     *     price=1.0645
     *     currency=USD
     *     effective=2009-01-02T09:00:00.000-04:00
     * </code>
     * 
     * @return this object as a set of properties
     */
    public String toProperties() {
        StringBuilder builder = new StringBuilder();
        builder.append("symbol=").append(symbol).append("\n");
        builder.append("price=").append(price.getAmount()).append("\n");
        builder.append("currency=").append(price.getCurrency()).append("\n");
        builder.append("effective=").append(effective.toString()).append("\n");
        return builder.toString();
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append("[").append(DateTimeUtil.toStringTimestamp(effective)).append("] ");
        builder.append(symbol).append(": ");
        builder.append(price);
        return builder.toString();
    }

    // ----- Getters and Setters -----
    @Type(type = "org.joda.time.contrib.hibernate.PersistentDateTime")
    @Column(nullable = false)
    public DateTime getEffective() {
        return effective;
    }
    private void setEffective(DateTime effective) {
        this.effective = effective;
    }

    @NotNull
    @Column(nullable = false)
    public String getSymbol() {
        return symbol;
    }
    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name="amount",
            column = @Column(
                    name="price_amount",
                    precision=Constants.PRICE_PRECISION,
                    scale=Constants.PRICE_SCALE)),
        @AttributeOverride(name="currency",
            column = @Column(
                    name="price_currency",
                    length=Money.CURRENCY_LENGTH))
     })
    public Money getPrice() {
        return price;
    }
    private void setPrice(Money price) {
        this.price = price;
    }
}