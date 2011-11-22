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
    // Page
    // -----------------------------------------------------------------------------------
    var Page = Backbone.View.extend({
        parent: $('#main'),

        initialize: function() {
            this.el = $(this.el);
            this.el.hide();
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
    // HomePage
    // -----------------------------------------------------------------------------------
    var HomePage = Page.extend({

        el: $('#home_page'),

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
                getBrokerageAccounts();
            },
            error: function (jqXHR, textStatus, errorThrown) {
                showStatusMessage('error', errorThrown);
            }
        });
    }


    // -----------------------------------------------------------------------------------
    // OpenAccountDialog
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

    // Attach to a backbone view
    var OpenAccountDialog = Backbone.View.extend({

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

    new OpenAccountDialog();


    // -----------------------------------------------------------------------------------
    // BrokerageAccount Model
    // -----------------------------------------------------------------------------------
    var BrokerageAccount = Backbone.Model.extend({
    });

    var BrokerageAccountCollection = Backbone.Collection.extend({
        model: BrokerageAccount,
        url: '/bfoms-javaee/rest/secure/brokerage_accounts'
    });

    // Instance of account collection
    var accounts = new BrokerageAccountCollection;


    // -----------------------------------------------------------------------------------
    // AccountsPage
    // -----------------------------------------------------------------------------------
    var AccountsPage = Page.extend({

        el: $('#accounts_page'),

        initialize: function(options) {
            this.constructor.__super__.initialize.apply(this, [options])
            accounts.bind('reset', this.resetAccounts, this);
        },

        resetAccounts: function() {
            // take out rows that might be sitting in the table
            this.$('#accounts_table tbody').empty();

            // add new rows from accounts collection
            accounts.each(this.addAccount);
        },

        addAccount: function(account) {
            var view = new AccountView({model: account});
            this.$('#accounts_table tbody').append(view.render().el);
        },

        // TODO: not yet called
        onUserLoggedOut : function() {
            // clear user context
            // clear accounts
            clearStatusMessage();
        }
    });

    function getBrokerageAccounts() {
        accounts.fetch({
            url: '/bfoms-javaee/rest/secure/brokerage_accounts',
            beforeSend: setAuthorizationHeader,
            error: function (collection, response) {
                // response is XMLHttpRequest???
                showStatusMessage('error', response.statusText);
            }
        });
    }


    // -----------------------------------------------------------------------------------
    // Account View
    // -----------------------------------------------------------------------------------
    var AccountView = Backbone.View.extend({

        model: BrokerageAccount,
        tagName: "tr",

        render: function() {
            var hash = {
                account: this.model.toJSON()  // returns a copy of the model's attributes 
            }
            $(this.el).html(Mustache.to_html($('#accountTemplate').html(), hash));
            return this;
        }
    });


    // -----------------------------------------------------------------------------------
    // Workspace
    // -----------------------------------------------------------------------------------
    var Workspace = Backbone.Router.extend({

        views: {},

        routes: {
            '': 'showHomePage',
            'accounts': 'showAccountsPage'
        },

        initialize: function () {
            this.views = {
                'home': new HomePage(),
                'accounts': new AccountsPage()
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

        showHomePage: function () {
            var view = this.views['home'];
            $.when(this.hideAllViews()).then(
                function() { return view.show(); });
        },

        showAccountsPage: function () {
            var view = this.views['accounts'];
            $.when(this.hideAllViews()).then(
                function() { return view.show(); });
        }
    });

    new Workspace();
    Backbone.history.start();
}