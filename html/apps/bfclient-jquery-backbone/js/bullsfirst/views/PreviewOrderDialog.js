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
 * bullsfirst/views/PreviewOrderDialog
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/domain/UserContext',
        'bullsfirst/framework/ErrorUtil',
        'bullsfirst/framework/Formatter',
        'bullsfirst/framework/MessageBus',
        'bullsfirst/services/OrderService',
        'text!bullsfirst/templates/preview-order.tpl'],
       function(UserContext, ErrorUtil, Formatter, MessageBus, OrderService, previewOrderTemplate) {

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

        open: function(orderRequest, estimate, marketPrice) {
            this.orderRequest = orderRequest;

            // Format values for display
            // Protect against marketPrice being undefined which happens if instruments are not loaded
            estimate.lastTradeFormatted = (typeof marketPrice === 'undefined') ? 'Unknown' : Formatter.formatMoney(marketPrice.get('price'));
            estimate.estimatedValueFormatted = Formatter.formatMoney(estimate.estimatedValue);
            estimate.feesFormatted = Formatter.formatMoney(estimate.fees);
            estimate.estimatedValueInclFeesFormatted =
                Formatter.formatMoney(estimate.estimatedValueInclFees);

            var summary = {
                accountName: UserContext.getBrokerageAccount(orderRequest.brokerageAccountId).get('name'),
                symbol: orderRequest.orderParams.symbol,
                side: orderRequest.orderParams.side,
                quantity: orderRequest.orderParams.quantity,
                type: orderRequest.orderParams.type,
                isLimitOrder: orderRequest.orderParams.type === 'Limit',
                limitPriceFormatted: Formatter.formatMoney(orderRequest.orderParams.limitPrice),
                term: orderRequest.orderParams.term,
                allOrNone: orderRequest.orderParams.allOrNone
            };

            // Render using template
            var hash = {
                summary: summary,
                estimate: estimate
            }
            $('#preview_order_dialog').html(Mustache.to_html(previewOrderTemplate, hash));

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
            OrderService.createOrder(
                this.orderRequest, _.bind(this.placeOrderDone, this), ErrorUtil.showError);
        },

        placeOrderDone: function(data, textStatus, jqXHR) {
            // Show the order
            MessageBus.trigger('UpdateOrders');
            MessageBus.trigger('UserTabSelectionRequest', 'orders');
        }
    });
});