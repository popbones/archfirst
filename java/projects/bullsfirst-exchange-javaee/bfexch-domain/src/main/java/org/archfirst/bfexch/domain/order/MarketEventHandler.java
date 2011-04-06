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

import javax.ejb.Schedule;
import javax.ejb.Stateless;
import javax.enterprise.event.Event;
import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * MarketEventHandler
 *
 * @author Naresh Bhatia
 */
@Stateless
public class MarketEventHandler {
    private static final Logger logger =
        LoggerFactory.getLogger(MarketEventHandler.class);

    @Inject private OrderRepository orderRepository;
    @Inject private Event<OrderDoneForDay> orderDoneForDayEvent;

    @Schedule(hour="16", minute="00", timezone="America/New_York")
    public void marketClosed() {
        logger.info("Processing market closed");
        List<Order> orders = orderRepository.findActiveGfdOrders();
        for (Order order : orders) {
            order.doneForDay();
            orderDoneForDayEvent.fire(new OrderDoneForDay(order));
        }
    }
}