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

/**
 * Constants
 *
 * @author Naresh Bhatia
 */
public final class Constants {

    // JMS Constants
    public static final String PROP_CONNECTION_FACTORY = "connectionFactory";
    public static final String PROP_DESTINATION = "destination";

    // Common Application Constants
    public static final String PROP_NUM_MESSAGES = "numMessages";
    public static final String PROP_NUM_MESSAGES_DEFAULT = "1000";
    public static final String PROP_MESSAGE_SIZE = "messageSize";
    public static final String PROP_MESSAGE_SIZE_DEFAULT = "100";

    // Producer Constants
    public static final String PROP_PRODUCER_DELIVERY_MODE_NON_PERSISTENT = "producer.deliveryModeNonPersistent";
    public static final String PROP_PRODUCER_DELIVERY_MODE_NON_PERSISTENT_DEFAULT = "false";
    public static final String PROP_PRODUCER_DISABLE_MESSAGE_ID = "producer.disableMessageId";
    public static final String PROP_PRODUCER_DISABLE_MESSAGE_ID_DEFAULT = "false";
    public static final String PROP_PRODUCER_DISABLE_TIME_STAMP = "producer.disableTimestamp";
    public static final String PROP_PRODUCER_DISABLE_TIME_STAMP_DEFAULT = "false";
    public static final String PROP_PRODUCER_NUM_THREADS = "producer.numThreads";
    public static final String PROP_PRODUCER_NUM_THREADS_DEFAULT = "50";
    public static final String PROP_PRODUCER_CONNECTION_PER_THREAD = "producer.connectionPerThread";
    public static final String PROP_PRODUCER_CONNECTION_PER_THREAD_DEFAULT = "false";

    // Consumer Constants
    public static final String PROP_CONSUMER_PRINT_MESSAGES = "consumer.printMessages";
    public static final String PROP_CONSUMER_PRINT_MESSAGES_DEFAULT = "false";
    public static final String PROP_CONSUMER_NUM_THREADS = "consumer.numThreads";
    public static final String PROP_CONSUMER_NUM_THREADS_DEFAULT = "10";
    public static final String PROP_CONSUMER_CONNECTION_PER_THREAD = "consumer.connectionPerThread";
    public static final String PROP_CONSUMER_CONNECTION_PER_THREAD_DEFAULT = "false";
}