﻿/**
 * Copyright 2012 Archfirst
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

/**
 * oms/domain/Repository
 *
 * This is a singleton object which stores all models used by the application.
 *
 * @author Naresh Bhatia
 */
define(['oms/domain/Orders'],
       function(Orders) {

    // Module level variables act as singletons
    var _orders = new Orders();

    return {
        getOrders: function() { return _orders; },

        fetchOrders: function() {
        	_orders.fetch();
        }
    };
});