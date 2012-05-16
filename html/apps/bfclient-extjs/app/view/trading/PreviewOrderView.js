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
* app/view/trading/PreviewOrderView
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.trading.PreviewOrderView', {
    extend: 'Ext.window.Window',
    alias: 'widget.previeworderview',
    requires: ['Ext.window.MessageBox'],

    //Configs
    title: Bullsfirst.GlobalConstants.PreviewOrder,
    width: 600,
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
                layout: 'column',
                items: [
                    {
                        xtype: 'fieldset',
                        title: 'Order Summary',
                        margin: '10 30 10 15',
                        columnWidth: 0.55,
                        collapsible: false,
                        defaultType: 'displayfield',
                        defaults: { anchor: '100%', labelWidth: 100 },
                        layout: 'anchor',
                        items: [
                            {
                                fieldLabel: 'Account',
                                name: 'accountName',
                                renderer: function (value) {
                                    var brokerageAccountsStore = Ext.data.StoreManager.lookup('BrokerageAccountSummaries');
                                    return brokerageAccountsStore.findRecord('id', value).get('name');
                                }
                            },
                            {
                                fieldLabel: 'Symbol',
                                name: 'symbol'
                            },
                            {
                                fieldLabel: 'Action',
                                name: 'action'
                            },
                            {
                                fieldLabel: 'Quantity',
                                name: 'quantity'
                            },
                            {
                                fieldLabel: 'OrderType',
                                name: 'orderType'
                            },
                            {
                                fieldLabel: 'Term',
                                name: 'term'
                            },
                            {
                                fieldLabel: 'All-or-none',
                                name: 'allOrNone'
                            }
                        ]
                    },
                    {
                        xtype: 'fieldset',
                        margin: '10 20 10 0',
                        title: 'Estimate',
                        columnWidth: 0.45,
                        collapsible: false,
                        defaultType: 'displayfield',
                        defaults: { anchor: '100%', cls: 'numericFieldsCls', labelWidth: 120 },
                        layout: 'anchor',
                        items: [
                            {
                                fieldLabel: 'Last Trade',
                                name: 'lastTrade',
                                renderer: Ext.util.Format.usMoney
                            },
                            {
                                fieldLabel: 'Estimated Value',
                                name: 'estimatedValue',
                                renderer: Ext.util.Format.usMoney
                            },
                            {
                                fieldLabel: 'Fees',
                                name: 'fees',
                                renderer: Ext.util.Format.usMoney
                            },
                            {
                                fieldLabel: 'Total Including Fees',
                                name: 'totalIncludingFees',
                                renderer: Ext.util.Format.usMoney
                            }
                        ]
                    }
               ],
                buttons: [
                    {
                        text: 'Edit Order',
                        itemId: 'EditOrderBtn'
                    },
                    {
                        text: 'Place Order',
                        itemId: 'PlaceOrderBtn'
                    }
               ]
            }

        ];

        this.callParent();
    }
});