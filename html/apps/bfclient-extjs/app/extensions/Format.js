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
* app/extensions/Format
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.extensions.Format', {
    singleton: true,
    usMoney: function (value) {
        var formattedValue = Ext.util.Format.usMoney(value);
        if (formattedValue === '$' || formattedValue === '$0.00') {
            return ' ';
        }
        return formattedValue;
    },
    quantity: function (value) {
        if (value === 0) {
            return ' ';
        }
        return value;
    }
});

 
	
