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
* app/controller/trading/MainController
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.controller.trading.MainController', {
    extend: 'Ext.app.Controller',

    views: [
		'trading.AccountsView',
        'trading.CreateBrokerageAccountView',
		'trading.OrdersView',
		'trading.PositionsView',
		'trading.TradeView',
		'trading.TradingTabPanel',
		'trading.TransactionsView',
		'trading.TransferView',
        'shared.MainContentPanel'
    ],

    models: [
        'User',
        'Position',
        'BrokerageAccountSummary',
        'BrokerageAccount',
        'TradeAction',
        'TradeOrderType',
        'TradeTerm',
        'Instrument',
        'TradeOrderSummary'
    ],

    stores: [
        'Positions',
        'BrokerageAccountSummaries',
        'BrokerageAccountChartSummaries',
        'BrokerageAccounts',
        'TradeActions',
        'TradeOrderTypes',
        'TradeTerms',
        'Instruments',
        'TradeOrderSummaries',
        'PositionsTree'
    ],

    refs: [
        {
            ref: 'TradingTabPanel',
            selector: 'tradingtabpanel'
        },
        {
            ref: 'PositionsTab',
            selector: 'tradingtabpanel component[title=Positions]'
        },
        {
            ref: 'LoggedInUserNameField',
            selector: 'tradingtabpanel label[itemId=userName]'
        },
        {
            ref: 'PositionsViewCombo',
            selector: 'positionsview combo'
        },
        {
            ref: 'TradeViewCombo',
            selector: 'tradeview combo[fieldLabel=Account]'
        },
        {
            ref: 'OrdersViewCombo',
            selector: 'ordersview combo'
        },
        {
            ref: 'TransactionsViewCombo',
            selector: 'transactionsview combo'
        }
    ],

    init: function () {
        this.control({
            'tradingtabpanel': {
                'beforerender': this.onTradingTabPanelBeforeRender
            },
            'tradingtabpanel tabbar': {
                'change': this.onTabPanelTabChange
            },
            'tradingtabpanel component[itemId=signOutLink]': {
                'render': this.onSignOutLinkRender
            }
        });
        this.callParent();
    },
    onTradingTabPanelBeforeRender: function onTradingTabPanelBeforeRender(tradingTabPanel) {
        tradingTabPanel.selectedBrokerageAccount = new Bullsfirst.extensions.SelectedBrokerageAccount();
        tradingTabPanel.selectedBrokerageAccount.addListener('change', this.onSelectedBrokerageAccountChange, this);

        //Show logged in user information
        var firstName = tradingTabPanel.loggedInUser.firstName;
        var lastName = tradingTabPanel.loggedInUser.lastName;
        this.getLoggedInUserNameField().setText(firstName + ' ' + lastName);
        EventAggregator.subscribeForever('brokerageaccountsstoreloaded', this.onBrokerageAccountsStoreLoaded, this);

        //Load brokerage accounts
        this.getStore('BrokerageAccountSummaries').load();
        this.getStore('Instruments').load();
    },
    onSignOutLinkRender: function onSignOutLinkRender(signOutLink) {
        signOutLink.getEl().on('click', this.onSignOutLinkClick, this);
    },
    onSignOutLinkClick: function onSignOutLinkClick(signOutLink) {
        this.getController('login.LoginController').injectView(Ext.create('widget.mainContentPanel'));
        EventAggregator.unsubscribe('brokerageaccountsstoreloaded', this.onBrokerageAccountsStoreLoaded, this);
        this.clearStores();
    },
    onSelectedBrokerageAccountChange: function onSelectedBrokerageAccountChange(newValue) {
        //Selected brokerage account, now update all views
        this.getTradeViewCombo().setValue(newValue);
        this.getOrdersViewCombo().setValue(newValue);
        this.getTransactionsViewCombo().setValue(newValue);
    },
    onTabPanelTabChange: function onTabPanelTabChange(tabBar, newTab) {
        if (newTab) {
            newTab.fireEvent('activate', newTab);
        }
    },
    onBrokerageAccountsStoreLoaded: function (brokerageAccountsStore) {
        var tradingTabPanel = this.getTradingTabPanel();
        var positionsViewCombo = this.getPositionsViewCombo();

        //After brokerage accounts are loaded, load chart store and set first account as the 
        //default account
        if (brokerageAccountsStore.count() > 0) {
            //Load chart store
            var chartStore = this.getStore('BrokerageAccountChartSummaries');
            chartStore.removeAll();
            chartStore.add(brokerageAccountsStore.getRange());
            EventAggregator.publish('brokerageaccountschartstoreloaded', chartStore);

            //Set first account as the default account
            var firstBrokerageAccountId = brokerageAccountsStore.first().get('id');
            tradingTabPanel.selectedBrokerageAccount.setValue(firstBrokerageAccountId);
            positionsViewCombo.on('render', function () {
                if (!positionsViewCombo.getValue()) {
                    positionsViewCombo.setValue(firstBrokerageAccountId);
                }
            });
        }
    },
    clearStores: function clearStores() {
        Ext.data.StoreManager.lookup('TradeOrderSummariesTree').getRootNode().removeAll();
        Ext.data.StoreManager.lookup('PositionsTree').getRootNode().removeAll();
        Ext.data.StoreManager.lookup('Transactions').removeAll();
        Ext.data.StoreManager.lookup('BrokerageAccountSummaries').removeAll();
        Ext.data.StoreManager.lookup('BrokerageAccountChartSummaries').removeAll();
    }

});
	
