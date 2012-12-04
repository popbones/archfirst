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
 * oms/views/OrderTableView
 *
 * @author Naresh Bhatia
 */
define(['oms/views/OrderView'],
       function(OrderView) {

    return Backbone.View.extend({

        // map of orderId to OrderView
        orderViews: {},

        initialize: function(options) {
            this.collection.on('add', this.handleAdd, this);
            this.collection.on('destroy', this.handleDestroy, this);
            this.collection.on('reset', this.handleReset, this);
        },

        handleAdd: function(order) {
            this.renderOrder(order);
        },

        handleDestroy: function(order) {
            this.orderViews[order.id].close();
            delete this.orderViews[order.id];

        },

        handleReset: function() {
            this.renderAll();
        },

        renderAll: function() {
            // Close existing child views
            for (var orderId in this.orderViews) {
                this.orderViews[orderId].close();
            }
            this.orderViews = {};

            // Create new views for each account
            this.collection.each(function(order, i) {
                this.renderOrder(order);
            }, this);

            return this;
        },

        renderOrder: function(order) {
            var view = new OrderView({model: order});
            this.$el.append(view.render().el);
            this.orderViews[order.id] = view;
        }
    });
});