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
 * bullsfirst/views/AddExternalAccountDialog
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/ExternalAccount',
        'bullsfirst/domain/UserContext',
        'bullsfirst/framework/ErrorUtil'],
       function(ExternalAccount, UserContext, ErrorUtil) {

    // Configure the dialog
    $('#add_external_account_dialog').dialog({
        autoOpen: false,
        width: 250,
        modal: true,
        resizable: false,
        buttons: [
            {
                text: 'OK',
                id: 'add_external_account_button'
            },
            {
                text: 'Cancel',
                click: function() { $(this).dialog('close'); }
            }],

        open: function(event, ui) {
            $('#addExternalAccountForm').validationEngine();
        },

        close: function(event, ui) {
            $('#addExternalAccountForm').validationEngine('hideAll');
        }
    });

    return Backbone.View.extend({
        // Defining el this way is required for the click event to be recognized
        el: $('#add_external_account_dialog').parent(),

        events: {
            'click #add_external_account_button': 'validateForm',
            'keypress #add_account_dialog': 'checkEnterKey'
        },

        open: function() {
            $('#add_external_account_dialog').dialog('open');
        },

        checkEnterKey: function(event) {
           if (event.keyCode == $.ui.keyCode.ENTER) {
               this.validateForm();
               return false;
           }
        },

        validateForm: function() {
            if ($('#addExternalAccountForm').validationEngine('validate')) {
                $('#add_external_account_dialog').dialog('close');

                // Create external account
                var externalAccount = new ExternalAccount($('#addExternalAccountForm').toObject());
                UserContext.getExternalAccounts().add(externalAccount);
                externalAccount.save(null, {
                    success: this.createExternalAccountDone,
                    error: ErrorUtil.showBackboneError
                });
            }
        },

        createExternalAccountDone: function(data, textStatus, jqXHR) {
            UserContext.updateAccounts();
        }
    });
});