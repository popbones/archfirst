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
* app/model/BrokerageAccountSummary
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.model.BrokerageAccountSummary', {
    extend: 'Ext.data.Model',

    fields: [
        {
            name: 'cashPosition',
            convert: function (value, record) {
                return value.amount;
            }
        },
        {
            name: 'marketValue',
            convert: function (value, record) {
                return value.amount;
            }
        },
        {
            name: 'editPermission',
            type: 'bool'
        },
        {
            name: 'tradePermission',
            type: 'bool'
        },
        {
            name: 'transferPermission',
            type: 'bool'
        },
        {
            name: 'name',
            type: 'string'
        },
        {
            name: 'id',
            type: 'int'
        },
        {
            name: 'fullname',
            convert: function (value, record) {
                return record.get('name') + ' - '
                    + record.get('id') + ' - '
                    + Ext.util.Format.usMoney(record.get('cashPosition'));
            }
        }
    ],

    associations: [
        {
            type: 'hasMany',
            model: 'Bullsfirst.model.Position',
            name: 'positions'
        }

    ],

    proxy: {
        type: 'smartrest',
        url: Bullsfirst.GlobalConstants.BaseUrl + '/bfoms-javaee/rest/secure/brokerage_accounts'
    }
});

 
	
