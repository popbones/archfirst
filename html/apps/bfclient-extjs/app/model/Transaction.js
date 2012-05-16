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
* app/model/Transaction
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.model.Transaction', {
    extend: 'Ext.data.Model',

    fields: [
         {
             name: 'accountId',
             type: 'int'
         },
         {
             name: 'accountName',
             type: 'string'
         },
         {
             name: 'transactionId',
             type: 'int'
         },
         {
             name: 'creationTime',
             type: 'string'
         },
         {
             name: 'type',
             type: 'string'
         },
         {
             name: 'description',
             type: 'string'
         },
         {
             name: 'amount',
             convert: function (value, record) {
                 return value.amount;
             }
         }

    ],
    idPropety: 'transactionId',

    proxy: {
        type: 'smartrest',
        appendId: false,
        url: Bullsfirst.GlobalConstants.BaseUrl + '/bfoms-javaee/rest/secure/transactions'
    }
});

 
	
