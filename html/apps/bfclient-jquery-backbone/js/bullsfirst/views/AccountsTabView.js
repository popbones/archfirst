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
 * bullsfirst/views/AccountsTabView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/UserContext',
        'bullsfirst/views/AccountTableView'
        ],
        function(UserContext, AccountTableView) {

    return Backbone.View.extend({

        el: '#accounts_tab',

        events: {
            'click #act_update': 'updateAccounts',
            'click #act_add_account': 'addAccount'
        },

        initialize: function(options) {
            _.bindAll(this);  // bind all callbacks in this class to this
            new AccountTableView({collection: UserContext.getBrokerageAccounts()});
        },

        updateAccounts: function() {
            UserContext.getBrokerageAccounts().fetch();
        },

        addAccount: function() {
            $('#add_account_dialog').dialog('open');
            return false;
        }
    });
});