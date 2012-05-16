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
* app/controller/trading/TransferController
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.controller.trading.TransferController', {
    extend: 'Ext.app.Controller',

    views: [
		'trading.TradingTabPanel',
		'trading.TransferView',
        'trading.CreateExternalAccountView'
    ],

    models: [
        'CashTransfer',
		'ExternalAccount',
		'SecuritiesTransfer',
        'MarketPrice'
    ],

    stores: [
         'ExternalAccounts',
         'BrokerageAccountSummaries',
         'AllAccounts',
         'Instruments'
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
            ref: 'LastTradeField',
            selector: 'transferview displayfield[name=lastTrade]'
        },
        {
            ref: 'TransferForm',
            selector: 'transferview form'
        },
        {
            ref: 'TransferFormSymbolContainer',
            selector: 'transferview container[transferType=Securities]',
        },
        {
            ref: 'TransferFromAccountField',
            selector: 'transferview combo[fieldLabel=From]'
        },
        {
            ref: 'TransferToAccountField',
            selector: 'transferview combo[fieldLabel=To]'
        },
        {
            ref: 'TransferSymbolField',
            selector: 'transferview combo[fieldLabel=Symbol]'
        },
        {
            ref: 'CreateExternalAccountWindow',
            selector: 'createexternalaccountview'
        },
        {
            ref: 'PositionsViewCombo',
            selector: 'positionsview combo'
        }
    ],

    init: function () {
        this.control({
            'tradingtabpanel component[title=Transfer]': {
                'activate': this.onTransferViewActivate
            },
            'transferview combo[fieldLabel=Symbol]': {
                'change': this.onTransferSymbolComboChange,
                'blur': this.onTransferSymbolComboBlur
            },
            'transferview component[itemId=createExternalAccountLink]': {
                'render': this.oncreateExternalAccountLinkRender
            },
            'transferview radiofield': {
                'change': this.onRadioFieldChange
            },
            'createexternalaccountview button[itemId=OkBtn]': {
                'click': this.onOkBtnClick
            },
            'createexternalaccountview button[itemId=CancelBtn]': {
                'click': this.onCancelBtnClick
            },
            'transferview button': {
                'click': this.onTransferBtnClick
            }
        });
        this.callParent();
    },
    onTransferViewActivate: function onTransferViewActivate() {
        this.loadAllStores();
    },
    oncreateExternalAccountLinkRender: function oncreateExternalAccountLinkRender(createExternalAccountLink) {
        createExternalAccountLink.getEl().on('click', this.oncreateExternalAccountLinkClick, this);
    },
    oncreateExternalAccountLinkClick: function oncreateExternalAccountLinkClick(createExternalAccountLink) {
        var createExternalAccountWindow = Ext.create('widget.createexternalaccountview');
        createExternalAccountWindow.show();
    },
    onOkBtnClick: function onOkBtnClick(okBtn) {
        okBtn.disable();
        var createExternalAccountForm = okBtn.up('form');
        var newExternalAccount = Ext.create('Bullsfirst.model.ExternalAccount');
        createExternalAccountForm.getForm().updateRecord(newExternalAccount);
        EventAggregator.subscribe('externalaccountcreated', function () {
            this.loadAllStores();
            okBtn.up('window').close();
        }, this);
        this.createNewExternalAccount(newExternalAccount);
    },
    onCancelBtnClick: function onCancelBtnClick(cancelBtn) {
        cancelBtn.up('window').close();
    },
    onRadioFieldChange: function onRadioFieldChange(radioField, newValue, oldValue) {
        if (newValue != oldValue && newValue == true) {
            var symbolContainer = this.getTransferFormSymbolContainer();
            symbolContainer.setVisible(symbolContainer.transferType == radioField.boxLabel);
            var transferFormFields = this.getTransferForm().getForm().getFields();
            transferFormFields.each(function (field) {
                if (!Ext.isEmpty(field.transferType) && field.transferType != radioField.boxLabel) {
                    field.setVisible(false);
                }
                else {
                    field.setVisible(true);
                }
            }, this);
        }

    },
    onTransferSymbolComboBlur: function (transferSymbolCombo) {
        var instrumentsStore = this.getStore('Instruments');
        var selectedValue = transferSymbolCombo.getRawValue();
        if (instrumentsStore.findExact('symbol', selectedValue) < 0) {
            var valueIndex = instrumentsStore.findExact('symbolFullName', selectedValue);
            if (valueIndex >= 0) {
                transferSymbolCombo.setValue(instrumentsStore.getAt(valueIndex));
            }
        }
    },
    onTransferSymbolComboChange: function onTransferSymbolComboChange(transferSymbolCombo, newValue, oldValue) {
        if (this.getStore('Instruments').findExact('symbol', newValue) >= 0) {
            transferSymbolCombo.setRawValue(newValue);
        }
        else {
            return;
        }
        if (newValue != oldValue) {
            var marketPrice = this.getModel('MarketPrice');
            var transferForm = this.getTransferForm();
            EventAggregator.subscribe('marketpricerecieved', function (operation) {
                var lastTradeField = this.getLastTradeField();
                var recievedMarketPrice = operation.resultSet.records[0];
                lastTradeField.setVisible(true);
                lastTradeField.setValue(recievedMarketPrice.get('price'));
            }, this);

            //if symbol changed, get its market value
            marketPrice.load(transferSymbolCombo.getValue(), {
                scope: this,
                callback: function (record, operation) {
                    if (operation.wasSuccessful() == true) {
                        EventAggregator.publish('marketpricerecieved', operation);
                    }
                    else {
                        EventAggregator.publish('marketpricerecieveError', operation)
                    }
                 }
            }, this);
        }
    },
    onTransferBtnClick: function onTransferBtnClick(transferBtn) {
        var transferForm = transferBtn.up('form');
        if (transferForm.getForm().hasInvalidField()) {
            Ext.Msg.alert(Bullsfirst.GlobalConstants.ErrorTitle, Bullsfirst.GlobalConstants.InvalidForm);
        }
        transferBtn.disable();
        var newTransferRequest = this.getTransferSymbolField().hidden ?
                                Ext.create('Bullsfirst.model.CashTransfer') :
                                Ext.create('Bullsfirst.model.SecuritiesTransfer');

        var fromAccount = this.getTransferFromAccountField().getValue();
        var toAccount = this.getTransferToAccountField().getValue();
        transferForm.getForm().updateRecord(newTransferRequest);
        this.processTransferRequest(newTransferRequest, fromAccount, transferBtn);
    },
    processTransferRequest: function processTransferRequest(transferRequest, fromAccount, transferBtn) {
        var transferProxy = transferRequest.getProxy();
        var templateUrl = transferProxy.url;
        transferProxy.url = Ext.String.format(transferProxy.url, fromAccount);

        EventAggregator.subscribe('transferprocessed', this.onTransferProcessed, this);

        var toAccount = transferRequest.get('toAccountId');
        transferRequest.phantom = true;
        transferRequest.save({
            action: 'create',
            scope: this,
            callback: function (record, operation, success) {
                if (operation.wasSuccessful() == true) {
                    var accountInfomation = {
                        fromAccount: fromAccount,
                        toAccount: toAccount
                    };
                    EventAggregator.publish('transferprocessed', operation, accountInfomation);
                }
                else {
                    EventAggregator.publish('transferprocessError', operation);
                }
                if (transferBtn) {
                    transferBtn.enable();
                }
            }
        }, this);
        transferProxy.url = templateUrl;
    },
    onTransferProcessed: function (operation, event, accountInformation) {
        var tradingTabPanel = this.getTradingTabPanel();
        var brokerageAccountsStore = this.getStore('BrokerageAccountSummaries');

        EventAggregator.subscribe('brokerageaccountsstoreloaded', function () {
            var brokerageAcct = brokerageAccountsStore.getById(accountInformation.toAccount);
            if (brokerageAcct == null) {
                brokerageAcct = brokerageAccountsStore.getById(accountInformation.fromAccount);
            }
            if (tradingTabPanel != null) {
                tradingTabPanel.setActiveTab(this.getPositionsTab());
                this.getPositionsViewCombo().setValue(brokerageAcct);
                this.getController('Bullsfirst.controller.trading.PositionsController').reloadPositions();
            }
        }, this);

        this.loadAllStores();

    },
    loadAllStores: function loadAllStores() {
        var brokerageAccountsStore = this.getStore('BrokerageAccountSummaries');
        var externalAccountsStore = this.getStore('ExternalAccounts');
        var instrumentsStore = this.getStore('Instruments');
        var allAccountsStore = this.getStore('AllAccounts');
        
        allAccountsStore.removeAll();
        brokerageAccountsStore.load();

        EventAggregator.subscribe('externalaccountsstoreloaded', function () {
            allAccountsStore.loadData(brokerageAccountsStore.getRange());
            allAccountsStore.loadData(externalAccountsStore.getRange(), true);
        }, this);

        externalAccountsStore.load();
        instrumentsStore.clearFilter();
        if (instrumentsStore.count() == 0) {
            instrumentsStore.load();
        }
    },
    createNewExternalAccount: function (newExternalAccount) {
        newExternalAccount.phantom = true;

        //Send request to create external account
        newExternalAccount.save({
            action: 'create',
            scope: this,
            callback: function (record, operation, success) {
                if (operation.wasSuccessful() == true) {
                    EventAggregator.publish('externalaccountcreated', operation);
                }
                else {
                    EventAggregator.publish('externalaccountcreationError', operation)
                }
            }
        }, this);
    }

}); 

 
	
