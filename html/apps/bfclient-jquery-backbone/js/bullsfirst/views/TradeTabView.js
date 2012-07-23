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
define(['bullsfirst/domain/MarketPrice',
        'bullsfirst/domain/UserContext',
        'bullsfirst/framework/AlertUtil',
        'bullsfirst/framework/ErrorUtil',
        'bullsfirst/services/OrderEstimateService',
        'bullsfirst/views/AccountSelectorView',
        'bullsfirst/views/LastTradeView',
        'bullsfirst/views/PreviewOrderDialog'],
       function(MarketPrice, UserContext, AlertUtil, ErrorUtil, OrderEstimateService, AccountSelectorView, LastTradeView, PreviewOrderDialog) {

    return Backbone.View.extend({

        el: '#trade_tab',

        events: {
            'submit #tradeForm': 'validateForm',
            'keypress #trade_tab': 'checkEnterKey',
            'change #tradeForm_orderType': 'orderTypeChanged',
            'change #tradeForm_symbol': 'symbolChanged'
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

                this.orderRequest = $('#tradeForm').toObject();

                // For Market orders, make sure there is no limit price
                if (this.orderRequest.orderParams.type === 'Market') {
                    delete this.orderRequest.orderParams.limitPrice;
                }

                // Make sure allOrNone is defined
                if (typeof this.orderRequest.orderParams.allOrNone === 'undefined') {
                    this.orderRequest.orderParams.allOrNone = 'false';
                }

                OrderEstimateService.createOrderEstimate(
                    this.orderRequest, _.bind(this.createOrderEstimateDone, this), ErrorUtil.showError);
            }
            return false;
        },

        createOrderEstimateDone: function(data, textStatus, jqXHR) {
            if (data.compliance === 'Compliant') {
                if (!this.previewOrderDialog) {
                    this.previewOrderDialog = new PreviewOrderDialog();
                }
                this.previewOrderDialog.open(this.orderRequest, data, this.marketPrice);
                return false;
            }
            else {
                AlertUtil.showError(data.compliance);
            }
        },

        orderTypeChanged: function(event) {
            if (event.target.value === 'Market') {
                $('#tradeForm_limitPriceItem').hide('fast');
            }
            else {
                $('#tradeForm_limitPriceItem').show('fast');
            }
        },

        symbolChanged: function(event) {
            var symbol = event.target.value;
            this.marketPrice = new MarketPrice({symbol: symbol});
            this.marketPrice.fetch({
                success: _.bind(this._marketPriceFetched, this),
                error: ErrorUtil.showBackboneError
            });
        },

        _marketPriceFetched: function() {
            new LastTradeView({model: this.marketPrice}).render();
        } 
    });
});