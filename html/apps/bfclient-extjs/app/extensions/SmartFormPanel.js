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
* app/extensions/SmartFormPanel
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.extensions.SmartFormPanel', {
    extend: 'Ext.form.Panel',
    alias: 'widget.smartform',

    bodyStyle: {
        background: 'transparent'
    },

    initComponent: function () {
        this.on('afterrender', function () {
            var basicForm = this.getForm();
            var submitButton = this.down('submitbutton');
            if (basicForm != null && submitButton != null) {

                //If form's validity changes, enable or disable the submit button
                basicForm.on('validitychange', function () {
                    basicForm.hasInvalidField() ? submitButton.disable() : submitButton.enable();
                }, this);

                //Once the button is enabled, call isValid function to clear any invalidity markers
                submitButton.on('enable', function () {
                    basicForm.isValid();
                });

                //Wire up enter keypress event and simulate submit button click if the button is enabled
                basicForm.getFields().each(function (field) {
                    field.on('specialkey', function (field, e) {
                        if (e.getKey() == e.ENTER) {
                            if (!submitButton.isDisabled()) {
                                submitButton.fireEvent('click', submitButton);
                            }
                        }
                    });
                });
            }
        }, this);
        this.callParent();
    },

    resetAllFields: function () {
        var basicForm = this.getForm();
        basicForm.getFields().each(function (field) {
            field.reset();
        });
        basicForm.fireEvent('validitychange', basicForm);
    }

});

 
	
