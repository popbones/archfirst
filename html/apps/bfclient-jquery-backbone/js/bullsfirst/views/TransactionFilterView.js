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
 * bullsfirst/views/TransactionFilterView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/UserContext',
        'bullsfirst/framework/MessageBus',
        'bullsfirst/views/AccountFilterView'
        ],
        function(UserContext, MessageBus, AccountFilterView) {

    return Backbone.View.extend({

        el: '#txnfltForm',

        events: {
            'click #txn_update': 'updateTransactions',
            'click #txnflt_reset': 'resetFilter'
        },

        initialize: function(options) {
            // Create account filter view within the transaction filter
            new AccountFilterView({
                el: '#txnflt_accountId',
                collection: UserContext.getBrokerageAccounts()
            });

            // Create date pickers
            $('#txnflt_fromDate').datepicker();
            $('#txnflt_toDate').datepicker();

            this.resetFilter();
        },

        updateTransactions: function() {
            // Process filter criteria to server format
            var filterCriteria = this.$el.toObject();
            if (filterCriteria.fromDate) {
                filterCriteria.fromDate = moment($('#txnflt_fromDate').datepicker('getDate')).format('YYYY-MM-DD');
            }
            if (filterCriteria.toDate) {
                filterCriteria.toDate = moment($('#txnflt_toDate').datepicker('getDate')).format('YYYY-MM-DD');
            }

            // Send OrderFilterChanged message with filter criteria
            MessageBus.trigger('TransactionFilterChanged', filterCriteria);
        },

        resetFilter: function() {
           this.$el.find('#txnflt_accountId').val('');
           this.$el.find('#txnflt_fromDate').datepicker('setDate', new Date());
           this.$el.find('#txnflt_toDate').datepicker('setDate', new Date());
        }
    });
});