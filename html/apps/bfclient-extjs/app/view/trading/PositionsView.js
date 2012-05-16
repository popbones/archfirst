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
* app/view/trading/PositionsView
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.trading.PositionsView', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.positionsview',

    //Configs


    //Functions
    initComponent: function initPositionsViewComponents() {
        var viewConfig = {
            margin: '0 20 0 20',
            layout: {
                type: 'hbox',
                align: 'stretch'
            }
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
                    left: 2
                },
                items: [
                    {
                        xtype: 'button',
                        text: Bullsfirst.GlobalConstants.Update
                    },
                    {
                        xtype: 'tbfill'
                    },
                    {
                        xtype: 'combo',
                        margin: '0 5 0 0',
                        plugins: ['loadmask'],
                        store: 'BrokerageAccountSummaries',
                        editable: false,
                        displayField: 'fullname',
                        queryMode: 'local',
                        valueField: 'id',
                        width: 300
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
            xtype: 'treepanel',
            bodyStyle: {
                border: 0
            },
            plugins: ['loadmask'],
            store: 'PositionsTree',
            rootVisible: false,
            singleExpand: false,
            flex: 1,
            columns: [
                {
                    header: 'Name',
                    xtype: 'treecolumn',
                    sortable: false,
                    menuDisabled: true,
                    flex: 3,
                    dataIndex: 'instrumentName',
                    renderer: function (value, metadata, record) {
                        if (record.get('leaf') == true) {
                            var lotCreationDate = record.get('lotCreationTime');
                            if (Ext.isEmpty(lotCreationDate)) {
                                return record.get('instrumentName');
                            }
                            this.align = 'left';
                            return Bullsfirst.GlobalFunctions.formatDate(lotCreationDate);
                        }
                        else {
                            return record.get('instrumentName');
                        }
                    }
                },
                {
                    header: 'Symbol',
                    sortable: false,
                    menuDisabled: true,
                    flex: 1,
                    dataIndex: 'instrumentSymbol'
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
                    header: 'Last Trade',
                    sortable: false,
                    menuDisabled: true,
                    dataIndex: 'lastTrade',
                    flex: 1.5,
                    align: 'right',
                    renderer: Bullsfirst.extensions.Format.usMoney
                },
                {
                    header: 'Market Value',
                    sortable: false,
                    menuDisabled: true,
                    dataIndex: 'marketValue',
                    flex: 1.5,
                    align: 'right',
                    renderer: Bullsfirst.extensions.Format.usMoney
                },
                {
                    header: 'Price Paid',
                    sortable: false,
                    menuDisabled: true,
                    dataIndex: 'pricePaid',
                    flex: 1.5,
                    align: 'right',
                    renderer: Bullsfirst.extensions.Format.usMoney
                },
                {
                    header: 'Total Cost',
                    sortable: false,
                    menuDisabled: true,
                    dataIndex: 'totalCost',
                    flex: 1.5,
                    align: 'right',
                    renderer: Bullsfirst.extensions.Format.usMoney
                },
                {
                    header: 'Gain',
                    sortable: false,
                    menuDisabled: true,
                    dataIndex: 'gain',
                    flex: 1.5,
                    align: 'right',
                    renderer: Bullsfirst.extensions.Format.usMoney
                },
                {
                    header: 'Gain %',
                    sortable: false,
                    menuDisabled: true,
                    dataIndex: 'gainPercent',
                    align: 'right',
                    flex: 1.5,
                    renderer: function (value) {
                        return Ext.util.Format.number(value * 100, '0.00%');
                    }
                },
                {
                    xtype: 'templatecolumn',
                    cls: 'templateColumnCls',
                    sortable: false,
                    align: 'center',
                    menuDisabled: true,
                    header: '',
                    flex: 0.1,
                    tpl: '{buyAction}'
                },
                {
                    xtype: 'templatecolumn',
                    cls: 'templateColumnCls',
                    sortable: false,
                    align: 'center',
                    menuDisabled: true,
                    header: '',
                    flex: 0.1,
                    tpl: '{sellAction}'
                }
            ]

        };
        return gridPanelConfig;
    }
});
