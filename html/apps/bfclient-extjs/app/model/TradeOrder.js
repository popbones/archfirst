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
* app/model/TradeOrder
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.model.TradeOrder', {
    extend: 'Ext.data.Model',

    fields: [
		{
		    name: 'accountName',
		    type: 'string'
		},
        {
            name: 'symbol',
            type: 'string'
        },
        {
            name: 'action',
            type: 'string'
        },
        {
            name: 'quantity',
            type: 'int'
        },
        {
            name: 'orderType',
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
            name: 'lastTrade',
            type: 'float'
        },
        {
            name: 'estimatedValue',
            type: 'float'
        },
        {
            name: 'fees',
            type: 'float'
        },
        {
            name: 'totalIncludingFees',
            type: 'float'
        },
        {
            name: 'marketPrice',
            type: 'object'
        }
    ]
});

 
	
