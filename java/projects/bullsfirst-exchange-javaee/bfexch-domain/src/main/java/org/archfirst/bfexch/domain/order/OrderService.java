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
package org.archfirst.bfexch.domain.order;

import java.util.List;

import javax.inject.Inject;

import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * OrderService
 *
 * @author Naresh Bhatia
 */
public class OrderService {
    private static final Logger logger =
        LoggerFactory.getLogger(OrderService.class);

    @Inject private OrderRepository orderRepository;
    @Inject private OrderEventPublisher orderEventPublisher;

    // ----- Commands -----
    /**
     * Sets order status to New and persists it.
     */
    public void acceptOrder(Order order) {
        order.accept(orderRepository);
        orderEventPublisher.publish(new OrderAccepted(order));
    }
    
    /**
     * Executes the order and adds an execution to it.
     */
    public void executeOrder(
            Order order,
            DateTime executionTime,
            DecimalQuantity executionQty,
            Money price) {
        Execution execution =
            order.execute(orderRepository, executionTime, executionQty, price);
        orderEventPublisher.publish(new OrderExecuted(execution));
    }

    /**
     * Cancels the order if the status change is valid
     */
    public void cancelOrder(Order order) {
        order.cancel();
        if (order.getStatus() == OrderStatus.Canceled) {
            orderEventPublisher.publish(new OrderCanceled(order));
        }
        else {
            orderEventPublisher.publish(new OrderCancelRejected(order));
        }
    }
    
    public void handleEndOfDay() {
        logger.info("Processing end of day event...");
        List<Order> orders = orderRepository.findActiveGfdOrders();
        logger.info("Marking {} orders as DoneForDay...");
        for (Order order : orders) {
            order.doneForDay();
            orderEventPublisher.publish(new OrderDoneForDay(order));
        }
        logger.info("Marked {} orders as DoneForDay");
    }

    // ----- Queries and Read-Only Operations -----
    public Order findOrderByClientOrderId(String clientOrderId) {
        return orderRepository.findOrderByClientOrderId(clientOrderId);
    }

    public List<Order> findActiveOrdersForInstrument(String symbol) {
        return orderRepository.findActiveOrdersForInstrument(symbol);
    }
}