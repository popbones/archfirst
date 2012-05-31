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
 * bullsfirst/views/AccountView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/BrokerageAccount'
        ],
        function(BrokerageAccount) {

    return Backbone.View.extend({

        model: BrokerageAccount,
        tagName: 'tr',

        render: function() {
            var hash = {
                account: this.model.toJSON()  // returns a copy of the model's attributes 
            }
            $(this.el).html(Mustache.to_html($('#accountTemplate').html(), hash));
            return this;
        }
    });
});