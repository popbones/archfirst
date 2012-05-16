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
* app/view/accounts/LoginView
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.accounts.LoginView', {
    extend: 'Bullsfirst.extensions.SmartFormPanel',
    alias: 'widget.loginview',

    //functions
    initComponent: function () {
        var panelConfig = {
            layout: 'anchor',
            maxHeight: 140,
            defaultType: 'textfield',
            defaults: {
                enableKeyEvents: true,
                margin: '5 2 2 12',
                width: 170
            }
        };
        this.buildConfig(panelConfig);
        Ext.apply(this, Ext.apply(this.initialConfig, panelConfig));
        this.callParent();
    },
    buildConfig: function (panelConfig) {
        this.buildItems(panelConfig);
        this.buildButtons(panelConfig);
    },
    buildItems: function (panelConfig) {
        panelConfig.items = [
             {
                 xtype: 'textfield',
                 name: 'username',
                 allowBlank: false,
                 fieldLabel: 'Username',
                 //value: 'vikasgoyalgzs',
                 blankText: 'Please enter your username',
                 labelAlign: 'top'
             },
            {
                xtype: 'textfield',
                name: 'password',
                allowBlank: false,
                blankText: 'Please enter your password',
                fieldLabel: 'Password',
                //value: 'highclass',
                labelAlign: 'top',
                inputType: 'password'
            }
        ];
    },
    buildButtons: function (panelConfig) {
        this.buildFormPanelToolBars(panelConfig);
    },
    buildFormPanelToolBars: function (panelConfig) {
        panelConfig.dockedItems = [
            {
                xtype: 'toolbar',
                dock: 'bottom',
                ui: 'footer',
                margin: '0 0 0 5',
                defaults: { minWidth: 50, maxWidth: 100 },
                items: [
                    {
                        xtype: 'component',
                        itemId: 'openAccountLink',
                        autoEl: { tag: 'a', href: '#', html: Bullsfirst.GlobalConstants.OpenAccount },
                        flex: 1
                    }
                ]
            },
            {
                xtype: 'toolbar',
                dock: 'bottom',
                ui: 'footer',
                margin: '0 0 0 5',
                defaults: { minWidth: 50, maxWidth: 60 },
                items: [
                    {
                        xtype: 'submitbutton',
                        text: Bullsfirst.GlobalConstants.Login,
                        flex: 1
                    }
                ]
            }
        ];
    }
});