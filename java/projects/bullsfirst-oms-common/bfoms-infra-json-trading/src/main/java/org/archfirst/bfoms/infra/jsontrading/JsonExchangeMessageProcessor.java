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

import org.archfirst.bfoms.domain.account.brokerage.BrokerageAccountService;
import org.archfirst.bfoms.domain.exchange.ExchangeMessageProcessor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * JsonExchangeMessageProcessor
 *
 * @author Naresh Bhatia
 */
public class JsonExchangeMessageProcessor implements ExchangeMessageProcessor {
    private static final Logger logger =
        LoggerFactory.getLogger(JsonExchangeMessageProcessor.class);

    @Inject private BrokerageAccountService brokerageAccountService;

    @Override
    public void processMessage(String messageText) {
    }
}