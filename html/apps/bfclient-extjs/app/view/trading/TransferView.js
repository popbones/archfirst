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
* app/view/trading/TransferView
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.trading.TransferView', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.transferview',

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
            margin: '20 0 0 20',
            maxWidth: 650,
            defaults: {
                enableKeyEvents: true,
                margin: '10 10 2 0',
                labelWidth: 120,
                width: 400
            }
        };
        this.buildFormPanelItems(formPanelConfig);
        this.buildFormPanelToolbars(formPanelConfig);
        return formPanelConfig;
    },
    buildFormPanelItems: function (formPanelConfig) {
        formPanelConfig.items = [
            {
                xtype: 'radiogroup',
                maxWidth: 200,
                nonresetable: true,
                margin: '0 0 0 100',
                items: [
                    {
                        boxLabel: 'Cash',
                        name: 'instrumentType',
                        nonresetable: true,
                        margin: '0 5 1 20',
                        checked: true,
                        inputValue: '1'
                    },
                    {
                        boxLabel: 'Securities',
                        nonresetable: true,
                        name: 'instrumentType',
                        margin: '0 5 1 20',
                        inputValue: '2'
                    }
                ]

            },
            {
                xtype: 'combo',
                fieldLabel: 'From',
                nonresetable: true,
                allowBlank: false,
                plugins: ['loadmask'],
                store: 'AllAccounts',
                editable: false,
                displayField: 'fullname',
                queryMode: 'local',
                valueField: 'id'
            },
            {
                xtype: 'combo',
                fieldLabel: 'To',
                nonresetable: true,
                plugins: ['loadmask'],
                store: 'AllAccounts',
                allowBlank: false,
                editable: false,
                name: 'toAccountId',
                displayField: 'fullname',
                queryMode: 'local',
                valueField: 'id'

            },
            {
                xtype: 'container',
                collapsible: false,
                margin: '10 10 2 20',
                transferType: 'Securities',
                hidden: true,
                width: 650,
                layout: {
                    type: 'hbox',
                    align: 'stretch'
                },
                items: [
                    {
                        xtype: 'combo',
                        fieldLabel: 'Symbol',
                        name: 'symbol',
                        typeAhead: true,
                        transferType: 'Securities',
                        plugins: ['loadmask'],
                        store: 'Instruments',
                        queryMode: 'local',
                        displayField: 'symbolFullName',
                        hidden: true,
                        valueField: 'symbol',
                        flex: 1.47,
                        validator: this.hiddenFieldValidator
                    },
                    {
                        xtype: 'displayfield',
                        flex: 1,
                        fieldLabel: 'Last Trade',
                        transferType: 'Securities',
                        name: 'lastTrade',
                        hidden: true,
                        labelWidth: 70,
                        margin: '0 0 0 10',
                        width: 300,
                        renderer: Ext.util.Format.usMoney
                    }
                ]
            },
            {
                xtype: 'numberfield',
                fieldLabel: 'Quantity',
                hideTrigger: true,
                name: 'quantity',
                minValue: 1,
                transferType: 'Securities',
                hidden: true,
                validator: this.hiddenFieldValidator
            },
            {
                xtype: 'numberfield',
                hideTrigger: true,
                fieldLabel: 'Price Paid Per Share',
                name: 'pricePaidPerShare',
                minValue: 1,
                transferType: 'Securities',
                hidden: true,
                validator: this.hiddenFieldValidator
            },
            {
                xtype: 'numberfield',
                hideTrigger: true,
                fieldLabel: 'Amount',
                minValue: 1,
                name: 'amount',
                transferType: 'Cash',
                validator: this.hiddenFieldValidator
            }
        ];

    },
    buildFormPanelToolbars: function buildTradeViewToolbars(viewConfig) {
        viewConfig.dockedItems = [
            {
                xtype: 'toolbar',
                dock: 'bottom',
                ui: 'footer',
                margin: '0 0 0 120',
                defaults: { minWidth: 50, maxWidth: 150 },
                items: [
                    {
                        xtype: 'component',
                        itemId: 'createExternalAccountLink',
                        autoEl: { tag: 'a', href: '#', html: Bullsfirst.GlobalConstants.AddExternalAccount },
                        flex: 1
                    }
                ]

            },
            {
                xtype: 'toolbar',
                dock: 'bottom',
                ui: 'footer',
                margin: '5 0 5 120',
                defaults: { minWidth: 50, maxWidth: 60 },
                items: [
                    {
                        xtype: 'submitbutton',
                        text: Bullsfirst.GlobalConstants.Transfer,
                        flex: 1
                    }
                ]
            }
        ];
    },
    hiddenFieldValidator: function (value) {
        if (this.isVisible() && Ext.isEmpty(value)) {
            return 'Please enter ' + this.fieldLabel.toLowerCase();
        } else {
            return true;
        }
    }
});
