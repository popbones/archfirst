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
import java.util.concurrent.CountDownLatch;

import javax.jms.Connection;
import javax.jms.JMSException;

import org.archfirst.jmsbase.Constants;
import org.archfirst.jmsbase.JmsBaseClient;
import org.archfirst.jmsbase.MaxCounter;
import org.archfirst.jmsbase.StackTraceUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * ConcurrentConsumer
 *
 * @author Naresh Bhatia
 */
public class ConcurrentConsumer extends JmsBaseClient {
    private static final Logger logger =
        LoggerFactory.getLogger(ConcurrentConsumer.class);

    private Connection sharedConnection;
    private MaxCounter messageCounter;

    public static void main(String[] args) throws Exception {
        if (args.length < 2) {
            logger.error("Please specify jndi-properties-file and app-properties-file");
            System.exit(-1);
        }
        
        Properties jndiProperties = new Properties();
        jndiProperties.load(new FileInputStream(args[0]));
        
        Properties appProperties = new Properties();
        appProperties.load(new FileInputStream(args[1]));

        new ConcurrentConsumer(jndiProperties, appProperties).run();
    }
    
    public ConcurrentConsumer(Properties jndiProperties, Properties appProperties) {
        super(jndiProperties, appProperties);
    }

    public void run() {
        try {
            lookupConnectionFactoryAndDestination();
            createSharedConnection();
            int numMessages = createMessageCounter();
            long millis = receiveMessages();
            logger.info("{} messages/second", (numMessages * 1000)/millis);
        }
        catch (Exception e) {
            logger.error("ConcurrentConsumer halted: {}",
                    StackTraceUtil.getStackTrace(e));
        }
        finally {
            if (sharedConnection != null)
                try {sharedConnection.close();} catch (Exception e) {}
        }
    }
    
    private void createSharedConnection() throws JMSException {
        boolean connectionPerThread = Boolean.parseBoolean(
                appProperties.getProperty(
                        Constants.PROP_CONSUMER_CONNECTION_PER_THREAD,
                        Constants.PROP_CONSUMER_CONNECTION_PER_THREAD_DEFAULT));
        if (!connectionPerThread) {
            logger.info("Creating shared connection...");
            sharedConnection = connectionFactory.createConnection();
            sharedConnection.start();
        }
    }
    
    private int createMessageCounter() {
        int numMessages = Integer.parseInt(appProperties.getProperty(
                Constants.PROP_NUM_MESSAGES,
                Constants.PROP_NUM_MESSAGES_DEFAULT));
        logger.info("Receiving {} messages...", numMessages);
        messageCounter = new MaxCounter(numMessages);
        return numMessages;
    }
    
    private long receiveMessages() throws Exception {
        int numThreads = Integer.parseInt(appProperties.getProperty(
                Constants.PROP_CONSUMER_NUM_THREADS,
                Constants.PROP_CONSUMER_NUM_THREADS_DEFAULT));
        final CountDownLatch startGate = new CountDownLatch(1);
        final CountDownLatch endGate = new CountDownLatch(1);
        
        logger.info("Creating {} threads...", numThreads);
        for (int i=0; i<numThreads; i++) {
            Thread t = new Thread() {
                public void run() {
                    try {
                        ConsumerAgent agent = new ConsumerAgent(
                                appProperties, messageCounter, connectionFactory,
                                destination, sharedConnection);
                        agent.init();
                        startGate.await();
                        agent.run();
                    }
                    catch (InterruptedException ignored) {
                    }
                    catch (JMSException je) {
                        logger.error("{} halted: {}",
                                getName(), StackTraceUtil.getStackTrace(je));
                    }
                    finally {
                        endGate.countDown();
                    }
                }
            };
            t.start();
        }

        long start = System.nanoTime();
        startGate.countDown();
        endGate.await();
        return (System.nanoTime() - start)/1000000;
    }
}