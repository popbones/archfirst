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

import java.util.Properties;

import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.MessageConsumer;
import javax.jms.Session;
import javax.jms.TextMessage;

import org.archfirst.jmsbase.Constants;
import org.archfirst.jmsbase.MaxCounter;
import org.archfirst.jmsbase.StackTraceUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * ConsumerAgent
 *
 * @author Naresh Bhatia
 */
public class ConsumerAgent implements Runnable {
    private static final Logger logger =
        LoggerFactory.getLogger(ConsumerAgent.class);
    
    // Shared objects
    private Properties appProperties;
    private MaxCounter messageCounter;
    private ConnectionFactory connectionFactory;
    private Destination destination;
    private Connection sharedConnection;  // possibly null
    
    // Thread-owned objects
    private Connection privateConnection; // possibly null
    private Session session;
    private MessageConsumer consumer;
    
    public String threadName;
    
    public ConsumerAgent(
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
    
            consumer = session.createConsumer(destination);
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
        int numMessages = Integer.parseInt(appProperties.getProperty(
                Constants.PROP_NUM_MESSAGES, Constants.PROP_NUM_MESSAGES_DEFAULT));
        boolean printMessages = Boolean.parseBoolean(appProperties.getProperty(
                Constants.PROP_CONSUMER_PRINT_MESSAGES,
                Constants.PROP_CONSUMER_PRINT_MESSAGES_DEFAULT));
        
        try {
            while (true) {
                TextMessage message = (TextMessage)consumer.receive();
                int messageNumber = messageCounter.increment();
                // Message can be null if another thread is making application exit
                if ((message != null) && printMessages) {
                    String prefix = threadName + ": " + "message " + messageNumber;
                    logger.info("{} - {}", prefix, message.getText());
                }
                if (messageNumber == numMessages)
                    break;
            }
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

    private Connection getConnection() {
        return (sharedConnection != null) ? sharedConnection : privateConnection;
    }
}