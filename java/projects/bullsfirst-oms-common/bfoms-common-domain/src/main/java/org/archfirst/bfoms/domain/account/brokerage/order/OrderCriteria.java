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

import java.util.ArrayList;
import java.util.List;

import org.joda.time.LocalDate;

/**
 * OrderCriteria
 *
 * @author Naresh Bhatia
 */
public class OrderCriteria {
    private Long accountId;
    private String symbol;
    private Long orderId;
    private LocalDate fromDate;
    private LocalDate toDate;
    // selectManyCheckbox does not work with a Set, had to use List
    private List<OrderSide> sides = new ArrayList<OrderSide>();
    private List<OrderStatus> statuses = new ArrayList<OrderStatus>();

    // ----- Commands -----
    /**
     * Clear all the criteria
     */
    public void clear() {
        accountId = null;
        symbol = null;
        orderId = null;
        fromDate = null;
        toDate = null;
        sides.clear();
        statuses.clear();
    }

    // ----- Queries and Read-Only Operations -----
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("\nAccountId: ").append(accountId);
        sb.append("\nOrderId: ").append(orderId);
        sb.append("\nSymbol: ").append(symbol);
        sb.append("\nFromDate: ").append(fromDate);
        sb.append("\nToDate: ").append(toDate);

        // Sides
        sb.append("\nSides: ");
        for (OrderSide side : sides)
        {
            sb.append(side).append(" ");
        }

        // Statuses
        sb.append("\nStatuses: ");
        for (OrderStatus status : statuses)
        {
            sb.append(status).append(" ");
        }

        return sb.toString();
    }

    // ----- Getters and Setters -----
    public Long getAccountId() {
        return accountId;
    }
    public void setAccountId(Long accountId) {
        this.accountId = accountId;
    }

    public String getSymbol() {
        return symbol;
    }
    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public Long getOrderId() {
        return orderId;
    }
    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public LocalDate getFromDate() {
        return fromDate;
    }
    public void setFromDate(LocalDate fromDate) {
        this.fromDate = fromDate;
    }

    public LocalDate getToDate() {
        return toDate;
    }
    public void setToDate(LocalDate toDate) {
        this.toDate = toDate;
    }

    public List<OrderSide> getSides() {
        return sides;
    }
    public void setSides(List<OrderSide> sides) {
        this.sides = sides;
    }

    public List<OrderStatus> getStatuses() {
        return statuses;
    }
    public void setStatuses(List<OrderStatus> statuses) {
        this.statuses = statuses;
    }
}