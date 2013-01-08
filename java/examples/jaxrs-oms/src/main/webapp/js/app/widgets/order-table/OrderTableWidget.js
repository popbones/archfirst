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
 * app/widgets/order-table/OrderTableWidget
 *
 * @author Naresh Bhatia
 */
define(
    [
        'app/widgets/order-table/OrderView',
        'backbone',
        'framework/BaseView',
        'text!app/widgets/order-table/OrderTableTemplate.html'
    ],
    function(OrderView, Backbone, BaseView, OrderTableTemplate) {
        'use strict';

        return BaseView.extend({
            // Make this view a <section> in the DOM
            tagName: 'table',

            // Give it a class of 'page'
            className: 'order-table',

            template: {
                name: 'OrderTableTemplate',
                source: OrderTableTemplate
            },

            initialize: function(/* options */) {
                this.listenTo(this.collection, 'add', this.handleAdd);
                this.listenTo(this.collection, 'destroy', this.handleDestroy);
                this.listenTo(this.collection, 'reset', this.handleReset);
            },

            handleAdd: function(order) {
                this.renderOrder(order);
            },

            handleDestroy: function(order) {
                this.removeChild(order.id);
            },

            handleReset: function() {
                this.render();
            },

            postRender: function() {
                this.collection.each(function(order) {
                    this.renderOrder(order);
                }, this);
            },

            renderOrder: function(order) {
                var view = new OrderView({model: order});
                view.render().place(this.$el.find('tbody'));
                this.addChild(order.id, view);
            }
        });
    }
);