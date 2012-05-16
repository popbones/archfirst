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
                        text: Bullsfirst.GlobalConstants.Update
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
            bodyStyle: {
              border: 0,
              font: 20
            },
            flex: 1,
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
        var brokerageSummariesStore = Ext.data.StoreManager.lookup('BrokerageAccountSummaries');
        var chartPanelConfig = {
            xtype: 'container',
            cls: 'chartPanelCls',
            plugins: ['loadmask'],
            store: brokerageSummariesStore,
            flex: 1,
            layout: 'border',
            items: [
                 {
                     xtype: 'container',
                     html: 'All Accounts',
                     cls: 'chartTitleCls',
                     region: 'north',
                     height: 60
                 },
                 {
                     xtype: 'chart',
                     region: 'center',
                     animate: false,
                     store: brokerageSummariesStore,
                     theme: 'Base:gradients',
                     legend: {
                         position: 'right',
                         autoScroll: true
                     },
                     series: [{
                         type: 'pie',
                         angleField: 'cashPosition',
                         showInLegend: true,
                         tips: {
                             trackMouse: true,
                             width: 140,
                             height: 28,
                             renderer: function (storeItem, item) {
                                 // calculate and display percentage on hover
                                 var total = 0;
                                 brokerageSummariesStore.each(function (rec) {
                                     total += rec.get('cashPosition');
                                 });
                                 this.setTitle(storeItem.get('name') + ': ' + (storeItem.get('cashPosition') / total * 100) + '%');
                             }
                         }
                     }]

                 }

             ]

        };
        return chartPanelConfig;
    }
});
