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
package org.archfirst.jaxrsoms;

import java.util.HashMap;
import java.util.Map;

/**
 * OrderRepository
 *
 * @author Naresh Bhatia
 */
public class OrderRepository {
    
    private static int nextId = 1;
    private static Map<Integer, Order> orders = new HashMap<Integer, Order>();
    
    public static void persist(Order order) {
        order.id = nextId++;
        orders.put(order.id, order);
    }
    
    public static Order find(int id) {
        return orders.get(id);
    }
}