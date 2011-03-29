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

import java.io.FileInputStream;
import java.util.Properties;

import javax.jms.Connection;
import javax.jms.DeliveryMode;
import javax.jms.JMSException;
import javax.jms.MessageProducer;
import javax.jms.Session;
import javax.jms.TextMessage;

import org.archfirst.jmsbase.JmsBaseClient;
import org.archfirst.jmsbase.StackTraceUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * SimpleProducer
 *
 * @author Naresh Bhatia
 */
public class SimpleProducer extends JmsBaseClient {
    private static final Logger logger =
        LoggerFactory.getLogger(SimpleProducer.class);

    private Connection connection = null;
    private Session session = null;
    private MessageProducer producer = null;
    
    public static void main(String[] args) throws Exception {
        if (args.length < 2) {
            logger.error("Please specify jndi-properties-file and app-properties-file");
            System.exit(-1);
        }
        
        Properties jndiProperties = new Properties();
        jndiProperties.load(new FileInputStream(args[0]));
        
        Properties appProperties = new Properties();
        appProperties.load(new FileInputStream(args[1]));

        new SimpleProducer(jndiProperties, appProperties).run();
    }
    
    public SimpleProducer(Properties jndiProperties, Properties appProperties) {
        super(jndiProperties, appProperties);
    }
    
    public void run() {
        try {
            lookupConnectionFactoryAndDestination();
            createConnection();
            connection.start();
            sendMessages();
        }
        catch (Exception e) {
            logger.error("SimpleProducer halted: {}",
                    StackTraceUtil.getStackTrace(e));
        }
        finally {
            if (connection != null)
                try {connection.close();} catch (Exception e) {}
        }
    }
    
    private void createConnection() throws JMSException {
        try {
            logger.info("Creating Connection...");
            connection = connectionFactory.createConnection();
    
            logger.info("Creating Session...");
            session = connection.createSession(
                    false, Session.AUTO_ACKNOWLEDGE);
    
            logger.info("Creating MessageProducer...");
            producer = session.createProducer(destination);
            
            // Performance tuning - deliveryModeNonPersistent
            boolean deliveryModeNonPersistent = Boolean.parseBoolean(
                    appProperties.getProperty(
                            PROP_PRODUCER_DELIVERY_MODE_NON_PERSISTENT,
                            PROP_PRODUCER_DELIVERY_MODE_NON_PERSISTENT_DEFAULT));
            if (deliveryModeNonPersistent)
                producer.setDeliveryMode(DeliveryMode.NON_PERSISTENT);

            // Performance tuning - disableMessageId
            boolean disableMessageId = Boolean.parseBoolean(
                    appProperties.getProperty(
                            PROP_PRODUCER_DISABLE_MESSAGE_ID,
                            PROP_PRODUCER_DISABLE_MESSAGE_ID_DEFAULT));
            if (disableMessageId)
                producer.setDisableMessageID(true);

            // Performance tuning - disableTimestamp
            boolean disableTimestamp = Boolean.parseBoolean(
                    appProperties.getProperty(
                            PROP_PRODUCER_DISABLE_TIME_STAMP,
                            PROP_PRODUCER_DISABLE_TIME_STAMP_DEFAULT));
            if (disableTimestamp)
                producer.setDisableMessageTimestamp(true);
        }
        catch (JMSException je) {
            if (connection != null)
                try {connection.close();} catch (Exception e) {}
            connection = null;
            throw je;
        }
    }
    
    private void sendMessages() throws JMSException {
        int numMessages = Integer.parseInt(appProperties.getProperty(
                PROP_NUM_MESSAGES, PROP_NUM_MESSAGES_DEFAULT));
        int messageSize = Integer.parseInt(appProperties.getProperty(
                PROP_MESSAGE_SIZE, PROP_MESSAGE_SIZE_DEFAULT));
        String messageText = createMessageText(messageSize);
        logger.info("Sending {} messages of size {}...", numMessages, messageSize);

        long start = System.nanoTime();
        for (int i=1; i <= numMessages; i++) {
            TextMessage message = session.createTextMessage(messageText);
            producer.send(message);
        }
        long end = System.nanoTime();
        long millis = (end - start)/1000000;

        logger.info("{} messages sent in {} milliseconds", numMessages, millis);
        logger.info("{} messages/second", (numMessages * 1000)/millis);
    }
    
    private String createMessageText(int size) {
        StringBuffer buffer = new StringBuffer(size);
        for (int i=0; i<size; i++) {
            buffer.append('.');
        }
        return buffer.toString();
    }
}