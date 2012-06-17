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
 * bullsfirst/views/UserPage
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/UserContext',
        'bullsfirst/framework/Page',
        'bullsfirst/views/AccountsTabView',
        'bullsfirst/views/UsernameView'
        ],
        function(UserContext, Page, AccountsTabView, UsernameView) {

    return Page.extend({
        el: '#loggedin_page',

        events: {
            'click #signOutLink': 'logout'
        },

        initialize: function() {
            _.bindAll(this);  // bind all callbacks in this class to this
            $("#tabs").tabs({
                select: this.tabSelected
            });
            new UsernameView({model: UserContext.getUser()});
            new AccountsTabView();

            // Subscribe to events
            $.subscribe("UserLoggedInEvent", function() {
                UserContext.getBrokerageAccounts().fetch();
            });
        },

        logout: function() {
            UserContext.reset();
            $.publish('UserLoggedOutEvent');
        },

        tabSelected: function(event, ui) {
            $.publish('UserTabSelectedEvent', ui.index);
        }
    });
});