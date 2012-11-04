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
 * oms/views/ToolbarView
 *
 * @author Naresh Bhatia
 */
define(['oms/domain/Order'],
       function(Order) {

    var _side = ['Buy', 'Sell'];
    var _securities = ['AAPL', 'ADBE', 'AMZN', 'CCE', 'CSCO', 'DELL', 'EBAY', 'GE', 'GOOG', 'MSFT'];

    return Backbone.View.extend({

        events: {
            'click #create-orders-button': 'handleCreateOrders',
            'click #update-button': 'handleUpdate'
        },

        handleCreateOrders: function() {
            var order;
            var numOrders = $('#num-trades').val();
            if (numOrders <= 0) numOrders = 1;
            for (i=0; i<numOrders; i++) {
                order = this.collection.create({
                    side: _side[Math.round(Math.random() * 2) % 2],
                    symbol: _securities[Math.round(Math.random() * 10) % 10],
                    quantity: (Math.round(Math.random() * 10) + 1) * 100
                }, {wait: true});
            }
            return false;
        },

        handleUpdate: function() {
            var symbol = $('#symbol-filter').val();
            if (symbol.length == 0) {
                this.collection.fetch();
            }
            else {
                this.collection.fetch({data: {symbol: symbol}});
            }
            return false;
        }
    });
});