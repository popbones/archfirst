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
 * bullsfirst/views/AddAccountDialog
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/UserContext',
        'bullsfirst/framework/ErrorUtil',
        'bullsfirst/services/BrokerageAccountService'
        ],
        function(UserContext, ErrorUtil, BrokerageAccountService) {

    // Configure the dialog
    $('#add_account_dialog').dialog({
        autoOpen: false,
        width: 250,
        modal: true,
        resizable: false,
        buttons: [
            {
                text: 'OK',
                id: 'add_account_button'
            },
            {
                text: 'Cancel',
                click: function() { $(this).dialog('close'); }
            }],

        open: function(event, ui) {
            $('#addAccountForm').validationEngine();
        },

        close: function(event, ui) {
            $('#addAccountForm').validationEngine('hideAll');
        }
    });

    return Backbone.View.extend({
        // Defining el this way is required for the click event to be recognized
        el: $('#add_account_dialog').parent(),

        events: {
            'click #add_account_button': 'validateForm',
            'keypress #add_account_dialog': 'checkEnterKey'
        },

        checkEnterKey: function(event) {
           if (event.keyCode == $.ui.keyCode.ENTER) {
               this.validateForm();
               return false;
           }
        },

        validateForm: function() {
            if ($('#addAccountForm').validationEngine('validate')) {
                $('#add_account_dialog').dialog('close');

                // Create brokerage account
                BrokerageAccountService.createBrokerageAccount(
                    $('#addacnt_name').val(), this.createBrokerageAccountDone, ErrorUtil.showError);
            }
        },

        createBrokerageAccountDone: function(data, textStatus, jqXHR) {
            UserContext.getBrokerageAccounts().fetch();
        }
    });
});