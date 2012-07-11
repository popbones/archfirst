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
 * bullsfirst/views/TradeTabView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/UserContext',
        'bullsfirst/framework/ErrorUtil',
        'bullsfirst/services/OrderEstimateService',
        'bullsfirst/views/AccountSelectorView'
        ],
        function(UserContext, ErrorUtil, OrderEstimateService, AccountSelectorView) {

    return Backbone.View.extend({

        el: '#trade_tab',

        events: {
            'submit #tradeForm': 'validateForm',
            'keypress #trade_tab': 'checkEnterKey',
            'change #tradeForm_orderType': 'orderTypeChanged'
        },

        initialize: function(options) {
            new AccountSelectorView({
                el: '#tradeForm_account_selector',
                collection: UserContext.getBrokerageAccounts()
            });

            $('#tradeForm').validationEngine();
        },

        checkEnterKey: function(event) {
           if (event.keyCode == $.ui.keyCode.ENTER) {
               this.validateForm();
               return false;
           }
        },

        validateForm: function() {
            if ($('#tradeForm').validationEngine('validate')) {

                var orderRequest = $('#tradeForm').toObject();

                // For Market orders, make sure there is no limit price
                if (orderRequest.orderParams.type === 'Market') {
                    delete orderRequest.orderParams.limitPrice;
                }

                // Make sure allOrNone is defined
                if (typeof orderRequest.orderParams.allOrNone === 'undefined') {
                    orderRequest.orderParams.allOrNone = 'false';
                }

                OrderEstimateService.createOrderEstimate(
                    orderRequest, _.bind(this.createOrderEstimateDone, this), ErrorUtil.showError);
            }
            return false;
        },

        createOrderEstimateDone: function(data, textStatus, jqXHR) {
            console.log(data);
        },

        orderTypeChanged: function(event) {
            if (event.target.value === 'Market') {
                $('#tradeForm_limitPriceItem').hide('fast');
            }
            else {
                $('#tradeForm_limitPriceItem').show('fast');
            }
        }
    });
});