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
 * bullsfirst/views/PositionTableView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/framework/MessageBus',
        'bullsfirst/views/PositionView'
        ],
        function(MessageBus, PositionView) {

    return Backbone.View.extend({

        el: '#positions_table tbody',

        initialize: function(options) {
            // Subscribe to events
            MessageBus.on('SelectedAccountChanged', function(selectedAccount) {
                this.collection = selectedAccount.get('positions');
                this.collection.bind('reset', this.render, this);
                this.render();
            }, this);
        },

        render: function() {
            // take out rows that might be sitting in the table
            this.$el.empty();

            // Add new rows from positions collection. Pass this object as context
            this.collection.each(function(position, i) {
                var view = new PositionView({model: position});
                this.$el.append(view.render().el);
            }, this);

            // Stripe the rows
            this.$el.find('tr:odd').addClass('alt');

            return this;
        }
    });
});