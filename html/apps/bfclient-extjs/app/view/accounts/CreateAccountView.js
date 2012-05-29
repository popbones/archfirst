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
* app/view/accounts/CreateAccountView
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.accounts.CreateAccountView', {
    extend: 'Ext.window.Window',
    alias: 'widget.createaccountview',

    //functions
    initComponent: function () {
        var viewConfig = {
            layout: 'fit',
            modal: true,
            resizable: false,
            width: 265,
            height: 320,
            title: 'Open an Account',
            items: [
                this.buildConfig()
            ]
        };
        this.buildCustomVType();
        Ext.apply(this, Ext.apply(this.initialConfig, viewConfig));
        this.callParent();
    },
    buildCustomVType: function () {
        Ext.apply(Ext.form.field.VTypes, {
            passwordConfirm: function (val, field) {
                var form = field.up('smartform');
                var siblingPasswordField = form.down('textfield[fieldLabel=' + field.siblingPasswordField + ']');
                if (!Ext.isEmpty(field.rawValue) && !Ext.isEmpty(siblingPasswordField.rawValue)) {
                    if (siblingPasswordField.rawValue !== field.rawValue) {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    return true;
                }
            },
            // vtype Text property: The error text to display when the validation function returns false
            passwordConfirmText: "Passwords don't match"
        });
    },
    buildConfig: function () {
        var panelConfig = {
            xtype: 'smartform',
            layout: 'anchor',
            defaultType: 'textfield',
            defaults: {
                labelAlign: 'top',
                enableKeyEvents: true,
                margin: '5 10 5 10',
                width: 230,
                allowBlank: false
            }
        };
        this.buildItems(panelConfig);
        this.buildButtons(panelConfig);
        return panelConfig;
    },
    buildItems: function (panelConfig) {
        panelConfig.items = [
            {
                name: 'firstName',
                blankText: 'Please enter your first name',
                fieldLabel: 'First Name'
            },
            {
                name: 'lastName',
                blankText: 'Please enter your last name',
                fieldLabel: 'Last Name'
            },
            {
                name: 'username',
                blankText: 'Please enter your username',
                fieldLabel: 'Username'
            },
            {
                name: 'password',
                blankText: 'Please enter your password',
                fieldLabel: 'Password',
                vtype: 'passwordConfirm',
                siblingPasswordField: 'Confirm Password',
                inputType: 'password'
            },
            {
                fieldLabel: 'Confirm Password',
                blankText: 'Please confirm your password',
                siblingPasswordField: 'Password',
                vtype: 'passwordConfirm',
                inputType: 'password'
            }
        ];
    },
    buildButtons: function (panelConfig) {
        this.buildFormPanelButtons(panelConfig);
    },
    buildFormPanelButtons: function (panelConfig) {
        panelConfig.dockedItems = [
            {
                xtype: 'toolbar',
                dock: 'bottom',
                ui: 'footer',
                height: 40,
                items: [
                    {
                        xtype: 'tbfill'
                    },
                    {
                        xtype: 'submitbutton',
                        text: Bullsfirst.GlobalConstants.OpenAccountButton,
                        action: 'openAccount',
                        width: 100
                    },
                    {
                        text: Bullsfirst.GlobalConstants.Cancel,
                        action: 'cancel',
                        width: 80
                    }
                ]
            }
        ];

    }
});
