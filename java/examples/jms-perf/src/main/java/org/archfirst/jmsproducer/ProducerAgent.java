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
package org.archfirst.jmsproducer;

import java.util.Properties;

import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.DeliveryMode;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.MessageProducer;
import javax.jms.Session;
import javax.jms.TextMessage;

import org.archfirst.jmsbase.Constants;
import org.archfirst.jmsbase.MaxCounter;
import org.archfirst.jmsbase.StackTraceUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * ProducerAgent
 *
 * @author Naresh Bhatia
 */
public class ProducerAgent implements Runnable {
    private static final Logger logger =
        LoggerFactory.getLogger(ProducerAgent.class);
    
    // Shared objects
    private Properties appProperties;
    private MaxCounter messageCounter;
    private ConnectionFactory connectionFactory;
    private Destination destination;
    private Connection sharedConnection;  // possibly null
    
    // Thread-owned objects
    private Connection privateConnection; // possibly null
    private Session session;
    private MessageProducer producer;
    
    public String threadName;
    
    public ProducerAgent(
            Properties appProperties,
            MaxCounter messageCounter,
            ConnectionFactory connectionFactory,
            Destination destination,
            Connection sharedConnection) {
        this.appProperties = appProperties;
        this.messageCounter = messageCounter;
        this.connectionFactory = connectionFactory;
        this.destination = destination;
        this.sharedConnection = sharedConnection;
    }

    public void init() throws JMSException {
        try {
            if (sharedConnection == null) {
                logger.debug("Creating private connection...");
                privateConnection = connectionFactory.createConnection();
                privateConnection.start();
            }
    
            session = getConnection().createSession(
                    false, Session.AUTO_ACKNOWLEDGE);
    
            producer = session.createProducer(destination);
            
            // Performance tuning - deliveryModeNonPersistent
            boolean deliveryModeNonPersistent = Boolean.parseBoolean(
                    appProperties.getProperty(
                            Constants.PROP_PRODUCER_DELIVERY_MODE_NON_PERSISTENT,
                            Constants.PROP_PRODUCER_DELIVERY_MODE_NON_PERSISTENT_DEFAULT));
            if (deliveryModeNonPersistent)
                producer.setDeliveryMode(DeliveryMode.NON_PERSISTENT);

            // Performance tuning - disableMessageId
            boolean disableMessageId = Boolean.parseBoolean(
                    appProperties.getProperty(
                            Constants.PROP_PRODUCER_DISABLE_MESSAGE_ID,
                            Constants.PROP_PRODUCER_DISABLE_MESSAGE_ID_DEFAULT));
            if (disableMessageId)
                producer.setDisableMessageID(true);

            // Performance tuning - disableTimestamp
            boolean disableTimestamp = Boolean.parseBoolean(
                    appProperties.getProperty(
                            Constants.PROP_PRODUCER_DISABLE_TIME_STAMP,
                            Constants.PROP_PRODUCER_DISABLE_TIME_STAMP_DEFAULT));
            if (disableTimestamp)
                producer.setDisableMessageTimestamp(true);
        }
        catch (JMSException je) {
            if (privateConnection != null)
                try {privateConnection.close();} catch (Exception e) {}
            privateConnection = null;
            throw je;
        }
    }
    
    @Override
    public void run() {
        
        this.threadName = Thread.currentThread().getName();
        
        try {
            int messageSize = Integer.parseInt(appProperties.getProperty(
                    Constants.PROP_MESSAGE_SIZE, Constants.PROP_MESSAGE_SIZE_DEFAULT));
            String messageText = createMessageText(messageSize);

            int numMessages = 0;
            while (messageCounter.increment() > 0) {
                TextMessage message = session.createTextMessage(messageText);
                producer.send(message);
                numMessages++;
            }
            logger.debug("{}: sent {} messages", threadName, numMessages);
        }
        catch (JMSException e) {
            logger.error("{} halted: {}",
                    threadName, StackTraceUtil.getStackTrace(e));
        }
        finally {
            if (privateConnection != null)
                try {privateConnection.close();} catch (Exception e) {}
        }
    }

    private String createMessageText(int size) {
        StringBuffer buffer = new StringBuffer(size);
        for (int i=0; i<size; i++) {
            buffer.append('.');
        }
        return buffer.toString();
    }

    private Connection getConnection() {
        return (sharedConnection != null) ? sharedConnection : privateConnection;
    }
}