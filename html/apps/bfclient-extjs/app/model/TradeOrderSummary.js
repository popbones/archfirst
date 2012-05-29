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
* app/model/TradeOrderSummary
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.model.TradeOrderSummary', {
    extend: 'Ext.data.Model',

    fields: [
		{
		    name: 'id',
		    type: 'object'
		},
        {
            name: 'creationTime',
            type: 'string'
        },
        {
            name: 'side',
            type: 'string'
        },
        {
            name: 'symbol',
            type: 'string'
        },
        {
            name: 'quantity',
            type: 'int'
        },
        {
            name: 'cumQty',
            type: 'int'
        },
        {
            name: 'type',
            type: 'string'
        },
        {
            name: 'term',
            type: 'string'
        },
        {
            name: 'allOrNone',
            type: 'bool'
        },
        {
            name: 'status',
            type: 'string'
        },
        {
            name: 'action',
            convert: function (value, record) {
                if (record !== null && record.get('status') === 'New') {
                    return 'Cancel';
                } else {
                    return ' ';
                }
            }
        },
        {
            name: 'limitPrice',
            convert: function (value, record) {
                if (Ext.isObject(value)) {
                    return value.amount;
                } else {
                    return value;
                }

            }
        },
        {
            name: 'executions',
            type: 'array'
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
                var childNodes = record.get('executions');
                if (childNodes === null || childNodes.length === 0) {
                    return true;
                }
                return false;
            }
        },
        {
            name: 'price',
            type: 'object'
        },
        {
            name: 'executionPrice',
            convert: function (value, record) {
                var i = 0;
                var price = record.get('price');
                if (price !== null && price.amount !== null) {
                    return price.amount;
                }
                var executions = record.get('executions');
                if (Ext.isArray(executions)) {
                    var totalPrice = 0;
                    for (; i < executions.length; i++) {
                        if (executions[i].price !== null && executions[i].price.amount !== null) {
                            totalPrice += executions[i].price.amount;
                        }
                    }
                    return totalPrice;
                }

            }
        }
    ]



});

 
	
