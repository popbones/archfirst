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
* app/view/trading/TransactionsView
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.trading.TransactionsView', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.transactionsview',

    //Configs


    //Functions                                /// <reference path="../../Model/" />

    initComponent: function initPositionsViewComponents() {
        var viewConfig = {
            margin: '0 20 0 20'
        };
        this.buildConfig(viewConfig);
        Ext.apply(this, Ext.apply(this.initialConfig, viewConfig));
        this.callParent();
    },
    buildConfig: function buildPositionsViewConfig(viewConfig) {
        this.buildItems(viewConfig);
        this.buildToolbars(viewConfig);
        this.buildButtons(viewConfig);
    },
    buildItems: function buildPositionsViewItems(viewConfig) {
        viewConfig.items = [
            this.buildGridPanelConfig()

        ];
    },
    buildToolbars: function buildPositionsViewToolbars(viewConfig) {
        viewConfig.dockedItems = [
            {
                xtype: 'toolbar',
                dock: 'top',
                ui: 'footer',
                margin: '5 0 5 0',
                padding: {
                    left: 2,
                    bottom: 1
                },
                items: [
                    {
                        xtype: 'tbfill'
                    },
                    {
                        xtype: 'combo',
                        width: 300,
                        editable: false,
                        plugins: ['loadmask'],
                        store: 'BrokerageAccountSummaries',
                        displayField: 'fullname',
                        queryMode: 'local',
                        valueField: 'id'
                    }

                ]

            },
            {
                xtype: 'toolbar',
                dock: 'top',
                margin: '5 0 5 5',
                ui: 'footer',
                padding: {
                    left: 2,
                    top: 5,
                    bottom: 1
                },
                items: [
                    {
                        xtype: 'datefield',
                        width: 140,
                        fieldLabel: 'From',
                        value: new Date(),
                        labelWidth: 35,
                        validator: Bullsfirst.GlobalFunctions.validateFromDate
                    },
                    {
                        xtype: 'datefield',
                        width: 140,
                        labelWidth: 35,
                        value: new Date(),
                        fieldLabel: 'To',
                        validator: Bullsfirst.GlobalFunctions.validateToDate
                    },
                    {
                        xtype: 'tbfill'
                    },
                    {
                        text: 'Update'
                    },
                    {
                        text: 'Reset Filter'
                    }

                ]

            }

        ];
    },
    buildButtons: function buildPositionsViewButtons(viewConfig) {
        viewConfig.buttons = undefined;
    },
    buildGridPanelConfig: function buildGridPanelConfig() {
        var gridPanelConfig = {
            xtype: 'grid',
            plugins: ['loadmask'],
            bodyStyle: {
                border: 0
            },
            plugins: ['loadmask'],
            store: 'Transactions',
            flex: 1,
            columns: [
                {
                    header: 'Creation Time',
                    xtype: 'datecolumn',
                    flex: 3,
                    dataIndex: 'creationTime',
                    renderer: function (value) {
                        return Bullsfirst.GlobalFunctions.formatDate(value);
                    }
                },
                {
                    header: 'Type',
                    flex: 1,
                    dataIndex: 'type'
                },
                {
                    header: 'Description',
                    flex: 5,
                    dataIndex: 'description'
                },
                {
                    header: 'Amount',
                    dataIndex: 'amount',
                    flex: 1.5,
                    align: 'right',
                    renderer: Bullsfirst.extensions.Format.usMoney
                },
                {
                    header: '',
                    flex: 5
                }
            ]

        };
        return gridPanelConfig;
    }
});
