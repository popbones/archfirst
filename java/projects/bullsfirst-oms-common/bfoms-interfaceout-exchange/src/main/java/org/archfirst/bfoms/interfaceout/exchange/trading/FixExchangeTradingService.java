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

import java.util.Date;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.MessageProducer;
import javax.jms.Session;

import org.archfirst.bfoms.domain.account.brokerage.order.Order;
import org.archfirst.bfoms.domain.exchange.ExchangeTradingService;
import org.archfirst.bfoms.infra.app.ConfigConstants;
import org.archfirst.bfoms.infra.fix.ClOrdIDConverter;
import org.archfirst.bfoms.infra.fix.FixFormatter;
import org.archfirst.bfoms.infra.fix.InstrumentConverter;
import org.archfirst.bfoms.infra.fix.MoneyConverter;
import org.archfirst.bfoms.infra.fix.OrderQuantityConverter;
import org.archfirst.bfoms.infra.fix.OrderSideConverter;
import org.archfirst.bfoms.infra.fix.OrderTermConverter;
import org.archfirst.bfoms.infra.fix.OrderTypeConverter;
import org.archfirst.bfoms.infra.fix.OrigClOrdIDConverter;
import org.archfirst.common.config.ConfigurationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import quickfix.Message;
import quickfix.field.ExecInst;
import quickfix.field.TransactTime;
import quickfix.fix44.NewOrderSingle;
import quickfix.fix44.OrderCancelRequest;

/**
 * FixExchangeTradingService
 *
 * @author Naresh Bhatia
 */
public class FixExchangeTradingService implements ExchangeTradingService {
    private static final Logger logger =
        LoggerFactory.getLogger(FixExchangeTradingService.class);
    
    @Resource(mappedName="jms/ConnectionFactory")
    private ConnectionFactory connectionFactory;

    @Resource(mappedName="jms/OmsToExchangeFixQueue")
    private Destination destination;

    @Inject private ConfigurationService configurationService;

    @Override
    public void placeOrder(Order order) {
        NewOrderSingle fixMessage = new NewOrderSingle(
                ClOrdIDConverter.toFix(getBrokerId(), order.getId()),
                OrderSideConverter.toFix(order.getSide()),
                new TransactTime(order.getCreationTime().toDate()),
                OrderTypeConverter.toFix(order.getType()));

        fixMessage.set(InstrumentConverter.toFix(order.getSymbol()));
        fixMessage.set(OrderQuantityConverter.toFix(order.getQuantity()));
        if (order.getLimitPrice() != null) {
            fixMessage.set(MoneyConverter.toFixPrice(order.getLimitPrice()));
            fixMessage.set(MoneyConverter.toFixCurrency(order.getLimitPrice()));
        }
        fixMessage.set(OrderTermConverter.toFix(order.getTerm()));
        if (order.isAllOrNone()) {
            fixMessage.set(new ExecInst(Character.toString(ExecInst.ALL_OR_NONE)));
        }

        sendFixMessage(fixMessage);
    }

    @Override
    public void cancelOrder(Order order) {
        OrderCancelRequest fixMessage = new OrderCancelRequest(
                OrigClOrdIDConverter.toFix(getBrokerId(), order.getId()),
                ClOrdIDConverter.toFix(getBrokerId(), order.getId()),
                OrderSideConverter.toFix(order.getSide()),
                new TransactTime(new Date()));

        fixMessage.set(InstrumentConverter.toFix(order.getSymbol()));
        fixMessage.set(OrderQuantityConverter.toFix(order.getQuantity()));

        sendFixMessage(fixMessage);
    }
    
    private void sendFixMessage(Message fixMessage) {
        
        logger.debug("Sending message:\n{}", FixFormatter.format(fixMessage));

        Connection connection = null;
        try {
            connection = connectionFactory.createConnection();
            Session session = connection.createSession(
                    false, Session.AUTO_ACKNOWLEDGE);
            MessageProducer producer = session.createProducer(destination);
            producer.send(session.createTextMessage(fixMessage.toString()));
        }
        catch (JMSException e) {
            throw new RuntimeException("Failed to send FIX message", e);
        }
        finally {
            if (connection != null)
                try {connection.close();} catch (Exception e) {}
        }
    }
    
    private String getBrokerId() {
        return configurationService.getString(ConfigConstants.PROP_BROKER_ID);
    }
}