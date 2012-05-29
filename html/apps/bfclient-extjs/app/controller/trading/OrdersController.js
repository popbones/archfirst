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
* app/controller/trading/OrdersController
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.controller.trading.OrdersController', {
    extend: 'Ext.app.Controller',

    views: [
		'trading.OrdersView',
		'trading.TradingTabPanel'
    ],

    models: [
        'TradeOrderSummary'
    ],

    stores: [
        'TradeOrderSummaries',
        'TradeOrderSummariesTree'
    ],

    refs: [
        {
            ref: 'OrderViewCombo',
            selector: 'ordersview combo'
        },
        {
            ref: 'OrderViewSymbolFilter',
            selector: 'ordersview textfield[fieldLabel=Symbol]'
        },
        {
            ref: 'OrderViewOrderIdFilter',
            selector: 'ordersview textfield[fieldLabel=Order #]'
        },
        {
            ref: 'OrderViewFromDateFilter',
            selector: 'ordersview datefield[fieldLabel=From]'
        },
        {
            ref: 'OrderViewToDateFilter',
            selector: 'ordersview datefield[fieldLabel=To]'
        },
        {
            ref: 'OrderViewSidesFilter',
            selector: 'ordersview checkboxgroup[fieldLabel=Order Action]'
        },
        {
            ref: 'OrderViewStatusesFilter',
            selector: 'ordersview checkboxgroup[fieldLabel=Order Status]'
        }
    ],

    init: function () {
        this.control({
            'ordersview combo': {
                'change': this.onOrdersViewComboChange
            },
            'ordersview': {
                'afterrender': this.onOrdersViewAfterRender
            },
            'ordersview templatecolumn[text=Actions]': {
                'click': this.onCancelOrderLinkClick
            },
            'ordersview button[text=Update]': {
                'click': this.onUpdateBtnClick
            },
            'ordersview button[text=Reset Filter]': {
                'click': this.onResetFilterBtnClick
            }
        });
        this.callParent();
    },
    onOrdersViewComboChange: function onOrdersViewBeforeRender(ordersViewCombo, newValue, oldValue) {
        //load orders store when combo value is changed
        if (newValue !== oldValue && oldValue !== null && oldValue !== undefined) {
            this.processFilters();
        }
    },
    onOrdersViewAfterRender: function onOrdersViewAfterRender(ordersView) {
        this.processFilters();
    },
    onCancelOrderLinkClick: function onCancelOrderLinkClick(view, data, selectedIndex) {
        var orderSummariesStore = this.getStore('TradeOrderSummaries');
        var selectedOrderNumber = orderSummariesStore.getAt(selectedIndex).get('id');
        //Create cancel form
        var cancelForm = Ext.create('Ext.form.Panel', {
            title: 'cancel Form',
            scope: this,
            afterAction: this.processCancelOrderResponse
        }, this);
        var submitActionWithNoResponse = Ext.create('Bullsfirst.extensions.SubmitActionWithNoResponse', {
            form: cancelForm.getForm(),
            headers: {
                Authorization: Bullsfirst.GlobalFunctions.getAuthenticationHeader()
            },
            clientValidation: false,
            timeout: 30,
            url: Bullsfirst.GlobalConstants.BaseUrl +
                '/bfoms-javaee/rest/secure/orders/' +
                selectedOrderNumber +
                '/cancel'
        }, this);
        cancelForm.getForm().doAction(submitActionWithNoResponse);
    },
    onUpdateBtnClick: function onUpdateBtnClick(updateBtn) {
        this.processFilters();
    },
    onResetFilterBtnClick: function onResetFilterBtnClick(resetFilterBtn) {
        this.getOrderViewSymbolFilter().setValue('');
        this.getOrderViewOrderIdFilter().setValue('');
        this.getOrderViewFromDateFilter().setValue(new Date());
        this.getOrderViewToDateFilter().setValue(new Date());
        this.clearChecks(this.getOrderViewSidesFilter());
        this.clearChecks(this.getOrderViewStatusesFilter());
        this.processFilters();
    },
    processCancelOrderResponse: function processCancelOrderResponse(form, success) {
        if (success) {
            //Reload orders store
            this.scope.processFilters();
            EventAggregator.publish('ordercanceled');
        } else {
            EventAggregator.publish('ordercancellationError');
        }
    },
    clearChecks: function clearChecks(checkBoxGroup) {
        checkBoxGroup.items.each(function (checkBoxItem) {
            checkBoxItem.setValue(false);
        });
    },
    getFilteredChecks: function getFilteredChecks(checkBoxGroup) {
        var selectedChecks = '';
        checkBoxGroup.items.each(function (checkBoxItem) {
            if (checkBoxItem.getValue() === true) {
                if (selectedChecks !== '') {
                    selectedChecks += ',';
                }
                selectedChecks += checkBoxItem.boxLabel.split(' ').join('');
            }
        });
        return selectedChecks;
    },
    processFilters: function processFilters() {
        var fromDateFilterValue = this.getOrderViewFromDateFilter().getValue();
        var toDateFilterValue = this.getOrderViewToDateFilter().getValue();
        var sides = this.getFilteredChecks(this.getOrderViewSidesFilter());
        var statuses = this.getFilteredChecks(this.getOrderViewStatusesFilter());
        var filterParams = {
            accountId: this.getOrderViewCombo().getValue(),
            symbol: this.getOrderViewSymbolFilter().getValue(),
            orderId: this.getOrderViewOrderIdFilter().getValue(),
            fromDate: fromDateFilterValue == null ? '' : Ext.Date.format(fromDateFilterValue, 'Y-m-d'),
            toDate: toDateFilterValue == null ? '' : Ext.Date.format(toDateFilterValue, 'Y-m-d'),
            sides: sides,
            statuses: statuses
        };
        this.loadOrdersStore(filterParams);
    },
    loadOrdersStore: function loadOrdersStore(params) {
        var orderSummariesStore = this.getStore('TradeOrderSummaries');
        var orderSummriesTreeStore = this.getStore('TradeOrderSummariesTree');

        var ordersProxy = orderSummariesStore.proxy;
        ordersProxy.queryParams = params;

        //After orders store is loaded, load tree store
        EventAggregator.subscribe('ordersstoreloaded', function (ordersStore) {
            if (ordersStore.count() > 0) {
                var i, j;
                orderSummriesTreeStore.autoLoad = true;
                var orderModels = ordersStore.getRange();
                var orders = [];
                for (i = 0; i < orderModels.length; i++) {
                    var executions = orderModels[i].get('executions');
                    if (executions && executions.length > 0) {
                        for (j = 0; j < executions.length; j++) {
                            executions[j].id = orderModels[i].get('id') + '/' + executions[j].id;
                        }
                    }
                    orders.push(orderModels[i].data);
                }
                orderSummriesTreeStore.proxy.data = { executions: orders };
            } else {
                orderSummriesTreeStore.proxy.data = null;
            }
            orderSummriesTreeStore.load();
        });
        orderSummariesStore.load();
    }
});
 
	
