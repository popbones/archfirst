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
 * bullsfirst/views/OrderTableView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/Orders',
        'bullsfirst/framework/MessageBus',
        'bullsfirst/views/ExecutionView',
        'bullsfirst/views/OrderView'
        ],
        function(Orders, MessageBus, ExecutionView, OrderView) {

    return Backbone.View.extend({

        el: '#orders_table tbody',

        collection: new Orders(),

        initialize: function() {
            this.collection.bind('reset', this.render, this);

            // Subscribe to events
            MessageBus.on('OrderFilterChanged', function(filterCriteria) {
                this.collection.fetch({data: filterCriteria});
            }, this);
        },

        render: function() {
            // Take out rows that might be sitting in the table
            this.$el.empty();

            // Add new rows from orders collection. Pass this object as context
            this.collection.each(function(order, i) {
                var orderId = 'order-' + order.get('id');
                var view = new OrderView({
                    model: order,
                    id: orderId,
                    className: (i % 2) ? "" : "alt"
                });
                this.$el.append(view.render().el);

                // Add rows for executions
                var executions = order.get('executions');
                if (executions && executions.length > 0) {
                    this._renderExecutions(executions, orderId);
                }
            }, this);

            // Display as TreeTable
            $("#orders_table").treeTable();

            return this;
        },

        _renderExecutions: function(executions, orderId) {
            executions.forEach(function(execution) {
                var view = new ExecutionView({
                    model: execution,
                    id: 'execution-' + execution.id,
                    className: 'child-of-' + orderId
                });
                this.$el.append(view.render().el);
            }, this);
        }
    });
});