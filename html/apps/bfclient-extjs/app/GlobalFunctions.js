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
* app/GlobalFunctions
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.GlobalFunctions', {
    singleton: true,

    getAuthenticationHeader: function getAuthenticationHeader() {
        var loggedInUser = Ext.data.StoreManager.lookup('LoggedInUser').first();
        var token = loggedInUser.get('username') + ':' + loggedInUser.get('password');
        var hash = Base64.encode(token);
        return "Basic " + hash;
    },
    validateDate: function validateDate(fromDate, toDate) {
        if (toDate < fromDate) {
            return Bullsfirst.GlobalConstants.InvalidDateMsg;
        } else {
            return true;
        }
    },
    validateToDate: function validateToDate(value) {
        try {
            var toDateValue = Ext.Date.parse(value, 'm/d/Y');
            var fromDateValue = this.ownerCt.down('datefield[fieldLabel=From]').getValue();
            return Bullsfirst.GlobalFunctions.validateDate(fromDateValue, toDateValue);
        } catch (e) {
            return true;
        }
    },
    validateFromDate: function validateFromDate(value) {
        try {
            var fromDateValue = Ext.Date.parse(value, 'm/d/Y');
            var toDateValue = this.ownerCt.down('datefield[fieldLabel=To]').getValue();
            return Bullsfirst.GlobalFunctions.validateDate(fromDateValue, toDateValue);
        } catch (e) {
            return true;
        }
    },
    formatDate: function (dateString) {
        var dateValue = Ext.Date.parse(dateString, 'Y-m-dTH:i:s.uP');
        return Ext.Date.format(dateValue, 'm-d-Y h:i:s A');
    }

});