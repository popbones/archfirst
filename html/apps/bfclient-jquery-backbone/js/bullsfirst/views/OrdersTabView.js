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
 * bullsfirst/views/OrdersTabView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/UserContext',
        'bullsfirst/views/AccountSelectorView'
        ],
        function(UserContext, AccountSelectorView) {

    return Backbone.View.extend({

        el: '#orders_tab',

        initialize: function(options) {
            new AccountSelectorView({
                el: '#orders_tab_account_selector',
                collection: UserContext.getBrokerageAccounts()
            });
        }
    });
});