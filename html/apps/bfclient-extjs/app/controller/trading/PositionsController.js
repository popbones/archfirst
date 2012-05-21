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
* app/controller/trading/PositionsController
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.controller.trading.PositionsController', {
    extend: 'Ext.app.Controller',

    views: [
		'trading.PositionsView',
		'trading.TradingTabPanel'
    ],

    models: [
        'BrokerageAccountSummary',
		'Position'
    ],

    stores: [
        'BrokerageAccountSummaries',
		'Positions',
        'PositionsTree',
        'TradeActions'
    ],

    refs: [
        {
            ref: 'TradingTabPanel',
            selector: 'tradingtabpanel'
        },
        {
            ref: 'TradeTab',
            selector: 'tradingtabpanel component[title=Trade]'
        },
        {
            ref: 'PositionsViewCombo',
            selector: 'positionsview combo'
        },
        {
            ref: 'PositionsViewGrid',
            selector: 'positionsview grid'
        }
    ],

    init: function () {
        this.control({
            'positionsview combo': {
                'change': this.onPositionViewComboChange
            },
            'positionsview templatecolumn': {
                'click': this.onActionColumnClick
            },
            'positionsview button': {
                'click': this.onUpdateButtonClick
            }
        });
        this.callParent();
    },
    onPositionViewComboChange: function onPositionViewComboChange(positionViewCombo, newValue, oldValue) {
        var tradingTabPanel = this.getTradingTabPanel();
        var positionsStore = this.getStore('PositionsTree');
        tradingTabPanel.selectedBrokerageAccount.setValue(this.getStore('BrokerageAccountSummaries').findRecord('id', newValue));
        this.reloadPositions();

    },
    onUpdateButtonClick: function onUpdateButtonClick() {
        this.reloadPositions();
    },
    onActionColumnClick: function onActionColumnClick(view, data, selectedIndex, selectedColumn, event, selectedRecord) {
        var tradeType = 'Buy';
        var positionsViewCombo = this.getPositionsViewCombo();
        if (selectedColumn == 10) {
            tradeType = 'Sell';
        }
        var positionsStore = this.getStore('PositionsTree');
        var tradingTabPanel = this.getTradingTabPanel();
        var tradeTab = this.getTradeTab();
        var tradeForm = tradeTab.down('form').getForm();

        var tradeOrder = Ext.create('Bullsfirst.model.TradeOrder',
            {
                symbol: selectedRecord.get('instrumentSymbol'),
                action: tradeType,
                quantity: selectedRecord.get('quantity'),
                orderType: 'Market',
                term: 'GoodForTheDay',
                allOrNone: false
            });
        tradeForm.loadRecord(tradeOrder);

        var selectedBrokerageAccountId = positionsViewCombo.getValue();
        tradeTab.down('combo').setValue(selectedBrokerageAccountId);
        tradingTabPanel.setActiveTab(tradeTab);
    },
    reloadPositions: function reloadPositions() {
        var tradingTabPanel = this.getTradingTabPanel();
        var positionsStore = this.getStore('PositionsTree');
        var positionModels = tradingTabPanel.selectedBrokerageAccount.getValue().positions().getRange();
        var positions = new Array();
        for (var i = 0; i < positionModels.length; i++) {
            positions.push(Ext.clone(positionModels[i].data));
        }
        positionsStore.proxy.data = { children: positions };
        positionsStore.load();
    }


}); 

 
	
