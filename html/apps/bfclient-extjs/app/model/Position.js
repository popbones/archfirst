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
* app/model/Position
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.model.Position', {
    extend: 'Ext.data.Model',

    fields: [
        {
            name: 'accountName',
            type: 'string'
        },
        {
            name: 'accountId',
            type: 'int'
        },
		{
		    name: 'instrumentName',
		    type: 'string'
		},
        {
            name: 'instrumentSymbol',
            type: 'string'
        },
        {
            name: 'quantity',
            type: 'int'
        },
        {
            name: 'lastTrade',
            convert: function convertToAmount(value) {
                if (Ext.isObject(value) && value.amount != undefined) {
                    return value.amount;
                }
                return value;
            }
        },
        {
            name: 'marketValue',
            convert: function convertToAmount(value, record) {
                if (Ext.isObject(value) && value.amount != undefined) {
                    return value.amount;
                }
                return value;
            }
        },
        {
            name: 'pricePaid',
            convert: function convertToAmount(value) {
                if (Ext.isObject(value) && value.amount != undefined) {
                    return value.amount;
                }
                return value;
            }
        },
        {
            name: 'totalCost',
            convert: function convertToAmount(value) {
                if (Ext.isObject(value) && value.amount != undefined) {
                    return value.amount;
                }
                return value;
            }
        },
        {
            name: 'gain',
            convert: function convertToAmount(value) {
                if (Ext.isObject(value) && value.amount != undefined) {
                    return value.amount;
                }
                return value;
            }
        },
        {
            name: 'gainPercent',
            type: 'float'
        },
        {
            name: 'lotCreationTime',
            type: 'string'
        },
        {
            name: 'iconCls',
            convert: function (value) {
                return 'no-icon';
            }
        },
        {
            name: 'leaf',
            convert: function (value, record) {
                var childNodes = record.get('children');
                if (childNodes == null || childNodes.length == 0) {
                    return true;
                }
                return false;
            }
        },
        {
            name: 'buyAction',
            convert: function (value, record) {
                if (record.get('leaf') == false) {
                    return '<a href="#">Buy</a>';
                }
                else {
                    return ' ';
                }
            }
        },
        {
            name: 'sellAction',
            convert: function (value, record) {
                if (record.get('leaf') == false) {
                    return '<a href="#">Sell</a>';
                }
                else {
                    return ' ';
                }
            }
        }
    ],
    belongsTo: 'Bullsfirst.model.BrokerageAccountSummary'
});

 
	
