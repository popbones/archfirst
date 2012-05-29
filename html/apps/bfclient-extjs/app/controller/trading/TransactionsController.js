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
* app/controller/trading/TransactionsController
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.controller.trading.TransactionsController', {
    extend: 'Ext.app.Controller',

    views: [
		'trading.TradingTabPanel',
		'trading.TransactionsView'
    ],

    models: [
        'Transaction'
    ],

    stores: [
        'Transactions'
    ],

    refs: [
        {
            ref: 'TransactionsViewGrid',
            selector: 'transactionsview grid'
        },
        {
            ref: 'TransactionsViewCombo',
            selector: 'transactionsview combo'
        },
        {
            ref: 'TransactionsViewFromDateFilter',
            selector: 'transactionsview datefield[fieldLabel=From]'
        },
        {
            ref: 'TransactionsViewToDateFilter',
            selector: 'transactionsview datefield[fieldLabel=To]'
        }
    ],

    init: function () {
        this.control({
            'transactionsview combo': {
                'change': this.onTransactionsViewComboChange
            },
            'transactionsview': {
                'afterrender': this.onTransactionsViewAfterRender
            },
            'transactionsview button[text=Update]': {
                'click': this.onUpdateBtnClick
            },
            'transactionsview button[text=Reset Filter]': {
                'click': this.onResetFilterBtnClick
            }
        });
        this.callParent();
    },
    onTransactionsViewComboChange: function onTransactionsViewComboChange(transactionsViewCombo, newValue, oldValue) {
        //load transactions store when combo value is changed
        if (newValue !== oldValue && oldValue !== null && oldValue !== undefined) {
            this.processFilters();
        }
    },
    onTransactionsViewAfterRender: function onTransactionsViewAfterRender(transactionsView) {
        this.getStore('Transactions').removeAll();
        this.processFilters();
    },
    onUpdateBtnClick: function onUpdateBtnClick(updateBtn) {
        this.processFilters();
    },
    onResetFilterBtnClick: function onResetFilterBtnClick(resetFilterBtn) {
        this.getTransactionsViewFromDateFilter().setValue(new Date());
        this.getTransactionsViewToDateFilter().setValue(new Date());
        this.processFilters();
    },
    loadTransactionsStore: function loadTransactionsStore(params) {
        var transactionsStore = this.getStore('Transactions');
        var transactionsProxy = Bullsfirst.model.Transaction.proxy;
        transactionsProxy.queryParams = params;
        transactionsStore.load();
    },
    processFilters: function processFilters() {
        var fromDateFilterValue = this.getTransactionsViewFromDateFilter().getValue();
        var toDateFilterValue = this.getTransactionsViewToDateFilter().getValue();
        var filterParams = {
            accountId: this.getTransactionsViewCombo().getValue(),
            fromDate: fromDateFilterValue == null ? '' : Ext.Date.format(fromDateFilterValue, 'Y-m-d'),
            toDate: toDateFilterValue == null ? '' : Ext.Date.format(toDateFilterValue, 'Y-m-d')
        };
        this.loadTransactionsStore(filterParams);
    }
}); 

 
	
