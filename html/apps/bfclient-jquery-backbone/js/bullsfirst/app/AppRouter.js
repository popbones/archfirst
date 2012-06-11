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
 * bullsfirst/app/AppRouter
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/framework/BackboneSyncOverride',
        'bullsfirst/views/AddAccountDialog',
        'bullsfirst/views/HomePage',
        'bullsfirst/views/OpenAccountDialog',
        'bullsfirst/views/UserPage'],
       function(BackboneSyncOverride, AddAccountDialog, HomePage, OpenAccountDialog, UserPage) {
    return Backbone.Router.extend({

        pages: {},

        routes: {
            '': 'showHomePage',
            'user': 'showUserPage'
        },

        initialize: function() {
            this.pages = {
                'home': new HomePage(),
                'user': new UserPage()
            };

            new OpenAccountDialog();
            new AddAccountDialog();

            // Subscribe to events
            $.subscribe("UserLoggedInEvent", $.proxy(function() {
                this.navigate('user', {trigger: true});
            }, this));
            $.subscribe("UserLoggedOutEvent", $.proxy(function() {
                this.navigate('', {trigger: true});
            }, this));
        },

        showHomePage: function() {
            this.showPage(this.pages['home']);
        },

        showUserPage: function() {
            this.showPage(this.pages['user']);
        },

        // TODO: Why is new page showing before hiding the previous page?
        showPage: function(page) {
            $.when(this.hideAllPages()).then(
                function() { return page.show(); });
        },

        // Calls page.hide() on each page and returns promises that are not null
        hideAllPages: function() {
            return _.filter(
                _.map(this.pages, function(page) { return page.hide(); }),
                function (promise) { return promise != null });
        }
    });
});