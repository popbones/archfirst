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
        var positionsViewCombo = this.getPositionsViewCombo();
        tradingTabPanel.selectedBrokerageAccount = new Bullsfirst.extensions.SelectedBrokerageAccount();
        tradingTabPanel.selectedBrokerageAccount.addListener('change', this.onSelectedBrokerageAccountChange, this);

        //Show logged in user information
        this.getLoggedInUserNameField().setText(tradingTabPanel.loggedInUser.firstName + ' ' + tradingTabPanel.loggedInUser.lastName);
        EventAggregator.subscribe('brokerageaccountsstoreloaded', function (brokerageAccountsStore) {
            if (brokerageAccountsStore.count() > 0) {
                var firstBrokerageAccountId = brokerageAccountsStore.first().get('id');
                tradingTabPanel.selectedBrokerageAccount.setValue(firstBrokerageAccountId);
                positionsViewCombo.on('render', function () {
                    if (!positionsViewCombo.getValue()) {
                        positionsViewCombo.setValue(firstBrokerageAccountId);
                    }
                });
            }
        }, this);
        //Load brokerage accounts
        this.getStore('BrokerageAccountSummaries').load();
        this.getStore('Instruments').load();
    },
    onSignOutLinkRender: function onSignOutLinkRender(signOutLink) {
        signOutLink.getEl().on('click', this.onSignOutLinkClick, this);
    },
    onSignOutLinkClick: function onSignOutLinkClick(signOutLink) {
        this.getController('login.LoginController').injectView(Ext.create('widget.mainContentPanel'));
    },
    onSelectedBrokerageAccountChange: function onSelectedBrokerageAccountChange(newValue) {
        //Selected brokerage account, now update all views
        this.getTradeViewCombo().setValue(newValue);
        this.getOrdersViewCombo().setValue(newValue);
        this.getTransactionsViewCombo().setValue(newValue);
    },
    onTabPanelTabChange: function onTabPanelTabChange(tabBar, newTab) {
        if (newTab != null) {
            newTab.fireEvent('activate', newTab);
        }
    }
}); 

 
	
