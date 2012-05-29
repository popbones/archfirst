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
* app/controller/trading/TradeController
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.controller.trading.TradeController', {
    extend: 'Ext.app.Controller',

    views: [
		'trading.TradeView',
		'trading.TradingTabPanel',
        'trading.PreviewOrderView'
    ],

    models: [
        'TradeAction',
		'TradeOrderType',
		'TradeTerm',
        'TradeOrder',
        'Instrument',
        'MarketPrice',
        'TradeOrderEstimateRequest',
        'TradeOrderEstimate',
        'TradeOrderRequest'
    ],

    stores: [
        'TradeActions',
		'TradeOrderTypes',
		'TradeTerms',
        'Instruments',
        'MarketPrices'
    ],

    refs: [
        {
            ref: 'TradeViewCombo',
            selector: 'tradeview combo'
        },
        {
            ref: 'TradeForm',
            selector: 'tradeview form'
        },
        {
            ref: 'LastTradeField',
            selector: 'tradeview displayfield[fieldLabel=Last Trade]'
        },
        {
            ref: 'PreviewOrderWindow',
            selector: 'previeworderview'
        },
        {
            ref: 'PreviewOrderForm',
            selector: 'previeworderview form'
        },
        {
            ref: 'TradingTabPanel',
            selector: 'tradingtabpanel'
        },
        {
            ref: 'OrdersTab',
            selector: 'tradingtabpanel component[title=Orders]'
        },
        {
            ref: 'PositionsViewCombo',
            selector: 'positionsview combo'
        }
    ],

    init: function () {
        this.control({
            'tradeview combo[fieldLabel=Symbol]': {
                'change': this.onTradeSymbolComboChange,
                'blur': this.onTradeSymbolComboBlur
            },
            'tradingtabpanel component[title=Trade]': {
                'activate': this.onTradeViewActivate
            },
            'tradeview combo[fieldLabel=Action]': {
                'beforerender': this.onTradeActionComboBeforeRender
            },
            'tradeview combo[fieldLabel=Order Type]': {
                'beforerender': this.onTradeOrderTypeComboBeforeRender
            },
            'tradeview combo[fieldLabel=Term]': {
                'beforerender': this.onTradeTermComboBeforeRender
            },
            'tradeview button': {
                'click': this.onTradePreviewOrderBtnClick
            },
            'previeworderview button[itemId=EditOrderBtn]': {
                'click': this.onPreviewOrderEditOrderBtnClick
            },
            'previeworderview button[itemId=PlaceOrderBtn]': {
                'click': this.onPreviewOrderPlaceOrderBtnClick
            }
        });
        this.callParent();
    },
    onTradeViewActivate: function onTradeViewActivate() {
        var instrumentsStore = this.getStore('Instruments');
        instrumentsStore.clearFilter();
        if (instrumentsStore.count() === 0) {
            instrumentsStore.load();
        }
    },
    onTradeActionComboBeforeRender: function onTradeActionComboBeforeRender(tradeActionCombo) {
        tradeActionCombo.setValue(this.getStore('TradeActions').first());
    },
    onTradeOrderTypeComboBeforeRender: function onTradeOrderTypeComboBeforeRender(tradeOrderTypeCombo) {
        tradeOrderTypeCombo.setValue(this.getStore('TradeOrderTypes').first());
    },
    onTradeTermComboBeforeRender: function onTradeTermComboBeforeRender(tradeTermCombo) {
        tradeTermCombo.setValue(this.getStore('TradeTerms').first());
    },
    onTradePreviewOrderBtnClick: function onTradePreviewOrderButtonClick(tradePreviewOrderBtn) {
        var tradeForm = tradePreviewOrderBtn.up('form');
        if (tradeForm.getForm().hasInvalidField()) {
            Ext.Msg.alert(Bullsfirst.GlobalConstants.ErrorTitle, Bullsfirst.GlobalConstants.InvalidForm);
            tradePreviewOrderBtn.disable();
        }

        var newTradeOrder = Ext.create('Bullsfirst.model.TradeOrder');
        var brokerageAccountId = this.getTradeViewCombo().getValue();
       
        tradeForm.getForm().updateRecord(newTradeOrder);
        //Create order estimate request
        var tradeOrderEstimateRequest = Ext.create('Bullsfirst.model.TradeOrderEstimateRequest',
            {
                brokerageAccountId: brokerageAccountId,
                orderParams: newTradeOrder
            });

        EventAggregator.subscribe('orderestimatecreated', function (operation) {
            //If order estimate is recieved, update order request
            var responseText = JSON.parse(operation.response.responseText);
            var tradeOrderEstimate = Ext.ModelManager.create(responseText, 'Bullsfirst.model.TradeOrderEstimate');
            if (tradeOrderEstimate.get('compliance') == 'Compliant') {
                tradeForm.getForm().updateRecord(newTradeOrder);
                var lastTradeValue = this.getLastTradeField().getValue();
                if (Ext.isEmpty(lastTradeValue)) {
                    return;
                }
                newTradeOrder.set('lastTrade', lastTradeValue);
                newTradeOrder.set('estimatedValue', tradeOrderEstimate.get('estimatedValue'));
                newTradeOrder.set('fees', tradeOrderEstimate.get('fees'));
                newTradeOrder.set('totalIncludingFees', tradeOrderEstimate.get('estimatedValueInclFees'));
                var previewOrderWindow = Ext.create('widget.previeworderview');
                previewOrderWindow.down('form').getForm().loadRecord(newTradeOrder);
                previewOrderWindow.show();
            } else {
                operation.customError = 'Order is not compliant: ' + tradeOrderEstimate.get('compliance');
                EventAggregator.publish('tradeordercomplianceError', operation);
                tradePreviewOrderBtn.enable();
            }

        }, this);

        tradeOrderEstimateRequest.phantom = true;
        //Submit trade order estimate request
        tradeOrderEstimateRequest.save({
            action: 'create',
            scope: this,
            callback: function (record, operation, success) {
                if (operation.wasSuccessful() === true) {
                    EventAggregator.publish('orderestimatecreated', operation);
                } else {
                    EventAggregator.publish('orderestimatecreationError', operation);
                }
            }
        }, this);

    },
    onPreviewOrderEditOrderBtnClick: function onPreviewOrderEditOrderBtnClick(previewOrderEditOrderBtn) {
        previewOrderEditOrderBtn.up('window').close();
    },
    onPreviewOrderPlaceOrderBtnClick: function onPreviewOrderPlaceOrderBtnClick(previewOrderPlaceOrderBtn) {
        previewOrderPlaceOrderBtn.disable();
        var previewOrderForm = previewOrderPlaceOrderBtn.up('form');
        var tradeOrder = previewOrderForm.getForm().getRecord();
        var brokerageAccountId = this.getTradeViewCombo().getValue();
        var tradingTabPanel = this.getTradingTabPanel();
        //Create order request
        var tradeOrderRequest = Ext.create('Bullsfirst.model.TradeOrderRequest',
            {
                brokerageAccountId: brokerageAccountId,
                orderParams: tradeOrder
            });


        EventAggregator.subscribe('ordercreated', function (operation) {
            //if order is created successfully, close preview window and switch to orders tab
            previewOrderPlaceOrderBtn.up('window').close();
            var brokerageAccountsStore = this.getStore('BrokerageAccountSummaries');
            var brokerageAcct = brokerageAccountsStore.getById(brokerageAccountId);
            this.getPositionsViewCombo().setValue(brokerageAcct);
            this.getController('Bullsfirst.controller.trading.OrdersController').processFilters();
            tradingTabPanel.setActiveTab(this.getOrdersTab());
        }, this);

        tradeOrderRequest.phantom = true;
        tradeOrderRequest.save({
            action: 'create',
            scope: this,
            callback: function (record, operation, success) {
                if (operation.wasSuccessful() === true) {
                    EventAggregator.publish('ordercreated', operation);
                } else {
                    EventAggregator.publish('ordercreationError', operation);
                    previewOrderPlaceOrderBtn.enable();
                }
            }
        }, this);

    },
    onTradeSymbolComboBlur: function (tradeSymbolCombo) {
        var instrumentsStore = this.getStore('Instruments');
        var selectedValue = tradeSymbolCombo.getRawValue();
        if (instrumentsStore.findExact('symbol', selectedValue) < 0) {
            var valueIndex = instrumentsStore.findExact('symbolFullName', selectedValue);
            if (valueIndex >= 0) {
                tradeSymbolCombo.setValue(instrumentsStore.getAt(valueIndex));
            }
        }
    },
    onTradeSymbolComboChange: function onTradeSymbolComboChange(tradeSymbolCombo, newValue, oldValue) {
        if (this.getStore('Instruments').findExact('symbol', newValue) >= 0) {
            tradeSymbolCombo.setRawValue(newValue);
        } else {
            return;
        }
        if (newValue !== oldValue) {
            var marketPrice = this.getModel('MarketPrice');
            EventAggregator.subscribe('marketpricerecieved', function (operation) {
                var lastTradeField = this.getLastTradeField();
                var recievedMarketPrice = operation.resultSet.records[0];
                lastTradeField.setVisible(true);
                lastTradeField.setValue(recievedMarketPrice.get('price'));
            }, this);

            //if symbol changed, get its market value
            marketPrice.load(tradeSymbolCombo.getValue(), {
                scope: this,
                callback: function (record, operation) {
                    if (operation.wasSuccessful() === true) {
                        EventAggregator.publish('marketpricerecieved', operation);
                    } else {
                        EventAggregator.publish('marketpricerecieveError', operation);
                    }
                }
            }, this);
        }


    }


}); 

 
	
