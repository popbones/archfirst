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
 * bullsfirst/views/OrderView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/Order',
        'bullsfirst/services/OrderService',
        'bullsfirst/framework/ErrorUtil',
        'bullsfirst/framework/Formatter',
        'bullsfirst/framework/MessageBus'
        ],
        function(Order, OrderService, ErrorUtil, Formatter, MessageBus) {

    return Backbone.View.extend({

        tagName: 'tr',

        events: {
            'click .orders_table_cancel': 'cancelOrder'
        },

        cancelOrder: function() {
            OrderService.cancelOrder(
                this.model.id, this.cancelOrderDone, ErrorUtil.showError);
        },

        cancelOrderDone: function(data, textStatus, jqXHR) {
            // TODO: Ideally this should simply require updating the current order,
            // but the server does not support fetching a single order.
            MessageBus.trigger('UpdateOrders');
        },

        render: function() {
            // Format order values for display 
            var order = this.model.toJSON();  // returns a copy of the model's attributes
            order.creationTimeFormatted = Formatter.formatMoment2DateTime(moment(order.creationTime));
            order.limitPriceFormatted = Formatter.formatMoney(order.limitPrice);
            order.executionPriceFormatted = Formatter.formatMoney(order.executionPrice);

            // Render using template
            var hash = {
                order: order
            }
            $(this.el).html(Mustache.to_html($('#orderTemplate').html(), hash));
            return this;
        }
    });
});