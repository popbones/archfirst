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
 * app/pages/orders/OrdersPage
 *
 * @author Naresh Bhatia
 */
define(
    [
        'app/widgets/order-table/OrderTableWidget',
        'app/widgets/order-toolbar/OrderToolbarWidget',
        'backbone',
        'app/domain/Repository',
        'framework/BaseStaticView',
        'text!app/pages/orders/OrdersPageTemplate.html'
    ],
    function(OrderTableWidget, OrderToolbarWidget, Backbone, Repository, BaseStaticView, OrdersPageTemplate) {
        'use strict';

        return BaseStaticView.extend({
            // Make this view a <section> in the DOM
            tagName: 'section',

            // Give it a class of 'page'
            className: 'page',

            template: {
                name: 'OrdersPageTemplate',
                source: OrdersPageTemplate
            },

            postRender: function() {
                var orderToolbarWidget = new OrderToolbarWidget({
                    collection: Repository.getOrderCollection()
                });
                orderToolbarWidget.render().place(this.$el.find('.content'));

                var orderTableWidget = new OrderTableWidget({
                    collection: Repository.getOrderCollection()
                });
                orderTableWidget.render().place(this.$el.find('.content'));
            }
        });
    }
);