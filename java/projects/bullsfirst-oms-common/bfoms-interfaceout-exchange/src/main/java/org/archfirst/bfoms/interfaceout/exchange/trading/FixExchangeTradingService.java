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
package org.archfirst.bfoms.interfaceout.exchange.trading;

import javax.annotation.Resource;
import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.MessageProducer;
import javax.jms.Session;
import javax.jms.TextMessage;

import org.archfirst.bfoms.domain.account.brokerage.order.Order;
import org.archfirst.bfoms.domain.exchange.ExchangeTradingService;

/**
 * FixExchangeTradingService
 *
 * @author Naresh Bhatia
 */
public class FixExchangeTradingService implements ExchangeTradingService {
    
    @Resource(mappedName="jms/ConnectionFactory")
    private ConnectionFactory connectionFactory;
    @Resource(mappedName="jms/OmsToExchangeFixQueue")
    private Destination destination;

    @Override
    public void placeOrder(Order order) {
        
        Connection connection = null;;
        try {
            connection = connectionFactory.createConnection();
            connection.start();
            Session session = connection.createSession(
                    false, Session.AUTO_ACKNOWLEDGE);
            MessageProducer producer = session.createProducer(destination);
            TextMessage message = session.createTextMessage("Place order");
            producer.send(message);
        }
        catch (JMSException e) {
            throw new RuntimeException("Failed to send PlaceOrder message", e);
        }
        finally {
            if (connection != null)
                try {connection.close();} catch (Exception e) {}
        }
    }

    @Override
    public void cancelOrder(Order order) {
    }
}