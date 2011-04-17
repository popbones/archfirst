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
package org.archfirst.bfcommon.jsontrading;

import java.math.BigDecimal;

/**
 * ExecutionReport
 *
 * @author Naresh Bhatia
 */
public class ExecutionReport {
    private ExecutionReportType type;
    private String orderId;
    private String executionId;
    private String clientOrderId;
    private OrderStatus orderStatus;
    private OrderSide side;
    private String symbol;
    private BigDecimal lastQty;
    private BigDecimal leavesQty;
    private BigDecimal cumQty;
    private Money lastPrice;
    private Money weightedAvgPrice;

    // ----- Constructors -----
    public ExecutionReport() {
    }

    public ExecutionReport(
            ExecutionReportType type,
            String orderId,
            String executionId,
            String clientOrderId,
            OrderStatus orderStatus,
            OrderSide side,
            String symbol,
            BigDecimal lastQty,
            BigDecimal leavesQty,
            BigDecimal cumQty,
            Money lastPrice,
            Money weightedAvgPrice) {
        this.type = type;
        this.orderId = orderId;
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

    // ----- Getters and Setters -----
    public ExecutionReportType getType() {
        return type;
    }
    public void setType(ExecutionReportType type) {
        this.type = type;
    }

    public String getOrderId() {
        return orderId;
    }
    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getExecutionId() {
        return executionId;
    }
    public void setExecutionId(String executionId) {
        this.executionId = executionId;
    }

    public String getClientOrderId() {
        return clientOrderId;
    }
    public void setClientOrderId(String clientOrderId) {
        this.clientOrderId = clientOrderId;
    }

    public OrderStatus getOrderStatus() {
        return orderStatus;
    }
    public void setOrderStatus(OrderStatus orderStatus) {
        this.orderStatus = orderStatus;
    }

    public OrderSide getSide() {
        return side;
    }
    public void setSide(OrderSide side) {
        this.side = side;
    }

    public String getSymbol() {
        return symbol;
    }
    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public BigDecimal getLastQty() {
        return lastQty;
    }
    public void setLastQty(BigDecimal lastQty) {
        this.lastQty = lastQty;
    }

    public BigDecimal getLeavesQty() {
        return leavesQty;
    }
    public void setLeavesQty(BigDecimal leavesQty) {
        this.leavesQty = leavesQty;
    }

    public BigDecimal getCumQty() {
        return cumQty;
    }
    public void setCumQty(BigDecimal cumQty) {
        this.cumQty = cumQty;
    }

    public Money getLastPrice() {
        return lastPrice;
    }
    public void setLastPrice(Money lastPrice) {
        this.lastPrice = lastPrice;
    }

    public Money getWeightedAvgPrice() {
        return weightedAvgPrice;
    }
    public void setWeightedAvgPrice(Money weightedAvgPrice) {
        this.weightedAvgPrice = weightedAvgPrice;
    }
}