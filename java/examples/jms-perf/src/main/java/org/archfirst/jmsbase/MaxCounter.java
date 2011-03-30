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
 * Counts up from 1 to maxValue. After that happens the increment() method
 * returns a 0 to indicate that max value has been reached.
 * 
 * <code>
 * MaxCounter counter = new MaxCounter(3);
 * while ((value = counter.increment()) > 0) {
 *     System.out.println(value);
 * }
 * </code>
 * 
 * When this code is run three values will be printed: 1, 2 and 3
 *
 * @author Naresh Bhatia
 */
public final class MaxCounter {

    private final int maxValue;
    private int value;
    
    public MaxCounter(int maxValue) {
        this.maxValue = maxValue;
        this.value = 0;
    }

    public synchronized int getValue() {
        return value;
    }

    public synchronized int increment() {
        return (value < maxValue) ? ++value : 0;
    }
}