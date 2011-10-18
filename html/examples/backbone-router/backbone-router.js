/**
* Copyright 2011 Archfirst
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
* @author Naresh Bhatia
*/

var BackboneRouterExample = window.BackboneRouterExample || {};

BackboneRouterExample.Run = function () {

    var HomeView = Backbone.View.extend({

        el: $("#main"),

        render: function () {
            $(this.el).html("<h1>Home</h1><a href='#orders'>Orders</a>");
            return this;
        }
    });

    var OrdersView = Backbone.View.extend({

        el: $("#main"),

        render: function () {
            $(this.el).html("<h1>Orders</h1><a href='#'>Home</a>");
            return this;
        }
    });

    var Workspace = Backbone.Router.extend({

        views: {},

        routes: {
            "": "home",
            "orders": "orders"
        },

        initialize: function () {
            this.views = {
                "home": new HomeView(),
                "orders": new OrdersView()
            };

            // Start with home view
            window.location.hash = '';
            return this;
        },

        home: function () {
            this.views['home'].render();
        },

        orders: function () {
            this.views['orders'].render();
        }
    });

    new Workspace();
    Backbone.history.start();
}