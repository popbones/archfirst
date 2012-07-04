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
define(['bullsfirst/domain/UserContext',
        'bullsfirst/views/AccountFilterView'
        ],
        function(UserContext, AccountFilterView) {

    return Backbone.View.extend({

        el: '#ordfltForm',

        events: {
            'click #orders_update': 'updateOrders'
        },

        initialize: function(options) {
            new AccountFilterView({
                el: '#ordflt_accountId',
                collection: UserContext.getBrokerageAccounts()
            });
            $('#ordflt_fromDate').datepicker();
            $('#ordflt_toDate').datepicker();
        },

        updateOrders: function() {
            var formObject = this.$el.toObject();
            console.log(formObject);
        }
    });
});