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
* app/view/trading/OrdersView
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.trading.OrdersView', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.ordersview',

    //Configs


    //Functions
    initComponent: function initPositionsViewComponents() {
        var viewConfig = {
            margin: '0 20 0 20',
            layout: {
                type: 'vbox',
                align: 'stretch'
            }
        };
        
        this.buildConfig(viewConfig);
        Ext.apply(this, Ext.apply(this.initialConfig, viewConfig));
        this.callParent();
    },
    buildConfig: function buildOrdersViewConfig(viewConfig) {
        this.buildItems(viewConfig);
        this.buildToolbars(viewConfig);
        this.buildButtons(viewConfig);
    },
    buildItems: function buildPositionsViewItems(viewConfig) {
        viewConfig.items = [
            this.buildFilterPanelConfig(),
            this.buildGridPanelConfig()

        ];
    },
    buildToolbars: function buildPositionsViewToolbars(viewConfig) {
        viewConfig.dockedItems = [
            {
                xtype: 'toolbar',
                dock: 'top',
                margin: '5 0 5 0',
                ui: 'footer',
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
                        editable: false,
                        width: 300,
                        plugins: ['loadmask'],
                        store: 'BrokerageAccountSummaries',
                        displayField: 'fullname',
                        queryMode: 'local',
                        valueField: 'id'
                    }

                ]

            }

        ];
    },
    buildButtons: function buildPositionsViewButtons(viewConfig) {
        viewConfig.buttons = undefined;
    },
    buildFilterPanelConfig: function buildFilterPanelConfig() {
        var filterPanelConfig = {
            xtype: 'form',
            flex: 1,
            labelWidth: 70,
            width: 850,
            margin: '10 0 0 0',
            maxHeight: 60,
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            defaults: {

            },
            items: [
                {
                    xtype: 'container',
                    flex: 1,
                    maxHeight: 28,
                    collapsible: false,
                    defaultType: 'textfield',
                    defaults: { anchor: '100%', labelWidth: 40, margin: '0 0 0 20' },
                    layout: {
                        type: 'column'
                    },
                    items: [
                        {
                            fieldLabel: 'Order #',
                            labelWidth: 50,
                            columnWidth: '.16'
                        },
                        {
                            fieldLabel: 'Symbol',
                            columnWidth: '.16',
                            labelWidth: 45
                        },
                        {
                            xtype: 'datefield',
                            fieldLabel: 'From',
                            value: new Date(),
                            labelWidth: 35,
                            columnWidth: '.17',
                            validator: Bullsfirst.GlobalFunctions.validateFromDate
                        },
                        {
                            xtype: 'datefield',
                            labelWidth: 35,
                            value: new Date(),
                            fieldLabel: 'To',
                            columnWidth: '.17',
                            validator: Bullsfirst.GlobalFunctions.validateToDate
                        },
                        {
                            xtype: 'toolbar',
                            ui: 'footer',
                            cls: 'logoToolbarStyle',
                            dock: 'top',
                            columnWidth: '.34',
                            items: [
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
                    ]
                },
                {
                    xtype: 'container',
                    margin: '0 0 0 20',
                    flex: 1,
                    collapsible: true,
                    collapsed: false,
                    checkboxToggle: true,
                    layout: {
                        type: 'column'
                    },
                    items: [
                        {
                            xtype: 'checkboxgroup',
                            vertical: false,
                            fieldLabel: 'Order Action',
                            columnWidth: '.2',
                            labelWidth: 80,
                            items: [
                                {
                                    boxLabel: 'Buy',
                                    name: 'rb',
                                    inputValue: '1'
                                },
                                {
                                    boxLabel: 'Sell',
                                    name: 'rb',
                                    inputValue: '2'
                                }
                            ]
                        },
                        {
                            xtype: 'checkboxgroup',
                            margin: '2 0 0 20',
                            vertical: false,
                            labelWidth: 80,
                            columnWidth: '.6',
                            fieldLabel: 'Order Status',
                            layout: 'column',
                            items: [
                                {
                                    boxLabel: 'New',
                                    name: 'rb',
                                    columnWidth: '0.12',
                                    inputValue: '1'
                                },
                                {
                                    boxLabel: 'Partially Filled',
                                    name: 'rb',
                                    columnWidth: '0.22',
                                    inputValue: '2'
                                },
                                {
                                    boxLabel: 'Filled',
                                    name: 'rb',
                                    columnWidth: '0.12',
                                    inputValue: '3'
                                },
                                {
                                    boxLabel: 'Canceled',
                                    name: 'rb',
                                    columnWidth: '0.17',
                                    inputValue: '4'
                                },
                                {
                                    boxLabel: 'Done For Day',
                                    name: 'rb',
                                    columnWidth: '0.37',
                                    inputValue: '5'
                                }
                            ]

                        },
                        {
                            xtype: 'container',
                            columnWidth: '.2'
                        }
                    ]
                }]
        };
        return filterPanelConfig;
    },
    buildGridPanelConfig: function buildGridPanelConfig() {
        var gridPanelConfig = {
            xtype: 'treepanel',
            rootVisible: false,
            singleExpand: false,
            bodyStyle: {
                border: 0
            },
            plugins: ['loadmask'],
            remoteStore: 'TradeOrderSummaries',
            store: 'TradeOrderSummariesTree',
            flex: 1,
            columns: [
                {
                    header: 'Creation Time',
                    xtype: 'treecolumn',
                    sortable: false,
                    menuDisabled: true,
                    flex: 3,
                    dataIndex: 'creationTime',
                    renderer: function (value) {
                        return Bullsfirst.GlobalFunctions.formatDate(value);
                    }
                },
                {
                    header: 'Order #',
                    dataIndex: 'id',
                    sortable: false,
                    menuDisabled: true,
                    flex: 1.2,
                    align: 'right',
                    renderer: function (value, metadata, record) {
                        if (Ext.isEmpty(record.get('symbol'))) {
                            return ' ';
                        }
                        return record.get('id');
                    }
                },
                {
                    header: 'Type',
                    sortable: false,
                    menuDisabled: true,
                    flex: 1.2,
                    dataIndex: 'type'

                },
                {
                    header: 'Action',
                    sortable: false,
                    menuDisabled: true,
                    flex: 1.2,
                    dataIndex: 'side'
                },
                {
                    header: 'Symbol',
                    sortable: false,
                    menuDisabled: true,
                    flex: 2,
                    dataIndex: 'symbol'
                },
                {
                    header: 'Quantity',
                    sortable: false,
                    menuDisabled: true,
                    dataIndex: 'quantity',
                    flex: 1.5,
                    align: 'right',
                    renderer: Bullsfirst.extensions.Format.quantity
                },
                {
                    header: 'Limit Price',
                    sortable: false,
                    menuDisabled: true,
                    flex: 1.5,
                    dataIndex: 'limitPrice',
                    align: 'right',
                    renderer: Bullsfirst.extensions.Format.usMoney
                },
                {
                    header: 'Execution Price',
                    sortable: false,
                    menuDisabled: true,
                    flex: 2,
                    dataIndex: 'executionPrice',
                    align: 'right',
                    renderer: Bullsfirst.extensions.Format.usMoney
                },
                {
                    header: 'Status',
                    sortable: false,
                    menuDisabled: true,
                    flex: 1.5,
                    dataIndex: 'status'
                },
                {
                    xtype: 'templatecolumn',
                    sortable: false,
                    menuDisabled: true,
                    flex: 1,
                    header: 'Actions',
                    align: 'center',
                    tpl: '<a href="#">{action}</a>'
                }
            ]

        };
        return gridPanelConfig;
    }
});
