﻿/**
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
 * bullsfirst/views/HomePage
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/Credentials',
        'bullsfirst/domain/User',
        'bullsfirst/domain/UserContext',
        'bullsfirst/framework/ErrorUtil',
        'bullsfirst/framework/MessageBus',
        'bullsfirst/framework/Page',
        'bullsfirst/services/UserService'
        ],
        function(Credentials, User, UserContext, ErrorUtil, MessageBus, Page, UserService) {
    return Page.extend({
        el: '#home_page',

        events: {
            'submit #loginForm': 'loginFormSubmit',
            'click #l_open_account': 'showOpenAccountDialog'
        },

        initialize: function() {
            $("#loginForm").validationEngine();
        },

        loginFormSubmit: function() {
            if ($('#loginForm').validationEngine('validate')) {
                UserService.getUser(
                    this.form2Credentials(), _.bind(this.loginDone, this), ErrorUtil.showError);
            }
            return false;
        },

        loginDone: function(data, textStatus, jqXHR) {
            // Add user to UserContext
            UserContext.initUser(data);
            UserContext.initCredentials(this.form2Credentials());

            $('#l_password')[0].value = ''; // erase password from form
            MessageBus.trigger('UserLoggedInEvent');
        },

        showOpenAccountDialog: function() {
            $('#open_account_dialog').dialog('open');
            return false;
        },

        // ------------------------------------------------------------
        // Helper functions
        // ------------------------------------------------------------
        // Creates Credentials from the Login form
        form2Credentials: function() {
            return new Credentials(
                $('#l_username').val(),
                $('#l_password').val());
        }
    });
});