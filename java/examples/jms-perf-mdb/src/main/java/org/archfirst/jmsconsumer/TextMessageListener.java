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
package org.archfirst.jmsconsumer;

import javax.ejb.MessageDriven;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * TextMessageListener
 *
 * @author Naresh Bhatia
 */
@MessageDriven(mappedName="jms/PerfQueue")
//Annotation needed for JBoss AS 7
//@MessageDriven(activationConfig={
//        @ActivationConfigProperty(propertyName="destinationType", propertyValue="javax.jms.Queue"),
//        @ActivationConfigProperty(propertyName="destination", propertyValue="jms/PerfQueue")
//     })
public class TextMessageListener implements MessageListener {
    private static final Logger logger =
        LoggerFactory.getLogger(TextMessageListener.class);
    
    private static int count = 0;
    private static final int maxCount = 1000;
    private static long start;

    public TextMessageListener() {
        logger.debug("{}: TextMessageListener created",
                Thread.currentThread().getName());
    }

    @Override
    public void onMessage(Message message) {
        try {
            ((TextMessage)message).getText();
            incrementCount();
        }
        catch (JMSException e) {
            throw new RuntimeException(e);
        }
    }
    
    private synchronized void incrementCount() {
        count++;
        if (count == 1) {
            start = System.nanoTime();
        }
        if (count == maxCount) {
            long millis = (System.nanoTime() - start)/1000000;
            logger.info("{} messages received in {} milliseconds", maxCount, millis);
            logger.info("{} messages/second", (maxCount * 1000)/millis);
            count = 0;
        }
    }
}