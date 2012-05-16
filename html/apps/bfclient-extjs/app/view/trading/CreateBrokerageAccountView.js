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
* app/view/trading/CreateBrokerageAccountView
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.trading.CreateBrokerageAccountView', {
    extend: 'Ext.window.Window',
    alias: 'widget.createBrokerageAccountView',
    requires: ['Ext.window.MessageBox'],

    //Configs
    title: Bullsfirst.GlobalConstants.CreateBrokerageAccount,
    width: 300,
    modal: true,
    autoHeight: true,
    closable: true,
    resizable: false,
    autoShow: false,

    //Compound configs
    layout: {
        type: 'fit'
    },

    //functions
    initComponent: function () {
        this.items = [
            {
               xtype: 'smartform',
               items: [
                  {
                    xtype: 'textfield',
                    name: 'accountName', 
                    margin: '5',
                    width: 250,
                    allowBlank: false,
                    fieldLabel: 'Account Name',
                    labelAlign: 'top'
                  }
               ],
               buttons: [
                    {
                        text: 'OK',
                        minWidth: 70,
                        xtype: 'submitbutton',
                        itemId: 'OkBtn'
                    },
                    {
                        text: 'Cancel',
                        itemId: 'CancelBtn'
                    }
               ]
            }
            
        ];
        
        this.callParent();
    }
});