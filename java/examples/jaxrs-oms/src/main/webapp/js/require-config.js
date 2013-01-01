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
require.config({
    // Initialize the application with the main application file
    deps: ['main'],

    paths: {
        // jQuery
        jquery:                      'vendor/jquery-1.8.3',

        // Underscore
        underscore:                  'vendor/underscore-1.4.3',

        // Backbone
        backbone:                    'vendor/backbone-0.9.9',

        // Templating
        handlebars:                  'vendor/handlebars-1.0.rc.1'
    },

    shim: {
        backbone: {
            deps: ['underscore', 'jquery'],
            exports: 'Backbone'
        },

        handlebars: {
            exports: 'Handlebars'
        },

        underscore: {
            exports: '_'
        }
    }
});