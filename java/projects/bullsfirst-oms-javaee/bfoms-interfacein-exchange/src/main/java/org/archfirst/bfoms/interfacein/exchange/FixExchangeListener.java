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

import javax.ejb.MessageDriven;
import javax.inject.Inject;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;

import org.archfirst.bfoms.infra.fix.FixFormatter;
import org.archfirst.bfoms.infra.fix.FixUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import quickfix.FieldNotFound;
import quickfix.IncorrectDataFormat;
import quickfix.IncorrectTagValue;
import quickfix.InvalidMessage;
import quickfix.MessageUtils;
import quickfix.UnsupportedMessageType;

/**
 * FixExchangeListener
 *
 * @author Naresh Bhatia
 */
@MessageDriven(mappedName="jms/ExchangeToOmsJavaeeFixQueue")
public class FixExchangeListener implements MessageListener {
    private static final Logger logger =
        LoggerFactory.getLogger(FixExchangeListener.class);

    @Inject private FixMessageProcessor fixMessageProcessor;

    public FixExchangeListener() {
        logger.debug("FixExchangeListener created");
    }

    @Override
    public void onMessage(Message message) {
        if (message instanceof TextMessage) {
            String messageText = null;
            try {
                messageText = ((TextMessage)message).getText();
                quickfix.Message fixMessage =
                    MessageUtils.parse(
                            FixUtil.getDefaultMessageFactory(),
                            FixUtil.getDefaultDataDictionary(),
                            messageText);
                logger.debug("Received message:\n{}", FixFormatter.format(fixMessage));
                fixMessageProcessor.fromApp(fixMessage, null);
            }
            catch (InvalidMessage e) {
                logger.error("Invalid FIX message received: " + messageText, e);
            }
            catch (FieldNotFound e) {
                logger.error("Invalid FIX message received: " + messageText, e);
            }
            catch (IncorrectDataFormat e) {
                logger.error("Invalid FIX message received: " + messageText, e);
            }
            catch (IncorrectTagValue e) {
                logger.error("Invalid FIX message received: " + messageText, e);
            }
            catch (UnsupportedMessageType e) {
                logger.error("Invalid FIX message received: " + messageText, e);
            }
            catch (JMSException e) {
                throw new RuntimeException(e);
            }
        }
    }
}