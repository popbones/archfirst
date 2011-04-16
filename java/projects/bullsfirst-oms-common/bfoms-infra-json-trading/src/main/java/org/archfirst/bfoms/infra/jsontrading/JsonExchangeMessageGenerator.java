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

import org.archfirst.bfoms.domain.account.brokerage.order.Order;
import org.archfirst.bfoms.domain.exchange.ExchangeMessageGenerator;
import org.archfirst.bfoms.infra.app.ConfigConstants;
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

        // logger.debug("Sending message:\n{}", JsonFormatter.format(jsonMessage));
        return null;
    }

    @Override
    public String generateOrderCancelRequest(Order order) {

        // logger.debug("Sending message:\n{}", JsonFormatter.format(jsonMessage));
        return null;
    }

    private String getBrokerId() {
        return configurationService.getString(ConfigConstants.PROP_BROKER_ID);
    }
}