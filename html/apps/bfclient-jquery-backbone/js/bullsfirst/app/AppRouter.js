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
 * bullsfirst/app/AppRouter
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/UserContext',
        'bullsfirst/framework/BackboneSyncOverride',
        'bullsfirst/framework/BackboneViewExtension',
        'bullsfirst/framework/MessageBus',
        'bullsfirst/views/HomePage',
        'bullsfirst/views/UserPage'],
       function(UserContext, BackboneSyncOverride, BackboneViewExtension, MessageBus, HomePage, UserPage) {
    return Backbone.Router.extend({

        pages: {},

        tabs: ['accounts', 'positions', 'orders', 'transactions', 'trade', 'transfer'],

        startTab: 'accounts',

        routes: {
            '': 'showHomePage',
            'user/:tab': 'showUserPage'
        },

        initialize: function() {
            this.pages = {
                'home': new HomePage(),
                'user': new UserPage()
            };

            // Subscribe to events
            MessageBus.on('UserLoggedInEvent', function() {
                this.navigate('user/' + this.startTab, {trigger: true});
            }, this);
            MessageBus.on('UserLoggedOutEvent', function() {
                // Do a full page refresh to start from scratch
                this.navigate('');
                window.location.reload();
            }, this);
            MessageBus.on('UserTabSelectedEvent', function(tabIndex) {
                // Do not trigger a hashchange event, simply update the URL.
                // jQuery UI automatically changes the tab content.
                this.navigate('user/' + this.tabs[tabIndex]);
            }, this);
            MessageBus.on('UserTabSelectionRequest', function(tabName) {
                // In this case, do trigger a hashchange event
                this.navigate('user/' + tabName, {trigger: true});
            }, this);
        },

        showHomePage: function() {
            this.showPage(this.pages['home']);
        },

        showUserPage: function(tab) {
            // Show user page only if user is logged in
            if (UserContext.isUserLoggedIn()) {
                this.showPage(this.pages['user']);

                // Select the requested tab
                var tabIndex = this.tabs.indexOf(tab);
                if (tabIndex != -1) {
                    $('#tabs').tabs('select', tabIndex);
                }
            }
            else {
                // happens when user enters a bookmarked URL
                this.startTab = tab;
                this.navigate('');
                this.showPage(this.pages['home']);
            }
        },

        // TODO: Why is new page showing before hiding the previous page?
        showPage: function(page) {
            // if page is already visible, do nothing
            if (page.isVisible()) return;

            // else hide all pages and show the desired one
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