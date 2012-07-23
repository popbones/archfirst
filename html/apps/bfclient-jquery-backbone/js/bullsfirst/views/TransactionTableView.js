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
 * bullsfirst/views/TransactionTableView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/Transactions',
        'bullsfirst/framework/MessageBus',
        'bullsfirst/views/TransactionView'],
       function(Transactions, MessageBus, TransactionView) {

    return Backbone.View.extend({

        el: '#txn_table tbody',

        collection: new Transactions(),

        initialize: function() {
            this.collection.bind('reset', this.render, this);

            // Subscribe to events
            MessageBus.on('TransactionFilterChanged', function(filterCriteria) {
                this.collection.fetch({data: filterCriteria});
            }, this);
        },

        render: function() {
            // Take out rows that might be sitting in the table
            this.$el.empty();

            // Add new rows from orders collection. Pass this object as context
            this.collection.each(function(txn, i) {
                var view = new TransactionView({model: txn});
                this.$el.append(view.render().el);
            }, this);

            // Stripe the rows
            this.$el.find('tr:odd').addClass('alt');

            return this;
        }
    });
});