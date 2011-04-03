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
package org.archfirst.bfexch.interfaceout.oms;

import javax.annotation.Resource;
import javax.enterprise.event.Observes;
import javax.inject.Inject;
import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.MessageProducer;
import javax.jms.Session;

import org.archfirst.bfexch.domain.order.ExecutionReport;
import org.archfirst.bfexch.domain.order.Order;
import org.archfirst.bfexch.domain.order.OrderAccepted;
import org.archfirst.bfexch.domain.order.OrderCancelRejected;
import org.archfirst.bfexch.domain.order.OrderCanceled;
import org.archfirst.bfexch.domain.order.OrderExecuted;
import org.archfirst.bfexch.infra.fix.AvgPriceConverter;
import org.archfirst.bfexch.infra.fix.ClOrdIDParser;
import org.archfirst.bfexch.infra.fix.CumQtyConverter;
import org.archfirst.bfexch.infra.fix.ExecutionTypeConverter;
import org.archfirst.bfexch.infra.fix.FixFormatter;
import org.archfirst.bfexch.infra.fix.InstrumentConverter;
import org.archfirst.bfexch.infra.fix.LastPriceConverter;
import org.archfirst.bfexch.infra.fix.LastQtyConverter;
import org.archfirst.bfexch.infra.fix.LeavesQtyConverter;
import org.archfirst.bfexch.infra.fix.OrderSideConverter;
import org.archfirst.bfexch.infra.fix.OrderStatusConverter;
import org.archfirst.common.money.Money;
import org.archfirst.common.quantity.DecimalQuantity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import quickfix.Message;
import quickfix.field.ClOrdID;
import quickfix.field.CxlRejResponseTo;
import quickfix.field.ExecID;
import quickfix.field.OrderID;
import quickfix.field.OrigClOrdID;

/**
 * FixBrokerAdapter
 *
 * @author Naresh Bhatia
 */
public class FixBrokerAdapter {
    private static final Logger logger =
        LoggerFactory.getLogger(FixBrokerAdapter.class);

    @Resource(mappedName="jms/ConnectionFactory")
    private ConnectionFactory connectionFactory;

    @Inject private DestinationDictionary destinationDictionary;

    public void onOrderAccepted(@Observes OrderAccepted event) {
        sendExecutionReport(ExecutionReport.createNewType(event.getOrder()));
    }

    public void onOrderExecuted(@Observes OrderExecuted event) {
        sendExecutionReport(ExecutionReport.createTradeType(event.getExecution()));
    }

    public void onOrderCanceled(@Observes OrderCanceled event) {
        sendExecutionReport(ExecutionReport.createCanceledType(event.getOrder()));
    }

    public void onOrderCancelRejected(@Observes OrderCancelRejected event) {
        sendOrderCancelRejected(event.getOrder());
    }

    private void sendExecutionReport(ExecutionReport executionReport) {

        // Initialize executionId - it is a required FIX field
        String executionId =  executionReport.getExecutionId();
        if (executionId == null) {
            executionId = "0";
        }

        // Initialize lastQty - it is a required FIX field
        DecimalQuantity lastQty = executionReport.getLastQty();
        if (lastQty == null) {
            lastQty = new DecimalQuantity("0");
        }

        // Initialize lastPrice - it is a required FIX field
        Money lastPrice = executionReport.getLastPrice();
        if (lastPrice == null) {
            lastPrice = new Money("0.00");
        }

        // Now create the FIX message
        quickfix.fix44.ExecutionReport fixMessage =
            new quickfix.fix44.ExecutionReport(
                    new OrderID(executionReport.getOrderId().toString()),
                    new ExecID(executionId),
                    ExecutionTypeConverter.toFix(executionReport.getType()),
                    OrderStatusConverter.toFix(executionReport.getOrderStatus()),
                    OrderSideConverter.toFix(executionReport.getSide()),
                    LeavesQtyConverter.toFix(executionReport.getLeavesQty()),
                    CumQtyConverter.toFix(executionReport.getCumQty()),
                    AvgPriceConverter.toFix(executionReport.getWeightedAvgPrice()));

        fixMessage.set(new ClOrdID(executionReport.getClientOrderId()));
        fixMessage.set(InstrumentConverter.toFix(executionReport.getSymbol()));
        fixMessage.set(LastQtyConverter.toFix(lastQty));
        fixMessage.set(LastPriceConverter.toFix(lastPrice));

        sendFixMessage(
                ClOrdIDParser.getBrokerId(executionReport.getClientOrderId()),
                fixMessage);
    }

    private void sendOrderCancelRejected(Order order) {
        quickfix.fix44.OrderCancelReject fixMessage =
            new quickfix.fix44.OrderCancelReject(
                    new OrderID(order.getId().toString()),
                    new ClOrdID(order.getClientOrderId()),
                    new OrigClOrdID(order.getClientOrderId()),
                    OrderStatusConverter.toFix(order.getStatus()),
                    new CxlRejResponseTo(CxlRejResponseTo.ORDER_CANCEL_REQUEST));

        sendFixMessage(
                ClOrdIDParser.getBrokerId(order.getClientOrderId()),
                fixMessage);
    }

    private void sendFixMessage(final String brokerId, Message fixMessage) {
        
        logger.debug("Sending message to {}:\n{}",
                brokerId, FixFormatter.format(fixMessage));
        Destination destination =
            destinationDictionary.getBrokerDestination(brokerId);

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
}