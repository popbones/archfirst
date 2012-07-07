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
 * bullsfirst/views/OrderFilterView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/Orders',
        'bullsfirst/domain/UserContext',
        'bullsfirst/framework/MessageBus',
        'bullsfirst/views/AccountFilterView'
        ],
        function(Orders, UserContext, MessageBus, AccountFilterView) {

    return Backbone.View.extend({

        el: '#ordfltForm',

        events: {
            'click #orders_update': 'updateOrders',
            'click #ordflt_reset': 'resetFilter'
        },

        initialize: function(options) {
            // Create account filter view within the order filter
            new AccountFilterView({
                el: '#ordflt_accountId',
                collection: UserContext.getBrokerageAccounts()
            });

            // Create date pickers
            $('#ordflt_fromDate').datepicker();
            $('#ordflt_toDate').datepicker();

            this.resetFilter();
        },

        updateOrders: function() {
            // Process filter criteria to server format
            var filterCriteria = this.$el.toObject();
            if (filterCriteria.fromDate) {
                filterCriteria.fromDate = moment($('#ordflt_fromDate').datepicker('getDate')).format('YYYY-MM-DD');
            }
            if (filterCriteria.toDate) {
                filterCriteria.toDate = moment($('#ordflt_toDate').datepicker('getDate')).format('YYYY-MM-DD');
            }

            // Send OrderFilterChanged message with filter criteria
            MessageBus.trigger('OrderFilterChanged', filterCriteria);
        },

        resetFilter: function() {
           this.$el.find('#ordflt_accountId').val('');
           this.$el.find('input').val('');
           this.$el.find('input:checkbox').prop('checked', false);
           $('#ordflt_fromDate').datepicker('setDate', new Date());
           $('#ordflt_toDate').datepicker('setDate', new Date());
        }
    });
});