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
* app/model/EditBrokerageAccount
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.model.EditBrokerageAccount', {
    extend: 'Ext.data.Model',

    fields: [
         {
             name: 'name',
             persist: false,
             convert: function (value, record) {
                  record.set('newName', value);
                  return value;
		     }
         },
		 {
		     name: 'newName',
		     type: 'string'
		 }
    ],
    idProperty: 'newName',
    proxy: {
        type: 'smartrest',
        appendId: false,
        url: Bullsfirst.GlobalConstants.BaseUrl + '/bfoms-javaee/rest/secure/accounts/{0}/change_name'
    }
});

 
	
