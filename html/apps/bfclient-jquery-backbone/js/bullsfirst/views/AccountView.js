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
 * bullsfirst/views/AccountView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/BrokerageAccount',
        'bullsfirst/domain/UserContext',
        'bullsfirst/framework/MessageBus',
        'bullsfirst/views/EditAccountDialog'
        ],
        function(BrokerageAccount, UserContext, MessageBus, EditAccountDialog) {

    var editAccountDialog = null;

    return Backbone.View.extend({

        model: BrokerageAccount,
        tagName: 'tr',

        events: {
            'click .act_select_account': 'selectAccount',
            'click .act_edit_account': 'editAccount'
        },

        render: function() {
            var hash = {
                account: this.model.toJSON()  // returns a copy of the model's attributes 
            }
            $(this.el).html(Mustache.to_html($('#accountTemplate').html(), hash));
            return this;
        },

        selectAccount: function() {
            UserContext.setSelectedAccount(this.model);

            // Switch to positions tab
            MessageBus.trigger('UserTabSelectionRequest', 1);

            return false;
        },

        editAccount: function() {
            if (!editAccountDialog) {
                editAccountDialog = new EditAccountDialog();
            }
            editAccountDialog.open(this.model);
            return false;
        }
    });
});