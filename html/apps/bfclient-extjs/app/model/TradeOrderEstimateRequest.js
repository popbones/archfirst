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
* app/model/TradeOrderEstimateRequest
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.model.TradeOrderEstimateRequest', {
    extend: 'Ext.data.Model',

    fields: [
		 {
		     name: 'brokerageAccountId',
		     type: 'int'
		 },
         {
             name: 'orderParams',
             convert: function (value, record) {
                 if (Ext.isObject(value)) {
                     return {
                         side: value.get('action'),
                         symbol: value.get('symbol'),
                         quantity: value.get('quantity'),
                         type: value.get('orderType'),
                         limitPrice: {
                             amount: value.get('totalIncludingFees'),
                             currency: 'USD'
                         },
                         term: value.get('term'),
                         allOrNone: value.get('allOrNone')
                     };
                 }
             }
         }
    ],
   
    idProperty: 'brokerageAccountId',
    proxy: {
        type: 'smartrest',
        appendId: false,
        url: Bullsfirst.GlobalConstants.BaseUrl + '/bfoms-javaee/rest/secure/order_estimates'
    }
});

 
	
