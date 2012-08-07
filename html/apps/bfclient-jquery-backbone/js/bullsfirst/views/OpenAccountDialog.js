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
 * bullsfirst/views/OpenAccountDialog
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/Credentials',
        'bullsfirst/domain/ExternalAccount',
        'bullsfirst/domain/ExternalAccounts',
        'bullsfirst/domain/User',
        'bullsfirst/domain/UserContext',
        'bullsfirst/framework/ErrorUtil',
        'bullsfirst/framework/MessageBus',
        'bullsfirst/services/AccountService',
        'bullsfirst/services/BrokerageAccountService',
        'bullsfirst/services/UserService'],
       function(Credentials, ExternalAccount, ExternalAccounts, User, UserContext, ErrorUtil, MessageBus, AccountService, BrokerageAccountService, UserService) {

    // Configure the dialog
    $('#open_account_dialog').dialog({
        autoOpen: false,
        width: 250,
        modal: true,
        resizable: false,
        buttons: [
            {
                text: 'Open Account',
                id: 'open_account_button'
            },
            {
                text: 'Cancel',
                click: function() { $(this).dialog('close'); }
            }],

        open: function(event, ui) {
            $('#openAccountForm').validationEngine();
        },

        close: function(event, ui) {
            $('#openAccountForm').validationEngine('hideAll');
        }
    });

    return Backbone.View.extend({
        brokerageAccountId: 0,
        externalAccountId : 0,

        // Defining el this way is required for the click event to be recognized
        el: $('#open_account_dialog').parent(),

        events: {
            'click #open_account_button': 'validateForm',
            'keypress #open_account_dialog': 'checkEnterKey'
        },

        open: function() {
            $('#open_account_dialog').dialog('open');
        },

        checkEnterKey: function(event) {
           if (event.keyCode == $.ui.keyCode.ENTER) {
               this.validateForm();
               return false;
           }
        },

        validateForm: function() {
            if ($('#openAccountForm').validationEngine('validate')) {
                $('#open_account_dialog').dialog('close');
                this.createUser();
            }
        },

        createUser: function() {
            UserService.createUser(
                this.form2CreateUserRequest(), _.bind(this.createUserDone, this), ErrorUtil.showError);
        },

        createUserDone: function(data, textStatus, jqXHR) {
            // Add user to UserContext
            UserContext.initUser(this.form2User());
            UserContext.initCredentials(this.form2Credentials());

            // Create brokerage account
            BrokerageAccountService.createBrokerageAccount(
                'Brokerage Account 1', _.bind(this.createBrokerageAccountDone, this), ErrorUtil.showError);
        },

        createBrokerageAccountDone: function(data, textStatus, jqXHR) {
            this.brokerageAccountId = data.id;

            // Create external account
            var externalAccount = new ExternalAccount({
                name: 'External Account 1', routingNumber: '022000248', accountNumber: '12345678'
            });
            UserContext.getExternalAccounts().add(externalAccount);
            externalAccount.save(null, {
                success: _.bind(this.createExternalAccountDone, this),
                error: ErrorUtil.showBackboneError
            });
        },

        // Note that Backbone sends different parameters to callbacks
        createExternalAccountDone: function(model, jqXHR) {
            this.externalAccountId = model.id;

            // Transfer cash
            AccountService.transferCash(
                this.externalAccountId,
                { amount: {amount: 100000, currency: 'USD'}, toAccountId: this.brokerageAccountId },
                _.bind(this.transferCashDone, this),
                ErrorUtil.showError);
        },

        transferCashDone: function(data, textStatus, jqXHR) {
            // TODO: Erase the form
            MessageBus.trigger('UserLoggedInEvent');
        },

        // ------------------------------------------------------------
        // Helper functions
        // ------------------------------------------------------------
        // Creates a CreateUserRequest from the Open Account form
        form2CreateUserRequest: function() {
            var formObject = $('#openAccountForm').toObject();
            delete formObject.confirmPassword; // property not expected by REST service
            return formObject;
        },

        // Creates a User from the Open Account form
        form2User: function() {
            var formObject = $('#openAccountForm').toObject();
            delete formObject.Password;
            delete formObject.confirmPassword;
            return formObject;
        },

        // Creates Credentials from the Open Account form
        form2Credentials: function() {
            return new Credentials(
                $('#oa_username').val(),
                $('#oa_password').val());
        }
    });
});