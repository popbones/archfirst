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
* app/view/Viewport
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.Viewport', {
    extend: 'Ext.container.Viewport',

    layout: {
        type: 'hbox',
        align: 'stretch'
    },
    autoScroll: true,
    cls: 'viewportCls',
    loadMask: new Ext.LoadMask(this, { msg: Bullsfirst.GlobalConstants.LoadingMessage }),

    //Functions
    initComponent: function initAccountsViewComponents() {
        var viewConfig = {};
        this.buildConfig(viewConfig);
        Ext.apply(this, Ext.apply(this.initialConfig, viewConfig));
        this.callParent();
    },
    buildConfig: function buildViewportConfig(viewConfig) {
        this.buildItems(viewConfig);
    },
    buildItems: function buildItems(viewConfig) {
        viewConfig.items = [
            this.buildLeftColumnConfig(),
            this.buildCenterColumnConfig(),
            this.buildRightColumnConfig()
        ];
    },
    buildLeftColumnConfig: function buildLeftColumnConfig() {
        var leftColumnConfig = {
            xtype: 'container',
            cls: 'mainLayoutStyle',
            flex: 1
        };
        return leftColumnConfig;
    },
    buildRightColumnConfig: function buildRightColumnConfig() {
        var rightColumnConfig = {
            xtype: 'container',
            cls: 'mainLayoutStyle',
            flex: 1
        };
        return rightColumnConfig;
    },
    buildCenterColumnConfig: function buildCenterColumnConfig() {
        var centerColumnConfig = {
            xtype: 'panel',
            cls: 'centerPanelCls',
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            width: 960
        };
        this.buildCenterColumnItems(centerColumnConfig);
        this.buildCenterColumnFooter(centerColumnConfig);
        return centerColumnConfig;
    },
    buildCenterColumnItems: function buildCenterColumnItems(centerColumnConfig) {
        centerColumnConfig.items = [
            {
                xtype: 'panel',
                height: 120,
                bodyStyle: {
                    background: '#B30000'
                },
                layout: 'border',
                defaults: {
                    margin: '0 0 4 0'
                },
                items: [
                    {
                        region: 'west',
                        width: 230,
                        layout: 'fit',
                        items: [
                            {
                                xtype: 'image',
                                margin: '25 0 25 0',
                                src: 'resources/bullsfirst/images/logo.jpg'
                            }
                        ]
                    },
                    {
                        region: 'center'
                    },
                    {
                        region: 'east',
                        width: 420,
                        layout: 'fit',
                        items: [
                            {
                                xtype: 'image',
                                margin: '26 0 0 0',
                                src: 'resources/bullsfirst/images/slogan.jpg'
                            }
                        ]
                    }
                            
                ]

            },
            {
                xtype: 'mainContentPanel',
                margin: '5 0 0 0',
                itemId: 'mainContentRegion',
                flex: 1
            }
        ];
    },
    buildCenterColumnFooter: function buildCenterColumnFooter(centerColumnConfig) {
        centerColumnConfig.dockedItems = [
            {
                xtype: 'toolbar',
                ui: 'logotoolbar',
                dock: 'bottom',
                padding: '5 0 0 0',
                style: {
                    border: 0
                },
                height: 23,
                items: [
                    {
                        xtype: 'tbfill'
                    },
                    {
                        xtype: 'displayfield',
                        fieldBodyCls: 'footerCls',
                        value: Bullsfirst.GlobalConstants.CopyrightMessage
                    },
                    {
                        xtype: 'tbfill'
                    }
                ]
            }

        ];
    }
});
