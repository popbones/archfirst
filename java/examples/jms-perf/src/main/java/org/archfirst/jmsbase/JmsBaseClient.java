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
package org.archfirst.jmsbase;

import java.util.Properties;

import javax.jms.ConnectionFactory;
import javax.jms.Destination;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * JmsBaseClient
 *
 * @author Naresh Bhatia
 */
public class JmsBaseClient {
    private static final Logger logger =
        LoggerFactory.getLogger(JmsBaseClient.class);

    protected Properties jndiProperties;
    protected Properties appProperties;

    protected ConnectionFactory connectionFactory;
    protected Destination destination;
    
    public JmsBaseClient(Properties jndiProperties, Properties appProperties) {
        this.jndiProperties = jndiProperties;
        this.appProperties = appProperties;
    }

    protected void lookupConnectionFactoryAndDestination() throws NamingException {

        InitialContext initialContext = null;
        try {
            logger.info("Creating InitialContext...");
            initialContext = new InitialContext(jndiProperties);

            logger.info("Looking up ConnectionFactory...");
            connectionFactory = (ConnectionFactory)initialContext.lookup(
                    appProperties.getProperty(Constants.PROP_CONNECTION_FACTORY));

            logger.info("Looking up Destination...");
            destination = (Destination)initialContext.lookup(
                    appProperties.getProperty(Constants.PROP_DESTINATION));
        }
        finally {
            if (initialContext != null)
                try {initialContext.close();} catch (Exception e) {}
        }
    }
}