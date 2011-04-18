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
package org.archfirst.bfoms.infra.jsontrading;

import javax.inject.Inject;

import org.archfirst.bfcommon.jsontrading.JsonMessage;
import org.archfirst.bfcommon.jsontrading.JsonMessageMapper;
import org.archfirst.bfcommon.jsontrading.MessageType;
import org.archfirst.bfcommon.jsontrading.NewOrderSingle;
import org.archfirst.bfcommon.jsontrading.OrderCancelRequest;
import org.archfirst.bfcommon.jsontrading.OrderSide;
import org.archfirst.bfcommon.jsontrading.OrderStatus;
import org.archfirst.bfcommon.jsontrading.OrderTerm;
import org.archfirst.bfcommon.jsontrading.OrderType;
import org.archfirst.bfoms.domain.account.brokerage.order.Order;
import org.archfirst.bfoms.domain.exchange.ExchangeMessageGenerator;
import org.archfirst.bfoms.infra.app.ConfigConstants;
import org.archfirst.bfoms.infra.jsontrading.converters.ClOrdIDConverter;
import org.archfirst.bfoms.infra.jsontrading.converters.MoneyConverter;
import org.archfirst.bfoms.infra.jsontrading.converters.QuantityConverter;
import org.archfirst.common.config.ConfigurationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * JsonExchangeMessageGenerator
 *
 * @author Naresh Bhatia
 */
public class JsonExchangeMessageGenerator implements ExchangeMessageGenerator {
    private static final Logger logger =
        LoggerFactory.getLogger(JsonExchangeMessageGenerator.class);

    @Inject private ConfigurationService configurationService;

    @Override
    public String generateNewOrderSingleMessage(Order order) {

        logger.debug("Generating NewOrderSingle: {}", order);

        // Create a JsonMessage with NewOrderSingle
        org.archfirst.bfcommon.jsontrading.Order jsonOrder =
            new org.archfirst.bfcommon.jsontrading.Order(
                    //order.getCreationTime(),
                    ClOrdIDConverter.toJson(getBrokerId(), order.getId()),
                    OrderSide.valueOf(order.getSide().toString()),
                    order.getSymbol(),
                    QuantityConverter.toJson(order.getQuantity()),
                    OrderType.valueOf(order.getType().toString()),
                    MoneyConverter.toJson(order.getLimitPrice()),
                    OrderTerm.valueOf(order.getTerm().toString()),
                    order.isAllOrNone(),
                    OrderStatus.valueOf(order.getStatus().toString()));
        NewOrderSingle newOrderSingle = new NewOrderSingle(jsonOrder);
        JsonMessage jsonMessage =
            new JsonMessage(MessageType.NewOrderSingle, newOrderSingle);

        // Write out the JsonMessage as a string
        JsonMessageMapper mapper = new JsonMessageMapper();
        String jsonMessageString = mapper.toString(jsonMessage);
        
        logger.debug("Sending message:\n{}", mapper.toFormattedString(jsonMessage));
        return jsonMessageString;
    }

    @Override
    public String generateOrderCancelRequest(Order order) {

        OrderCancelRequest orderCancelRequest = new OrderCancelRequest(
                ClOrdIDConverter.toJson(getBrokerId(), order.getId()));
        JsonMessage jsonMessage =
            new JsonMessage(MessageType.OrderCancelRequest, orderCancelRequest);

        // Write out the JsonMessage as a string
        JsonMessageMapper mapper = new JsonMessageMapper();
        String jsonMessageString = mapper.toString(jsonMessage);
        
        logger.debug("Sending message:\n{}", mapper.toFormattedString(jsonMessage));
        return jsonMessageString;
    }

    private String getBrokerId() {
        return configurationService.getString(ConfigConstants.PROP_BROKER_ID);
    }
}