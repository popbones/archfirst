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
* app/view/trading/TradingTabPanel
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.trading.TradingTabPanel', {
    extend: 'Ext.tab.Panel',
    alias: 'widget.tradingtabpanel',

    //Configs
    plain: true,
    loggedInUser: null,
    selectedBrokerageAccount: null,

    //Functions
    initComponent: function initTradingTabPanelComponents() {
        var viewConfig = {
            plane: true,
            margin: '5 0 0 0'
        };
        this.buildConfig(viewConfig);
        Ext.apply(this, Ext.apply(this.initialConfig, viewConfig));
        this.callParent();
        this.addTabBar();
    },
    buildConfig: function buildTradingTabPanelConfig(viewConfig) {
        this.buildItems(viewConfig);
        this.buildToolbars(viewConfig);
        this.buildButtons(viewConfig);
    },
    buildItems: function buildTradingTabPanelItems(viewConfig) {
        viewConfig.items = [
            this.addTab('Accounts', 'accountsview'),
            this.addTab('Positions', 'positionsview'),
            this.addTab('Trade', 'tradeview'),
            this.addTab('Orders', 'ordersview'),
            this.addTab('Transaction History', 'transactionsview'),
            this.addTab('Transfer', 'transferview')
        ];
    },
    buildToolbars: function buildTradingTabPanelToolbars(viewConfig) {
        viewConfig.dockedItems = undefined;

    },
    addTabBar: function addTabBar() {
        var tabBar = this.tabBar;
        tabBar.add(
            {
                xtype: 'container',
                style: {
                    border: 0,
                    background: 'transparent'
                },
                flex: 2,
                minHeight: 21,
                layout: {
                    type: 'hbox',
                    align: 'stretch'
                },
                defaults: {
                    margin: '3 5 0 0'
                },
                items: [
                    {
                        xtype: 'container',
                        flex: 1
                    },
                    {
                        xtype: 'container',
                        flex: 1.5,
                        items: [
                            {
                                xtype: 'component',
                                itemId: 'gettingStartedLink',
                                autoEl: { tag: 'a', href: Bullsfirst.GlobalConstants.BaseUrl + '/books/getting-started', target: 'new', html: Bullsfirst.GlobalConstants.GettingStarted },
                                flex: 1
                            }
                        ]
                    },
                    {
                        xtype: 'container',
                        flex: 1,
                        maxWidth: 130,
                        items: [
                           {
                               xtype: 'label',
                               itemId: 'userName',
                               text: '',
                               margin: '4 5 0 0',
                               flex: 1
                           },
                           {
                               xtype: 'label',
                               text: '|',
                               flex: 0.1
                           },
                           {
                               xtype: 'component',
                               itemId: 'signOutLink',
                               margin: '4 0 0 5',
                               autoEl: { tag: 'a', href: '#', html: Bullsfirst.GlobalConstants.SignOut },
                               flex: 1
                           }
                        ]
                    }
                ]
            }
       );
    },
    buildButtons: function buildTradingTabPanelButtons(viewConfig) {
        viewConfig.buttons = undefined;
    },
    addTab: function addTab(tabTitle, tabXType) {
        return {
             title: tabTitle,
             layout: 'border',
             items: [
                {
                    xtype: 'container',
                    html: tabTitle,
                    height: 30,
                    cls: 'tabTitleCls',
                    region: 'north'
                },
                {
                    xtype: tabXType,
                    region: 'center'
                }
            ]
        };
    }
});
