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
 * bullsfirst/app/BullsfirstApp
 *
 * This class intentionally does not extend the Backbone router to prevent the user
 * from circumventing the loggedin state (which can be done by typing in the hash tags).
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/framework/BackboneSyncOverride',
        'bullsfirst/views/HomePage',
        'bullsfirst/views/LoggedinPage',
        'bullsfirst/views/AddAccountDialog',
        'bullsfirst/views/OpenAccountDialog'],
       function(BackboneSyncOverride, HomePage, LoggedinPage, AddAccountDialog, OpenAccountDialog) {

    function BullsfirstApp() {
        this.pages = {
            'home': new HomePage(),
            'loggedin': new LoggedinPage()
        };

        new OpenAccountDialog();
        new AddAccountDialog();
    }

    BullsfirstApp.prototype.showHomePage = function() {
        this.showPage(this.pages['home']);
    }

    BullsfirstApp.prototype.showLoggedinPage = function() {
        this.showPage(this.pages['loggedin']);
    }

    // TODO: Why is new page showing before hiding the previous page?
    BullsfirstApp.prototype.showPage = function(page) {
        $.when(this.hideAllPages()).then(
            function() { return page.show(); });
    }

    // Calls page.hide() on each page and returns promises that are not null
    BullsfirstApp.prototype.hideAllPages = function() {
        return _.filter(
            _.map(this.pages, function(page) { return page.hide(); }),
            function (promise) { return promise != null });
    }

    // Singleton instance of the app
    var theApp = new BullsfirstApp();

    // Subscribe to events
    $.subscribe("UserLoggedInEvent", function() {
        theApp.showLoggedinPage();
    });
    $.subscribe("UserLoggedOutEvent", function() {
        theApp.showHomePage();
    });

    return {
        getTheApp: function() { return theApp; }
    }
});