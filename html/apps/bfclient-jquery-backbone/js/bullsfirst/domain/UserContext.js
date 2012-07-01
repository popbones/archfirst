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
 * bullsfirst/domain/UserContext
 *
 * This is a singleton object that maintains the context of the logged in user.
 * The context consists of the following:
 *   user: User
 *   credentials: Credentials
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/BrokerageAccount',
        'bullsfirst/domain/BrokerageAccounts',
        'bullsfirst/domain/Credentials',
        'bullsfirst/domain/ExternalAccounts',
        'bullsfirst/domain/User',
        'bullsfirst/framework/MessageBus'
        ],
        function(BrokerageAccount, BrokerageAccounts, Credentials, ExternalAccounts, User, MessageBus) {

    // Module level variables act as singletons
    var _user = new User();
    var _credentials = new Credentials();
    var _brokerageAccounts = new BrokerageAccounts();
    var _externalAccounts = new ExternalAccounts();
    var _selectedAccount = null;

    return {
        getUser: function() { return _user; },
        getCredentials: function() { return _credentials; },
        getBrokerageAccounts: function() { return _brokerageAccounts; },
        getExternalAccounts: function() { return _externalAccounts; },
        getSelectedAccount: function() { return _selectedAccount; },

        initUser: function(attributes) {
            _user.set(attributes);
        },

        initCredentials: function(attributes) {
            _credentials.set(attributes);
        },

        setSelectedAccount: function(account) {
            _selectedAccount = account;
            MessageBus.trigger('SelectedAccountChanged', _selectedAccount);
        },

        reset: function() {
            _user.clear();
            _credentials.clear();
            _brokerageAccounts.reset();
            _externalAccounts.reset();
            _selectedAccount = null;
        },

        isUserLoggedIn: function() {
            return _credentials.isInitialized();
        }
    };
});