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

import java.io.FileInputStream;
import java.util.Properties;

import javax.jms.Connection;
import javax.jms.JMSException;
import javax.jms.MessageConsumer;
import javax.jms.Session;
import javax.jms.TextMessage;

import org.archfirst.jmsbase.JmsBaseClient;
import org.archfirst.jmsbase.StackTraceUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * SimpleConsumer
 *
 * @author Naresh Bhatia
 */
public class SimpleConsumer extends JmsBaseClient {
    private static final Logger logger =
        LoggerFactory.getLogger(SimpleConsumer.class);

    private Connection connection = null;
    private Session session = null;
    private MessageConsumer consumer = null;
    
    public static void main(String[] args) throws Exception {
        if (args.length < 2) {
            logger.error("Please specify jndi-properties-file and app-properties-file");
            System.exit(-1);
        }
        
        Properties jndiProperties = new Properties();
        jndiProperties.load(new FileInputStream(args[0]));
        
        Properties appProperties = new Properties();
        appProperties.load(new FileInputStream(args[1]));

        new SimpleConsumer(jndiProperties, appProperties).run();
    }
    
    public SimpleConsumer(Properties jndiProperties, Properties appProperties) {
        super(jndiProperties, appProperties);
    }
    
    public void run() {
        try {
            lookupConnectionFactoryAndDestination();
            createConnection();
            connection.start();
            receiveMessages();
        }
        catch (Exception e) {
            logger.error("SimpleConsumer halted: {}",
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
    
            logger.info("Creating MessageConsumer...");
            consumer = session.createConsumer(destination);
        }
        catch (JMSException je) {
            if (connection != null)
                try {connection.close();} catch (Exception e) {}
            connection = null;
            throw je;
        }
    }
    
    private void receiveMessages() throws JMSException {
        int numMessages = Integer.parseInt(
                appProperties.getProperty(PROP_NUM_MESSAGES));
        boolean printMessages = Boolean.parseBoolean(
                appProperties.getProperty(PROP_CONSUMER_PRINT_MESSAGES));
        logger.info("Receiving {} messages...", numMessages);

        long start = System.nanoTime();
        for (int i=1; i <= numMessages; i++) {
            TextMessage message = (TextMessage)consumer.receive();
            if (printMessages) {
                logger.info(message.getText());
            }
        }
        long end = System.nanoTime();
        long millis = (end - start)/1000000;

        logger.info("{} messages received in {} milliseconds", numMessages, millis);
        logger.info("{} messages/second", (numMessages * 1000)/millis);
    }
}