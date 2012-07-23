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
 * bullsfirst/views/TransferTabView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/UserContext'],
       function(UserContext) {

    return Backbone.View.extend({

        el: '#transfer_tab',

        events: {
            'submit #transferForm': 'validateForm',
            'keypress #transfer_tab': 'checkEnterKey',
            'change #transferForm_transferKind input:radio[name=transferKind]': 'transferKindChanged'
        },

        initialize: function(options) {
            $('#transferForm_transferKind input:radio[name=transferKind]')[0].checked = true;
            this.showCashItemsImmediate();

            $('#transferForm').validationEngine();
        },

        checkEnterKey: function(event) {
           if (event.keyCode == $.ui.keyCode.ENTER) {
               this.validateForm();
               return false;
           }
        },

        validateForm: function() {
            if ($('#transferForm').validationEngine('validate')) {

                this.transferRequest = $('#transferForm').toObject();
            }
            return false;
        },

        transferKindChanged: function(event) {
            (event.target.value === 'cash') ? this.showCashItems() : this.showSecuritiesItems();
        },

        // show('fast') amd hide('fast) does not work from initialize()
        showCashItemsImmediate: function() {
            $('.transferForm_cashItem').show();
            $('.transferForm_securitiesItem').hide();
        },

        showCashItems: function() {
            $('.transferForm_cashItem').show('fast');
            $('.transferForm_securitiesItem').hide('fast');
        },

        showSecuritiesItems: function() {
            $('.transferForm_cashItem').hide('fast');
            $('.transferForm_securitiesItem').show('fast');
        }
    });
});