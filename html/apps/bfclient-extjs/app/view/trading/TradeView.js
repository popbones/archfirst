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
* app/view/trading/TradeView
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.trading.TradeView', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.tradeview',

    //Configs


    //Functions
    initComponent: function initTradeViewComponents() {
        var viewConfig = {
            
        };
        this.buildConfig(viewConfig);
        Ext.apply(this, Ext.apply(this.initialConfig, viewConfig));
        this.callParent();
    },
    buildConfig: function buildTradeViewConfig(viewConfig) {
        this.buildItems(viewConfig);
        this.buildToolbars(viewConfig);
    },
    buildItems: function buildTradeViewItems(viewConfig) {
        viewConfig.items = [
            this.buildFormPanelConfig()
        ];
    },
    buildFormPanelConfig: function buildFormPanelConfig() {
        var formPanelConfig = {
            xtype: 'smartform',
            cls: 'tradeFormCls',
            margin: '20 0 0 50',
            maxWidth: 600,
            defaults: {
                enableKeyEvents: true,
                allowBlank: false,
                labelWidth: 70,
                margin: '10 15 2 12',
                width: 350
            }
        };
        this.buildFormPanelItems(formPanelConfig);
        this.buildFormPanelButtons(formPanelConfig);
        return formPanelConfig;
    },
    buildFormPanelItems: function (formPanelConfig) {
        formPanelConfig.items = [
            {
                fieldLabel: 'Account',
                xtype: 'combo',
                editable: false,
                plugins: ['loadmask'],
                store: 'BrokerageAccountSummaries',
                name: 'accountName',
                displayField: 'fullname',
                queryMode: 'local',
                valueField: 'id'
            },
            {
                xtype: 'container',
                collapsible: false,
                width: 600,
                layout: {
                    type: 'hbox',
                    align: 'stretch'
                },
                items: [
                    {
                        fieldLabel: 'Symbol',
                        xtype: 'combo',
                        allowBlank: false,
                        name: 'symbol',
                        flex: 1.05,
                        maxWidth: 350,
                        minWidth: 350,
                        labelWidth: 70,
                        typeAhead: true,
                        plugins: ['loadmask'],
                        store: 'Instruments',
                        queryMode: 'local',
                        displayField: 'symbolFullName',
                        valueField: 'symbol'
                    },
                    {
                        xtype: 'displayfield',
                        hidden: true,
                        flex: 1,
                        fieldLabel: 'Last Trade',
                        name: 'lastTrade',
                        labelWidth: 70,
                        margin: '0 0 0 10',
                        width: 300,
                        renderer: Ext.util.Format.usMoney
                    }
                ]
            },
            {
                fieldLabel: 'Action',
                xtype: 'combo',
                editable: false,
                name: 'action',
                plugins: ['loadmask'],
                store: 'TradeActions',
                queryMode: 'local',
                displayField: 'ActionName',
                valueField: 'ActionName'
            },
            {
                fieldLabel: 'Quantity',
                xtype: 'numberfield',
                hideTrigger: true,
                name: 'quantity',
                minValue: 1,
                allowBlank: false
            },
            {
                fieldLabel: 'Order Type',
                xtype: 'combo',
                editable: false,
                name: 'orderType',
                plugins: ['loadmask'],
                store: 'TradeOrderTypes',
                queryMode: 'local',
                displayField: 'OrderTypeName',
                valueField: 'OrderTypeName'
            },
            {
                fieldLabel: 'Term',
                xtype: 'combo',
                editable: false,
                name: 'term',
                plugins: ['loadmask'],
                store: 'TradeTerms',
                queryMode: 'local',
                displayField: 'TermName',
                valueField: 'TermName'
            },
            {
                xtype: 'checkbox',
                name: 'allOrNone',
                margin: '8 0 0 86',
                boxLabel: 'All-or-none'
            }
        ];

    },

    buildToolbars: function buildTradeViewToolbars(viewConfig) {
        viewConfig.dockedItems = undefined;
    },
    buildFormPanelButtons: function buildFormPanelButtons(formPanelConfig) {
        formPanelConfig.dockedItems = [
            {
                xtype: 'toolbar',
                dock: 'bottom',
                ui: 'footer',
                margin: '5 0 5 80',
                defaults: { minWidth: 50, maxWidth: 160 },
                items: [
                    {
                        xtype: 'submitbutton',
                        text: Bullsfirst.GlobalConstants.PreviewOrder,
                        flex: 1
                    }
                ]
            }
           
        ];
    }
});
