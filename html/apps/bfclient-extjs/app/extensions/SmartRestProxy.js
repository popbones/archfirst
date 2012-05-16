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
* app/extensions/SmartRestProxy
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.extensions.SmartRestProxy', {
    extend: 'Ext.data.proxy.Rest',
    alias: 'proxy.smartrest',

    setException: function (operation, response) {
        operation.response = response;
        operation.setException({
            status: response.status,
            statusText: response.statusText
        });
    },                                                   /// <reference path="SmartRestProxy.js" />


    //build custom url using querystrings
    buildUrl: function (request) {
        var urlQueryString = '?';
        var queryParams = this.queryParams;
        for (var queryItem in queryParams) {
            if (!Ext.isEmpty(queryParams[queryItem])) {
                if (urlQueryString.indexOf('=') > 1) {
                    urlQueryString += '&';
                }
                urlQueryString += (queryItem + '=' + queryParams[queryItem]);
            }
        }
        if (urlQueryString != '?') {
            request.url = this.url + urlQueryString;
        }
        if (this.url.indexOf('/secure/') > 0) {
            this.headers = {
                Authorization: Bullsfirst.GlobalFunctions.getAuthenticationHeader()
            };
        }
        
        return this.callParent(arguments)
    }

});

 
	
