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

import java.util.HashSet;
import java.util.Set;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement(name = "BrokerageAccount")
public class BrokerageAccount extends BaseAccount {

    @XmlElement(name = "CashPosition")
    private double cashPosition;

    @XmlElement(name = "Order")
    private Set<Order> orders = new HashSet<Order>();

    public BrokerageAccount() {
    }

    public BrokerageAccount(Long id, String name, double cashPosition) {
        super(id, name);
        this.cashPosition = cashPosition;
    }
    
    public void addOrder(Order order) {
        orders.add(order);
        order.setAccount(this);
    }

    public double getCashPosition() {
        return cashPosition;
    }
    public void setCashPosition(double cashPosition) {
        this.cashPosition = cashPosition;
    }

    public Set<Order> getOrders() {
        return orders;
    }
    public void setOrders(Set<Order> orders) {
        this.orders = orders;
    }
}