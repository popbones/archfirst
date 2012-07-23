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
 * bullsfirst/views/EditAccountDialog
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/UserContext',
        'bullsfirst/framework/ErrorUtil',
        'bullsfirst/services/AccountService'],
       function(UserContext, ErrorUtil, AccountService) {

    // Configure the dialog
    $('#edit_account_dialog').dialog({
        autoOpen: false,
        width: 250,
        modal: true,
        resizable: false,
        buttons: [
            {
                text: 'OK',
                id: 'edit_account_button'
            },
            {
                text: 'Cancel',
                click: function() { $(this).dialog('close'); }
            }],

        open: function(event, ui) {
            $('#editAccountForm').validationEngine();
        },

        close: function(event, ui) {
            $('#editAccountForm').validationEngine('hideAll');
        }
    });

    return Backbone.View.extend({
        // Defining el this way is required for the click event to be recognized
        el: $('#edit_account_dialog').parent(),

        events: {
            'click #edit_account_button': 'validateForm',
            'keypress #edit_account_dialog': 'checkEnterKey'
        },

        open: function(model) {
            this.model = model;

            // Initialize the name field and select the entire text
            $('#editacnt_name').val(this.model.get('name')).focus(function() { $(this).select() });

            $('#edit_account_dialog').dialog('open');
        },

        checkEnterKey: function(event) {
           if (event.keyCode == $.ui.keyCode.ENTER) {
               this.validateForm();
               return false;
           }
        },

        validateForm: function() {
            if ($('#editAccountForm').validationEngine('validate')) {
                $('#edit_account_dialog').dialog('close');

                // Change name of brokerage account
                AccountService.changeName(
                    this.model.id, $('#editacnt_name').val(), this.changeNameDone, ErrorUtil.showError);
            }
        },

        changeNameDone: function(data, textStatus, jqXHR) {
            UserContext.updateAccounts();
        }
    });
});