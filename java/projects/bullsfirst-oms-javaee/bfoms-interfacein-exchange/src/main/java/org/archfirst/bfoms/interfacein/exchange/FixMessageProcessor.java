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
package org.archfirst.bfoms.interfacein.exchange;

import javax.inject.Inject;

import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccount;
import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccountService;
import org.archfirst.bfoms.domain.account.brokerage.order.Order;
import org.archfirst.bfoms.infra.fix.AvgPriceConverter;
import org.archfirst.bfoms.infra.fix.ClOrdIDConverter;
import org.archfirst.bfoms.infra.fix.CumQtyConverter;
import org.archfirst.bfoms.infra.fix.ExecutionTypeConverter;
import org.archfirst.bfoms.infra.fix.LastPriceConverter;
import org.archfirst.bfoms.infra.fix.LastQtyConverter;
import org.archfirst.bfoms.infra.fix.LeavesQtyConverter;
import org.archfirst.bfoms.infra.fix.OrderSideConverter;
import org.archfirst.bfoms.infra.fix.OrderStatusConverter;
import org.archfirst.bfoms.infra.fix.OrigClOrdIDConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import quickfix.DoNotSend;
import quickfix.FieldNotFound;
import quickfix.IncorrectDataFormat;
import quickfix.IncorrectTagValue;
import quickfix.Message;
import quickfix.MessageCracker;
import quickfix.RejectLogon;
import quickfix.SessionID;
import quickfix.UnsupportedMessageType;
import quickfix.fix44.ExecutionReport;
import quickfix.fix44.OrderCancelReject;

/**
 * FixMessageProcessor
 *
 * @author Naresh Bhatia
 */
public class FixMessageProcessor
    extends MessageCracker implements quickfix.Application {

    private static final Logger logger =
        LoggerFactory.getLogger(FixMessageProcessor.class);

    @Inject private BrokerageAccountService brokerageAccountService;

    public FixMessageProcessor() {
        logger.debug("FixMessageProcessor created");
    }

    @Override
    public void fromAdmin(Message message, SessionID sessionId)
            throws FieldNotFound, IncorrectDataFormat, IncorrectTagValue, RejectLogon {
    }

    @Override
    public void fromApp(Message message, SessionID sessionId)
            throws FieldNotFound, IncorrectDataFormat, IncorrectTagValue, UnsupportedMessageType {
        crack(message, sessionId);
    }

    @Override
    public void onMessage(ExecutionReport message, SessionID sessionID)
            throws FieldNotFound, UnsupportedMessageType, IncorrectTagValue {

        // Extract symbol
        String symbol = message.getInstrument().getSymbol().getValue();

        // Extract execution report
        org.archfirst.bfoms.domain.account.brokerage.order.ExecutionReport executionReport =
            new org.archfirst.bfoms.domain.account.brokerage.order.ExecutionReport(
                    ExecutionTypeConverter.toDomain(message.getExecType()),
                    message.getOrderID().getValue(),
                    message.getExecID().getValue(),
                    ClOrdIDConverter.toDomain(message.getClOrdID()),
                    OrderStatusConverter.toDomain(message.getOrdStatus()),
                    OrderSideConverter.toDomain(message.getSide()),
                    symbol,
                    LastQtyConverter.toDomain(message.getLastQty()),
                    LeavesQtyConverter.toDomain(message.getLeavesQty()),
                    CumQtyConverter.toDomain(message.getCumQty()),
                    LastPriceConverter.toDomain(message.getLastPx()),
                    AvgPriceConverter.toDomain(message.getAvgPx()));

        // Send to account for processing
        BrokerageAccount account = brokerageAccountService.findAccountForOrder(
                executionReport.getClientOrderId());
        brokerageAccountService.processExecutionReport(
                account.getId(), executionReport);
    }

    @Override
    public void onMessage(OrderCancelReject message, SessionID sessionID)
            throws FieldNotFound, UnsupportedMessageType, IncorrectTagValue {

        // Get the order
        Long orderId = OrigClOrdIDConverter.toDomain(message.getOrigClOrdID());
        Order order = brokerageAccountService.findOrder(orderId);
        if (order == null) {
            logger.error("OrderCancelReject: order {} not found", orderId);
        }

        // Send it the new status
        order.cancelRequestRejected(
                OrderStatusConverter.toDomain(message.getOrdStatus()));
    }

    @Override
    public void onCreate(SessionID sessionId) {
    }

    @Override
    public void onLogon(SessionID sessionId) {
    }

    @Override
    public void onLogout(SessionID sessionId) {
    }

    @Override
    public void toAdmin(Message message, SessionID sessionId) {
    }

    @Override
    public void toApp(Message message, SessionID sessionId) throws DoNotSend {
    }
}