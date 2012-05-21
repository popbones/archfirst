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
* app/controller/trading/AccountsController
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.controller.trading.AccountsController', {
    extend: 'Ext.app.Controller',

    views: [
		'trading.AccountsView',
		'accounts.CreateAccountView',
		'trading.CreateBrokerageAccountView',
        'trading.EditBrokerageAccountView',
		'trading.TradingTabPanel'
    ],

    models: [
        'BrokerageAccount',
        'EditBrokerageAccount',
		'BrokerageAccountSummary'
    ],

    stores: [
        'BrokerageAccounts',
		'BrokerageAccountSummaries'
    ],

    refs: [
        {
            ref: 'TradingTabPanel',
            selector: 'tradingtabpanel'
        },
        {
            ref: 'PositionsViewCombo',
            selector: 'positionsview combo'
        },
        {
            ref: 'PositionsTab',
            selector: 'tradingtabpanel component[title=Positions]'
        },
        {
            ref: 'CreateAccountOkButton',
            selector: 'createBrokerageAccountView button[itemId=OkBtn]'
        },
        {
            ref: 'CreateBrokerageAccountTextField',
            selector: 'createBrokerageAccountView textfield'
        },
        {
            ref: 'AccountsViewGrid',
            selector: 'accountsview grid'
        },
        {
            ref: 'LegendPanel',
            selector: 'accountsview container[region=south]'
        },
        {
            ref: 'TitlePanel',
            selector: 'accountsview container[region=north]'
        }
    ],

    init: function () {
        this.control({
            'accountsview button[itemId=AddAccountBtn]': {
                'click': this.onAddAccountButtonClick
            },
            'accountsview button[itemId=UpdateAccountBtn]': {
                'click': this.onUpdateAccountButtonClick
            },
            'createBrokerageAccountView button[itemId=OkBtn]': {
                'click': this.onCreateAccountOkButtonClick
            },
            'createBrokerageAccountView button[itemId=CancelBtn]': {
                'click': this.onCreateAccountCancelButtonClick
            },
            'editbrokerageaccountview button[itemId=OkBtn]': {
                'click': this.onEditAccountOkButtonClick
            },
            'editbrokerageaccountview button[itemId=CancelBtn]': {
                'click': this.onEditAccountCancelButtonClick
            },
            'accountsview templatecolumn[text=Name]': {
                'click': this.onAccountsBrokerageNameClick
            },
            'accountsview templatecolumn[text=Actions]': {
                'click': this.onEditAccountLinkClick
            },
            'accountsview container[region=south]': {
                'afterrender': this.onLegendPanelAfterRender
            },
            'accountsview chart': {
                'piesliceclick': this.onChartPieSliceClick
            }
        });
        this.callParent();
    },
    onEditAccountLinkClick: function onEditAccountLinkClick(view, data, selectedIndex) {
        //Show "Edit account" popup
        var editWindow = Ext.create('widget.editbrokerageaccountview');
        var brokerageAccountsStore = this.getStore('BrokerageAccountSummaries');
        var editBrokerageAccountForm = editWindow.down('form');
        editBrokerageAccountForm.getForm().loadRecord(brokerageAccountsStore.getAt(selectedIndex));
        editWindow.show();
    },
    onAddAccountButtonClick: function onAddAccountButtonClick(addAccountBtn) {
        Ext.create('widget.createBrokerageAccountView').show();
    },
    onUpdateAccountButtonClick: function onUpdateAccountButtonClick(updateAccountBtn) {
        //Reload brokerage account summary store
        this.getStore('BrokerageAccountSummaries').load();
    },
    onCreateAccountOkButtonClick: function onCreateAccountOkButtonClick(okBtn) {
        okBtn.disable();
        var brokerageAccountsStore = this.getStore('BrokerageAccountSummaries');
        EventAggregator.subscribe('brokerageaccountcreated', function () {
            brokerageAccountsStore.load();
            okBtn.up('window').close();
        }, this);
        this.createBrokerageAccount(this.getCreateBrokerageAccountTextField().getValue());
    },
    onCreateAccountCancelButtonClick: function onCreateAccountCancelButtonClick(cancelBtn) {
        cancelBtn.up('window').close();
    },
    onEditAccountOkButtonClick: function onEditAccountOkButtonClick(okBtn) {
        okBtn.disable();
        var editBrokerageAccountForm = okBtn.up('form');
        var brokerageAccountsStore = this.getStore('BrokerageAccountSummaries');
        var brokerageAccount = Ext.create('Bullsfirst.model.EditBrokerageAccount');
        var accountProxy = brokerageAccount.getProxy();
        var templateUrl = accountProxy.url;
        accountProxy.url = Ext.String.format(accountProxy.url, editBrokerageAccountForm.getForm().getRecord().get('id'));
        editBrokerageAccountForm.getForm().updateRecord(brokerageAccount);
        EventAggregator.subscribe('brokerageaccountedited', function () {
            brokerageAccountsStore.load();
            okBtn.up('window').close();
        }, this);
        this.editBrokerageAccount(brokerageAccount);
        accountProxy.url = templateUrl;
    },
    onEditAccountCancelButtonClick: function onEditAccountCancelButtonClick(cancelBtn) {
        cancelBtn.up('window').close();
    },
    onAccountsBrokerageNameClick: function onAccountsBrokerageNameClick(view, object, selectedRecordIndex) {
        //if account name is clicked, change the selected account and switched to positions tab
        var tradingTabPanel = this.getTradingTabPanel();
        this.getPositionsViewCombo().setValue(this.getStore('BrokerageAccountSummaries').getAt(selectedRecordIndex));
        tradingTabPanel.setActiveTab(this.getPositionsTab());
    },
    createBrokerageAccount: function (brokerageAccountName) {
        var brokerageAccount = Ext.create('Bullsfirst.model.BrokerageAccount', { accountName: brokerageAccountName }, this);
        brokerageAccount.phantom = true;
        brokerageAccount.save({
            action: 'create',
            scope: this,
            callback: function (record, operation, success) {
                if (operation.wasSuccessful() == true) {
                    EventAggregator.publish('brokerageaccountcreated', operation);
                }
                else {
                    EventAggregator.publish('brokerageaccountcreationError', operation)
                }
            }
        }, this);
    },
    editBrokerageAccount: function (brokerageAccount) {
        brokerageAccount.phantom = true;
        brokerageAccount.save({
            action: 'create',
            scope: this,
            callback: function (record, operation, success) {
                if (operation.wasSuccessful() == true) {
                    EventAggregator.publish('brokerageaccountedited');
                }
                else {
                    EventAggregator.publish('brokerageaccounteditError', operation)
                }
            }
        }, this);
    },
    onLegendPanelAfterRender: function legendPanelAfterRender(legendPanel) {
        EventAggregator.subscribeForever('brokerageaccountschartstoreloaded', function (brokerageAccountsChartStore) {
            var brokerageAccountsStore = this.getStore('BrokerageAccountSummaries');
            if (brokerageAccountsChartStore.count() == brokerageAccountsStore.count()) {
                this.getTitlePanel().update('All Accounts');
            }
            if (brokerageAccountsChartStore.count() > 0) {
                var legendItems = [];
                var index = 0;
                var smartChartTheme = Bullsfirst.extensions.SmartChartTheme;
                brokerageAccountsChartStore.each(function (account) {
                    var legendItem = Ext.create('Ext.draw.Component', {
                        gradients: smartChartTheme.legendGradients,
                        viewBox: false,
                        items: [
                            {
                                type: 'rect',
                                fill: smartChartTheme.legendColors[index],
                                radius: 1,
                                width: 10,
                                height: 10,
                                x: 5,
                                y: 5
                            },
                            {
                                type: 'text',
                                fill: 'black',
                                width: 10,
                                height: 10,
                                text: function () {
                                    var name = account.get('name');
                                    if (Ext.isEmpty(name)) {
                                        name = account.get('instrumentSymbol');
                                    }
                                    return name;
                                } (),
                                x: 20,
                                y: 10
                            }
                        ]
                    });
                    legendItems.push(legendItem);
                    index++;
                    if (index == smartChartTheme.legendGradients.length) {
                        index = 0;
                    }
                });
                legendPanel.removeAll();
                legendPanel.add(legendItems);
            }
        }, this);
    },
    onChartPieSliceClick: function onChartPieSliceClick(pieslice) {
        var selectedRecord = pieslice.storeItem;
        var chartStore = this.getStore('BrokerageAccountChartSummaries');
        var brokerageAccountsStore = this.getStore('BrokerageAccountSummaries');
        var title = 'All Accounts';
        chartStore.removeAll();

        var selectedRecordId = selectedRecord.get('id');
        var storeData;
        if (selectedRecord.positions) {
            var positionsStore = selectedRecord.positions();
            if (positionsStore && positionsStore.count() > 0) {
                storeData = positionsStore.getRange();
                title = selectedRecord.get('name');
            }
            else {
                storeData = brokerageAccountsStore.getRange();
            }
        }
        else {
            storeData = brokerageAccountsStore.getRange();
        }
        chartStore.add(storeData);
        var titlePanel = this.getTitlePanel();
        titlePanel.update(title);
        EventAggregator.publish('brokerageaccountschartstoreloaded', chartStore);
    }
}); 

 
	
