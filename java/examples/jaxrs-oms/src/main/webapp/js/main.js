/**
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
 * Application Entry Point
 *
 * @author Naresh Bhatia
 */
require(['oms/domain/Repository',
         'oms/views/OrderTableView',
         'oms/views/TemplateManager',
         'oms/views/ToolbarView'],
        function(Repository, OrderTableView, TemplateManager, ToolbarView) {

    $(document).ready(function() {
        // Load and compile templates
        TemplateManager.initialize();

        // Load and compile templates
        TemplateManager.initialize();

        new ToolbarView({
        	el: $("#tool-bar"),
        	collection: Repository.getOrders()
        });
        new OrderTableView({
        	el: $("#order-table tbody"),
        	collection: Repository.getOrders()
        });
        Repository.fetchOrders();
    });
});