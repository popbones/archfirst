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
* app/view/trading/AccountsView
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.trading.AccountsView', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.accountsview',

    //Configs

    //Functions
    initComponent: function initAccountsViewComponents() {
        var viewConfig = {
            layout: {
                type: 'hbox',
                align: 'stretch'
            },
            margin: '0 20 0 20'
        };
        this.buildConfig(viewConfig);
        Ext.apply(this, Ext.apply(this.initialConfig, viewConfig));
        this.callParent();
    },
    buildConfig: function buildAccountsViewConfig(viewConfig) {
        this.buildItems(viewConfig);
        this.buildToolbars(viewConfig);
        this.buildButtons(viewConfig);
    },
    buildItems: function buildAccountsViewItems(viewConfig) {
        viewConfig.items = [
            this.buildGridPanelConfig(),
            this.buildChartPanelConfig()
        ];
    },
    buildToolbars: function buildAccountsViewToolbars(viewConfig) {
        viewConfig.dockedItems = [
            {
                xtype: 'toolbar',
                dock: 'top',
                ui: 'footer',
                margin: '5 0 5 0',
                defaults: {
                    minHeight: 20,
                    margin: '5 0 5 0'
                },
                padding: {
                    left: 2
                },
                items: [
                    {
                        text: Bullsfirst.GlobalConstants.Update,
                        itemId: 'UpdateAccountBtn'
                    },
                    {
                        xtype: 'tbspacer'
                    },
                    {
                        itemId: 'AddAccountBtn',
                        text: Bullsfirst.GlobalConstants.AddAccount,
                        margin: '5 0 5 5'
                    },
                    {
                        xtype: 'tbfill'
                    }

                ]

            }

        ];
    },
    buildButtons: function buildAccountsViewButtons(viewConfig) {
        viewConfig.buttons = undefined;
    },
    buildGridPanelConfig: function buildGridPanelConfig() {
        var gridPanelConfig = {
            xtype: 'grid',
            style: {
                font: 20
            },
            margin: '0 4 0 0',
            bodyStyle: {
                border: 0,
                font: 20
            },
            flex: 60,
            plugins: ['loadmask'],
            store: 'BrokerageAccountSummaries',
            columns: [
                {
                    xtype: 'templatecolumn',
                    text: 'Name',
                    flex: 3,
                    tpl: '<a href="#">{name}</a>',
                    dataIndex: 'name'

                },
                {
                    text: 'Account #',
                    dataIndex: 'id',
                    flex: 1.5,
                    align: 'right'
                },
                {
                    text: 'Market Value',
                    dataIndex: 'marketValue',
                    flex: 2,
                    align: 'right',
                    renderer: Ext.util.Format.usMoney
                },
                {
                    text: 'Cash',
                    dataIndex: 'cashPosition',
                    flex: 1.5,
                    align: 'right',
                    renderer: Ext.util.Format.usMoney
                },
                {
                    xtype: 'templatecolumn',
                    text: 'Actions',
                    flex: 1,
                    align: 'center',
                    tpl: '<a href="#">Edit</a>'

                }
            ]

        };
        return gridPanelConfig;
    },
    buildChartPanelConfig: function buildChartPanelConfig() {
        var maxRecords = Bullsfirst.GlobalConstants.PieMaxRecords;
        var brokerageSummariesStore = Ext.data.StoreManager.lookup('BrokerageAccountSummaries');
        var brokerageSummariesChartStore = Ext.data.StoreManager.lookup('BrokerageAccountChartSummaries');
        var chartPanelConfig = {
            xtype: 'container',
            cls: 'chartPanelCls',
            plugins: ['loadmask'],
            store: brokerageSummariesStore,
            flex: 39.0625,
            maxWidth: 370,
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            items: [
                {
                    xtype: 'container',
                    html: Bullsfirst.GlobalConstants.PieAllAccountsLabel,
                    region: 'north',
                    cls: 'chartTitleCls',
                    flex: 5,
                    maxHeight: 20
                },
                {
                    xtype: 'chart',
                    gradients: Bullsfirst.extensions.SmartChartTheme.createColorGradients(),
                    flex: 60,
                    minHeight: 215,
                    style: { cursor: 'pointer' },
                    shadow: false,
                    animate: false,
                    store: brokerageSummariesChartStore,
                    theme: 'SmartChartTheme',
                    series: [{
                        type: 'pie',
                        angleField: 'marketValue',
                        showInLegend: false,
                        style: {
                           border: '1'
                        },
                        listeners: {
                            itemmousedown: function (pieslice) {
                                var chart = pieslice.series.chart;
                                chart.fireEvent('piesliceclick', pieslice);
                            }
                        },
                        tips: {
                            trackMouse: true,
                            width: 140,
                            height: 50,
                            renderer: function (storeItem, item) {
                                // calculate and display percentage on hover
                                var total = 0;
                                var marketValue = storeItem.get('marketValue');
                                brokerageSummariesChartStore.each(function (rec) {
                                    total += rec.get('marketValue');
                                });
                                var name = storeItem.get('name');
                                if (Ext.isEmpty(name)) {
                                    name = storeItem.get('instrumentSymbol');
                                }
                                
                                this.setTitle(name + ': </br>' +
                                    Ext.util.Format.usMoney(marketValue) + '</br>' +
                                    (marketValue / total * 100).toFixed(2) + '%');
                            }
                        }
                    }]

                },
                {
                    xtype: 'container',
                    margin: '1 10 1 25',
                    region: 'south',
                    autoScroll: true,
                    layout: 'column',
                    flex: 35,
                    defaults: {
                        xtype: 'draw',
                        viewBox: false,
                        columnWidth: 0.5
                    }
                }
            ]

        };
        return chartPanelConfig;
    }

});
