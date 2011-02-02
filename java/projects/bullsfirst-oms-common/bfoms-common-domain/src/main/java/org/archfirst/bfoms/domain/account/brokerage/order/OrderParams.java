/**
 * Copyright 2011 Archfirst
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

import java.math.BigDecimal;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

import org.archfirst.common.money.Money;

/**
 * OrderParams
 *
 * @author Naresh Bhatia
 */
@XmlAccessorType(XmlAccessType.FIELD)
public class OrderParams {

    @XmlElement(name = "Side", required = true)
    protected OrderSide side;
    @XmlElement(name = "Symbol", required = true)
    protected String symbol;
    @XmlElement(name = "Quantity", required = true)
    protected BigDecimal quantity;
    @XmlElement(name = "Type", required = true)
    protected OrderType type;
    @XmlElement(name = "LimitPrice", required = true, nillable = true)
    protected Money limitPrice;
    @XmlElement(name = "Term", required = true)
    protected OrderTerm term;
    @XmlElement(name = "AllOrNone")
    protected boolean allOrNone;

    // ----- Constructors -----
    public OrderParams() {
    }

    public OrderParams(
            OrderSide side,
            String symbol,
            BigDecimal quantity,
            OrderType type,
            Money limitPrice,
            OrderTerm term,
            boolean allOrNone) {
        this.side = side;
        this.symbol = symbol;
        this.quantity = quantity;
        this.type = type;
        this.limitPrice = limitPrice;
        this.term = term;
        this.allOrNone = allOrNone;
    }

    // ----- Getters and Setters -----
    public OrderSide getSide() {
        return side;
    }
    public void setSide(OrderSide value) {
        this.side = value;
    }

    public String getSymbol() {
        return symbol;
    }
    public void setSymbol(String value) {
        this.symbol = value;
    }

    public BigDecimal getQuantity() {
        return quantity;
    }
    public void setQuantity(BigDecimal value) {
        this.quantity = value;
    }

    public OrderType getType() {
        return type;
    }
    public void setType(OrderType value) {
        this.type = value;
    }

    public Money getLimitPrice() {
        return limitPrice;
    }
    public void setLimitPrice(Money value) {
        this.limitPrice = value;
    }

    public OrderTerm getTerm() {
        return term;
    }
    public void setTerm(OrderTerm value) {
        this.term = value;
    }

    public boolean isAllOrNone() {
        return allOrNone;
    }
    public void setAllOrNone(boolean value) {
        this.allOrNone = value;
    }
}