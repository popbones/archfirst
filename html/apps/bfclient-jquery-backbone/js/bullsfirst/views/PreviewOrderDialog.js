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
 * bullsfirst/views/PreviewOrderDialog
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/UserContext',
        'bullsfirst/framework/Formatter'],
        function(UserContext, Formatter) {

    // Configure the dialog
    $('#preview_order_dialog').dialog({
        autoOpen: false,
        width: 500,
        modal: true,
        resizable: false,
        buttons: [
            {
                text: 'Edit Order',
                click: function() { $(this).dialog('close'); }
            },
            {
                text: 'Place Order',
                id: 'place_order_button'
            }]
    });

    return Backbone.View.extend({
        // Defining el this way is required for the click event to be recognized
        el: $('#preview_order_dialog').parent(),

        events: {
            'click #place_order_button': 'placeOrder',
            'keypress #preview_order_dialog': 'checkEnterKey'
        },

        open: function(summary, estimate, marketPrice) {
            // Format values for display
            estimate.lastTradeFormatted = Formatter.formatMoney(marketPrice.get('price'));
            estimate.estimatedValueFormatted = Formatter.formatMoney(estimate.estimatedValue);
            estimate.feesFormatted = Formatter.formatMoney(estimate.fees);
            estimate.estimatedValueInclFeesFormatted = Formatter.formatMoney(estimate.estimatedValueInclFees);

            summary.accountName = UserContext.getBrokerageAccount(summary.brokerageAccountId).get('name');

            summary.orderParams.isLimitOrder = (summary.orderParams.type === 'Limit');
            summary.orderParams.limitPriceFormatted = Formatter.formatMoney(summary.orderParams.limitPrice);

            // Render using template
            var hash = {
                summary: summary,
                estimate: estimate
            }
            $('#preview_order_dialog').html(Mustache.to_html($('#previewOrderTemplate').html(), hash));

            $('#preview_order_dialog').dialog('open');
        },

        checkEnterKey: function(event) {
           if (event.keyCode == $.ui.keyCode.ENTER) {
               this.placeOrder();
               return false;
           }
        },

        placeOrder: function() {
            $('#preview_order_dialog').dialog('close');

            // Create brokerage account
            // BrokerageAccountService.createBrokerageAccount(
            //    $('#addacnt_name').val(), this.createBrokerageAccountDone, ErrorUtil.showError);
        },

        // createBrokerageAccountDone: function(data, textStatus, jqXHR) {
        //    UserContext.updateAccounts();
        // }
    });
});