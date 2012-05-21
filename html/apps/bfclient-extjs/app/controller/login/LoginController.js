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
* app/controller/login/LoginController
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.controller.login.LoginController', {
    extend: 'Ext.app.Controller',

    views: [
        'shared.MainContentPanel',
		'accounts.LoginView',
        'accounts.CreateAccountView',
        'trading.TradingTabPanel'
    ],

    models: [
        'User'
    ],

    stores: [
        'LoggedInUser'
    ],

    refs: [
        {
            ref: 'MainContentPanel',
            selector: 'viewport panel[itemId=mainContentRegion]'
        },
        {
            ref: 'CreateAccountWindow',
            selector: 'createaccountview'
        },
        {
            ref: 'CreateAccountWindowUserName',
            selector: 'createaccountview textfield[name=username]'
        },
        {
            ref: 'CreateAccountWindowPassword',
            selector: 'createaccountview textfield[name=password]'
        },
        {
            ref: 'LoginForm',
            selector: 'loginview'
        },
        {
            ref: 'LoginUserNameField',
            selector: 'loginview textfield[name=username]'
        },
        {
            ref: 'LoginPasswordField',
            selector: 'loginview textfield[name=password]'
        },
        {
            ref: 'LoginButton',
            selector: 'loginview button'
        }
    ],

    init: function () {
        this.control({
            'loginview component[itemId=openAccountLink]': {
                'render': this.onOpenAccountLinkRender
            },
            'loginview button': {
                'click': this.onLoginButtonClick
            },
            'createaccountview button[action=openAccount]': {
                'click': this.onOpenAccountButtonClick
            },
            'createaccountview button[action=cancel]': {
                'click': this.onCancelButtonClick
            }
        });
        this.callParent();
    },
    onOpenAccountLinkRender: function onOpenAccountLinkRender(openAccountLink) {
        openAccountLink.getEl().on('click', this.onOpenAccountLinkClick, this);
    },
    onOpenAccountLinkClick: function onOpenAccountLinkClick(openAccountLink) {
        //Show "Create Account" view
        Ext.create('widget.createaccountview').show();
    },
    onLoginButtonClick: function onLoginButtonClick(loginButton) {
        var loginForm = loginButton.up('form').getForm();
        if (loginForm.hasInvalidField()) {
            Ext.Msg.alert(Bullsfirst.GlobalConstants.ErrorTitle, Bullsfirst.GlobalConstants.InvalidForm);
            submitButton.disable();
        }
        var userName = this.getLoginUserNameField().getValue();
        var password = this.getLoginPasswordField().getValue();
        this.processLogin(userName, password, Bullsfirst.GlobalConstants.LoggingInMaskMessage);

    },
    onOpenAccountButtonClick: function onOpenAccountButtonClick(openAccountButton) {
        var createAccountForm = openAccountButton.up('form').getForm();
        if (createAccountForm.hasInvalidField()) {
            Ext.Msg.alert(Bullsfirst.GlobalConstants.ErrorTitle, Bullsfirst.GlobalConstants.InvalidForm);
        }
        openAccountButton.disable();
        var userAccount = Ext.create('Bullsfirst.model.User');
        createAccountForm.updateRecord(userAccount);

        //Save log in information for http basic authentication
        this.updateUserStore(userAccount.get('username'), userAccount.get('password'));

        EventAggregator.subscribe('useraccountcreated', this.onUserAccountCreated, this);

        //Submit request to create user account
        userAccount.save({
            callback: function (record, operation, success) {
                if (operation.wasSuccessful() == true) {
                    EventAggregator.publish('useraccountcreated', operation);
                }
                else {
                    EventAggregator.publish('useraccountcreationError', operation);
                    openAccountButton.enable();
                }
            }

        }, this);
    },
    onUserAccountCreated: function onUserAccountCreated() {
        //subscribe to brokerageaccountcreated event
        EventAggregator.subscribe('brokerageaccountcreated', this.onBrokerageAccountCreated, this);

        //Submit request to create new brokerage account
        var accountsController = this.getController('Bullsfirst.controller.trading.AccountsController');
        accountsController.createBrokerageAccount(Bullsfirst.GlobalConstants.BrokeageAccountDefaultName);
    },
    onBrokerageAccountCreated: function (operation) {
        //subscribe to externalaccountcreated event
        var createdBrokerageAccountId = JSON.parse(operation.response.responseText).id;
        EventAggregator.subscribe('externalaccountcreated', function (operation) {
            this.onExternalAccountCreated(operation, createdBrokerageAccountId);
        }, this);

        //Submit request to create new external account
        var newExternalAccount = Ext.create('Bullsfirst.model.ExternalAccount', {
            name: Bullsfirst.GlobalConstants.ExternalAccountDefaultName,
            routingNumber: Bullsfirst.GlobalConstants.ExternalAccountDefaultRoutingNumber,
            accountNumber: Bullsfirst.GlobalConstants.ExternalAccountDefaultAccountNumber
        });
        var transferController = this.getController('Bullsfirst.controller.trading.TransferController');
        transferController.createNewExternalAccount(newExternalAccount);
    },
    onExternalAccountCreated: function (operation, createdBrokerageAccountId) {
        var createdExternalAccountId = JSON.parse(operation.response.responseText).id;

        //send request to tranfer cash from external to brokerage account
        var newTransferRequest = Ext.create('Bullsfirst.model.CashTransfer', {
            amount: Bullsfirst.GlobalConstants.DefaultTransferAmount,
            toAccountId: createdBrokerageAccountId
        });
        var fromAccount = createdExternalAccountId;
        var transferController = this.getController('Bullsfirst.controller.trading.TransferController');
        EventAggregator.subscribe('transferprocessed', this.onTransferProcessed, this);
        transferController.processTransferRequest(newTransferRequest, fromAccount);
    },
    onTransferProcessed: function () {
        //After new account is created, process login
        var newUserName = this.getCreateAccountWindowUserName().getValue();
        var newUserPassword = this.getCreateAccountWindowPassword().getValue();
        this.getCreateAccountWindow().close();
        this.processLogin(newUserName, newUserPassword, Bullsfirst.GlobalConstants.AccountCreatedMaskMessage);
        
    },
    onCancelButtonClick: function onCancelButtonClick(cancelButton) {
        cancelButton.up('window').close();
    },
    processLogin: function processLogin(userName, password, loginMessage) {
        var loginForm = this.getLoginForm().getForm();

        //Save log in information for http basic authentication
        this.updateUserStore(userName, password);

        var loginMask = new Ext.LoadMask(this.getLoginButton().up('viewport'), { msg: loginMessage });
        loginForm.mask = loginMask;
        loginMask.show();
        //submit login form
        loginForm.submit({
            method: 'GET',
            scope: this,
            headers: {
                password: password
            },
            clientValidation: false,
            url: Bullsfirst.GlobalConstants.BaseUrl + "/bfoms-javaee/rest/users/" + userName,
            success: this.processLoggedInUser,
            failure: this.processLoggedInUser
        }, this);
    },
    processLoggedInUser: function processLoggedInUser(form, action) {
        var me = this;
        form.mask.hide();
        EventAggregator.subscribe('userloggedin', function (action) {
            //Upon succesful login, show trading tab panel
            me.injectView(Ext.create('widget.tradingtabpanel', { loggedInUser: action.result }));
        }, this);

        if (action.response.status == 200) {
            EventAggregator.publish('userloggedin', action);
        }
        else {
            EventAggregator.publish('userloginError', action);
        }
    },
    //Save login information in LoggedInUser store for use in basic http authetication
    updateUserStore: function updateUserStore(userName, password) {
        var user = Ext.create('Bullsfirst.model.User', { username: userName, password: password });
        var userStore = this.getStore('LoggedInUser');
        userStore.removeAll();
        userStore.add(user);
    },
    injectView: function injectView(view) {
        var mainContentPanel = this.getMainContentPanel();
        var mainContentParent = mainContentPanel.up('container');
        mainContentParent.remove(mainContentPanel);
        view.flex = 1;
        view.itemId = 'mainContentRegion';
        mainContentParent.add(view);
    }
});