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
* app/view/shared/CreateAccountView
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.shared.MainContentPanel', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.mainContentPanel',

    //Configs
    flex: 1,
    layout: {
        type: 'hbox',
        align: 'stretch'
    },
            
    //Functions
    initComponent: function initLogInMainPanelComponents() {
        var viewConfig = {};
        this.buildConfig(viewConfig);
        Ext.apply(this, Ext.apply(this.initialConfig, viewConfig));
        this.callParent();
    },
    buildConfig: function buildLogInMainPanelConfig(viewConfig) {
        this.buildItems(viewConfig);
    },
    buildItems: function buildItems(viewConfig) {
        viewConfig.items = [
            {
                width: 650,
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                items: [
                    {
                        xtype: 'image',
                        margin: '20 60 20 60',
                        maxHeight: 200,
                        flex: 1,
                        src: 'resources/bullsfirst/images/homeGraphic.png'
                    },
                    {
                        flex: 1,
                        bodyCls: 'tradeMessageCls',
                        height: 210,
                        maxWidth: 607,
                        margin: '5 0 0 10',
                        html: Bullsfirst.GlobalConstants.TradeMessage
                   }
                ]
            },
            {
                xtype: 'loginview',
                margin: '0 0 0 40',
                maxHeight: 165,
                maxWidth: 195,
                flex:1
            }
        ];
    }
});
