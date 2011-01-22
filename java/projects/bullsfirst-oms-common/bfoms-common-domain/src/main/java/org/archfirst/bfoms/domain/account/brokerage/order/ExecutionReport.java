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

import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;

/**
 * ExecutionReport
 *
 * @author Naresh Bhatia
 */
public class ExecutionReport {
    private final ExecutionReportType type;
    private final String exchangeOrderId;
    private final String executionId;
    private final Long clientOrderId;
    private final OrderStatus orderStatus;
    private final OrderSide side;
    private final String symbol;
    private final DecimalQuantity lastQty;
    private final DecimalQuantity leavesQty;
    private final DecimalQuantity cumQty;
    private final Money lastPrice;
    private final Money weightedAvgPrice;

    // ----- Constructors -----
    /**
     * Constructs an ExecutionReport
     * 
     * @param type
     * @param order
     * @param execution is optional. For example, an execution report of type
     * New simply acknowledges a new order - there is no execution associated
     * with this report.
     */
    public ExecutionReport(
            ExecutionReportType type,
            String exchangeOrderId,
            String executionId,
            Long clientOrderId,
            OrderStatus orderStatus,
            OrderSide side,
            String symbol,
            DecimalQuantity lastQty,
            DecimalQuantity leavesQty,
            DecimalQuantity cumQty,
            Money lastPrice,
            Money weightedAvgPrice) {
        this.type = type;
        this.exchangeOrderId = exchangeOrderId;
        this.executionId = executionId;
        this.clientOrderId = clientOrderId;
        this.orderStatus = orderStatus;
        this.side = side;
        this.symbol = symbol;
        this.lastQty = lastQty;
        this.leavesQty = leavesQty;
        this.cumQty = cumQty;
        this.lastPrice = lastPrice;
        this.weightedAvgPrice = weightedAvgPrice;
    }

    // ----- Getters -----
    public ExecutionReportType getType() {
        return type;
    }
    public String getExchangeOrderId() {
        return exchangeOrderId;
    }
    public String getExecutionId() {
        return executionId;
    }
    public Long getClientOrderId() {
        return clientOrderId;
    }
    public OrderStatus getOrderStatus() {
        return orderStatus;
    }
    public OrderSide getSide() {
        return side;
    }
    public String getSymbol() {
        return symbol;
    }
    public DecimalQuantity getLastQty() {
        return lastQty;
    }
    public DecimalQuantity getLeavesQty() {
        return leavesQty;
    }
    public DecimalQuantity getCumQty() {
        return cumQty;
    }
    public Money getLastPrice() {
        return lastPrice;
    }
    public Money getWeightedAvgPrice() {
        return weightedAvgPrice;
    }
}