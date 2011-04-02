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
package org.archfirst.bfexch.interfacein.oms;

import javax.inject.Inject;

import org.archfirst.bfexch.domain.matchingengine.MatchingEngine;
import org.archfirst.bfexch.domain.order.Order;
import org.archfirst.bfexch.domain.order.OrderService;
import org.archfirst.bfexch.infra.fix.MoneyConverter;
import org.archfirst.bfexch.infra.fix.OrderQuantityConverter;
import org.archfirst.bfexch.infra.fix.OrderSideConverter;
import org.archfirst.bfexch.infra.fix.OrderTermConverter;
import org.archfirst.bfexch.infra.fix.OrderTypeConverter;
import org.archfirst.common.money.Money;
import org.joda.time.DateTime;
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
import quickfix.field.Currency;
import quickfix.field.ExecInst;
import quickfix.field.Price;
import quickfix.fix44.NewOrderSingle;
import quickfix.fix44.OrderCancelRequest;

/**
 * FixMessageProcessor
 *
 * @author Naresh Bhatia
 */
public class FixMessageProcessor
    extends MessageCracker implements quickfix.Application {

    private static final Logger logger =
        LoggerFactory.getLogger(FixMessageProcessor.class);

    @Inject private OrderService orderService;
    @Inject private MatchingEngine matchingEngine;

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
    public void onMessage(NewOrderSingle message, SessionID sessionID)
            throws FieldNotFound, UnsupportedMessageType, IncorrectTagValue {

        // Extract symbol
        String symbol = message.getInstrument().getSymbol().getValue();

        // Extract limit price
        Money limitPrice = null;
        if (message.isSetField(Price.FIELD) && message.isSetField(Currency.FIELD)) {
            limitPrice = MoneyConverter.toDomain(message.getPrice(), message.getCurrency());
        }

        // Extract allOrNone
        boolean allOrNone = message.isSetField(ExecInst.FIELD) &&
            message.getExecInst().getValue().indexOf(ExecInst.ALL_OR_NONE) >= 0;

        // Create Order
        Order order = new Order(
                new DateTime(message.getTransactTime().getValue()),
                message.getClOrdID().getValue(),
                OrderSideConverter.toDomain(message.getSide()),
                symbol,
                OrderQuantityConverter.toDomain(message.getOrderQtyData()),
                OrderTypeConverter.toDomain(message.getOrdType()),
                limitPrice,
                OrderTermConverter.toDomain(message.getTimeInForce()),
                allOrNone);

        // Place order
        matchingEngine.placeOrder(order);
    }

    @Override
    public void onMessage(OrderCancelRequest message, SessionID sessionID)
            throws FieldNotFound, UnsupportedMessageType, IncorrectTagValue {

        // Lookup order
        String clOrdID = message.getOrigClOrdID().getValue();
        Order order = orderService.findOrderByClientOrderId(clOrdID);
        if (order == null) {
            logger.error("OrderCancelRequest: clOrdID {} not found", clOrdID);
        }

        // Cancel it
        orderService.cancelOrder(order);
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