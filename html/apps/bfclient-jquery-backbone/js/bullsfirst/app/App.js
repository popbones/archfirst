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
 * bullsfirst/app/App
 *
 * Singleton application object.
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/app/AppRouter'],
       function(AppRouter) {

    // Set default timeout for AJAX requests to 20 seconds
    // This should be done before instantiating the AppRouter,
    // because the initialization sequence fires AJAX requests
    $.ajaxSetup({timeout: 20000});

    // Create the router
    var _appRouter = new AppRouter();

    // Begin monitoring hashchange events and dispatching routes
    // Setting pushState to true tells Backbone to use the history API
    Backbone.history.start({root: '/apps/bfclient-jquery-backbone/'});
});