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
        'bullsfirst/framework/MessageBus',
        'bullsfirst/framework/Page',
        'bullsfirst/views/AccountsTabView',
        'bullsfirst/views/PositionsTabView',
        'bullsfirst/views/UsernameView'
        ],
        function(UserContext, MessageBus, Page, AccountsTabView, PositionsTabView, UsernameView) {

    return Page.extend({
        el: '#user_page',

        events: {
            'click #signOutLink': 'logout'
        },

        initialize: function() {
            $("#tabs").tabs({
                select: this.tabSelected
            });
            new UsernameView({model: UserContext.getUser()});
            new AccountsTabView();
            new PositionsTabView();

            // Subscribe to events
            MessageBus.on('UserLoggedInEvent', function() {
                UserContext.getBrokerageAccounts().fetch();
            });
        },

        logout: function() {
            UserContext.reset();
            MessageBus.trigger('UserLoggedOutEvent');
        },

        tabSelected: function(event, ui) {
            MessageBus.trigger('UserTabSelectedEvent', ui.index);

            // Instead of tab control to change the selection automatically,
            // we could stop this by calling event.preventDefault() and then
            // letting the router select the tab manually. But this runs into
            // recursion issues and the solution is needlessly complex.
            // See detailed discussion here:
            // http://forum.jquery.com/topic/selecting-tab-manually-on-a-click
        }
    });
});