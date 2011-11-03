/**
 * Copyright 2011 Archfirst
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
 * @author Naresh Bhatia
 */

var Bullsfirst = window.Bullsfirst || {};

Bullsfirst.ready = function () {

    // -----------------------------------------------------------------------------------
    // Properties
    // -----------------------------------------------------------------------------------
    var username, password, user;


    // -----------------------------------------------------------------------------------
    // Authentication Header
    // -----------------------------------------------------------------------------------

    /**
    * Sets an Authorization header in the request. We force this header in every
    * request to avoid being challenged by the server for credentials (the server
    * sends a 401 Unauthorized error along with a WWW-Authenticate header to do this).
    * Specifically, we don't rely on username/password settings in the jQuery.ajax()
    * call since they cause an unnecessary roundtrip to the server resulting in a 401
    * before sending the Authorization header.
    */
    function setAuthorizationHeader(xhr) {
        xhr.setRequestHeader(
            'Authorization',
            'Basic ' + base64_encode(username + ':' + password));
    }

    /**
    * Sets the password header in the request. This is needed only for the get user
    * REST request.
    */
    function setPasswordHeader(xhr) {
        xhr.setRequestHeader('password', password);
    }


    // -----------------------------------------------------------------------------------
    // Configure jQuery UI
    // -----------------------------------------------------------------------------------
    $('input:submit, button').button();


    // -----------------------------------------------------------------------------------
    // Statusbar
    // -----------------------------------------------------------------------------------
    var messageColors = {
        debug: 'black',
        info: 'green',
        warn: 'brown',
        error: 'red'
    }

    function showStatusMessage(category, message) {
        $('#statusbar_message').html('[' + category + '] ' + message);
        $('#statusbar_message').css('color', messageColors[category]);
        $('#statusbar').fadeIn('fast');
    }

    function clearStatusMessage() {
        $('#statusbar').fadeOut('fast');
    }

    $('#statusbar_cancel_button').click(function () {
        clearStatusMessage();
    });


    // -----------------------------------------------------------------------------------
    // Base View
    // -----------------------------------------------------------------------------------
    var BaseView = Backbone.View.extend({
        parent: $('#main'),
        className: 'view',

        initialize: function() {
            // this.el = $(this.el);
            this.el.hide();
            // this.parent.append(this.el);
            return this;
        },

        hide: function() {
            if (this.el.is(':visible') === false) {
                return null;
            }
            promise = $.Deferred(_.bind(function(dfd) { 
                this.el.fadeOut('fast', dfd.resolve)}, this));
            return promise.promise();
        },

        show: function() {
            if (this.el.is(':visible')) {
                return;
            }
            promise = $.Deferred(_.bind(function(dfd) { 
                this.el.fadeIn('fast', dfd.resolve) }, this))
            return promise.promise();
        }
    });


    // -----------------------------------------------------------------------------------
    // Home View
    // -----------------------------------------------------------------------------------
    var HomeView = BaseView.extend({

        el: $('#home_view'),

        initialize: function(options) {
            this.constructor.__super__.initialize.apply(this, [options])
        },

        events: {
            'submit #loginForm': 'loginFormSubmit',
            'click #l_open_account': 'showOpenAccountDialog'
        },

        // TODO: Form validation
        loginFormSubmit: function() {
            username = $('#l_username').val();
            password = $('#l_password').val();
            login();
            return false;
        },

        showOpenAccountDialog: function() {
            $('#open_account_dialog').dialog('open');
            return false;
        }
    });

    /**
    * Logs in to the server using saved credentials. If login is successful,
    * saves the returned user information in the user object.
    */

    function login() {

        $.ajax({
            url: '/bfoms-javaee/rest/users/' + username,
            /* url: '/archfirst/login.php?user_name='+username+'&?password='+password,*/
            beforeSend: setPasswordHeader,
            success: function (data, textStatus, jqXHR) {
                user = data;
                clearStatusMessage();
                $('#l_password')[0].value = ''; // erase password from form
                window.location.hash = 'accounts';
                // TODO: Remove after accounts page shows username
                showStatusMessage('info', 'Hello ' + user.firstName + ' ' + user.lastName + '!');
                getBrokerageAccounts();
            },
            error: function (jqXHR, textStatus, errorThrown) {
                showStatusMessage('error', errorThrown);
            }
        });
    }


    // -----------------------------------------------------------------------------------
    // Open Account View
    // -----------------------------------------------------------------------------------
    $('#open_account_dialog').dialog({
        autoOpen: false,
        width: 250,
        modal: true,
        resizable: false,
        buttons: [
            {
                text: 'Open Account',
                id: 'open_account_button',
                click: function() { $(this).dialog('close'); }
            },
            {
                text: 'Cancel',
                click: function() { $(this).dialog('close'); }
            }]
    });

    var OpenAccountView = Backbone.View.extend({

        el: $('#open_account_dialog').parent(),

        events: {
            'click #open_account_button': 'openAccount'
        },

        // TODO: Form validation
        openAccount : function() {
            $.ajax({
                /* 	url: '/archfirst/post.php', */
                url: '/bfoms-javaee/rest/users',
                type: 'POST',
                contentType: 'application/json',
                data: this.createRegistrationRequest(),
                success: function (data, textStatus, jqXHR) {
                    // TODO: initialize the proper user object - not with every form element
                    user = $('#openAccountForm').toObject();
                    clearStatusMessage();
                    // TODO: Erase the form
                    window.location.hash = 'accounts';
                    // TODO: Remove after accounts page shows username
                    showStatusMessage('info', 'Hello ' + user.firstName + ' ' + user.lastName + '!');
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    showStatusMessage('error', errorThrown);
                }
            });
        },

        createRegistrationRequest: function() {
            var request = $('#openAccountForm').toObject();
            delete request.confirmPassword; // property not expected by REST service
            return JSON.stringify(request, null, '\t')
        }
    });

    new OpenAccountView();


    // -----------------------------------------------------------------------------------
    // Accounts View
    // -----------------------------------------------------------------------------------
    var AccountsView = BaseView.extend({

        el: $('#accounts_view'),

        initialize: function(options) {
            this.constructor.__super__.initialize.apply(this, [options])
        },

        // TODO: not yet called
        onUserLoggedOut : function() {
            // clear user context
            clearStatusMessage();
        }
    });

    function getBrokerageAccounts() {
        $.ajax({
            url: '/bfoms-javaee/rest/secure/brokerage_accounts',
            beforeSend: setAuthorizationHeader,
            success: function (data, textStatus, jqXHR) {
                $('#accounts_dump').text(JSON.stringify(data, null, '    '));
            },
            error: function (jqXHR, textStatus, errorThrown) {
                showStatusMessage('error', errorThrown);
            }
        });
    }


    // -----------------------------------------------------------------------------------
    // Workspace
    // -----------------------------------------------------------------------------------
    var Workspace = Backbone.Router.extend({

        views: {},

        routes: {
            '': 'showHome',
            'accounts': 'showAccounts'
        },

        initialize: function () {
            this.views = {
                'home': new HomeView(),
                'accounts': new AccountsView()
            };

            // Start with home view
            window.location.hash = '';
            return this;
        },

        hideAllViews: function () {
            return _.select(
                _.map(this.views, function(v) { return v.hide(); }), 
                function (t) { return t != null });
        },

        showHome: function () {
            var view = this.views['home'];
            $.when(this.hideAllViews()).then(
                function() { return view.show(); });
        },

        showAccounts: function () {
            var view = this.views['accounts'];
            $.when(this.hideAllViews()).then(
                function() { return view.show(); });
        }
    });

    new Workspace();
    Backbone.history.start();
}