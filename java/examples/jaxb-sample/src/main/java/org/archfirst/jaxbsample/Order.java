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
package org.archfirst.jaxbsample;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;

@XmlAccessorType(XmlAccessType.FIELD)
public class Order extends DomainEntity {

    @XmlElement(name = "Side")
    private String side;

    @XmlElement(name = "Symbol")
    private String symbol;

    @XmlElement(name = "Quantity")
    private int quantity;

    // Break the BrokerageAccount -> Order cycle
    @XmlTransient
    private BrokerageAccount account;

    public Order() {
    }

    public Order(Long id, String side, String symbol, int quantity) {
        super(id);
        this.side = side;
        this.symbol = symbol;
        this.quantity = quantity;
    }

    public String getSide() {
        return side;
    }
    public void setSide(String side) {
        this.side = side;
    }
    
    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append(getId()).append(": ");
        builder.append(side).append(" ");
        builder.append(symbol);
        builder.append(", quantity=").append(quantity);
        builder.append(", account=");
        builder.append((account == null) ? "null" : account.getId());
        return builder.toString();
    }

    public String getSymbol() {
        return symbol;
    }
    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BrokerageAccount getAccount() {
        return account;
    }
    public void setAccount(BrokerageAccount account) {
        this.account = account;
    }
}