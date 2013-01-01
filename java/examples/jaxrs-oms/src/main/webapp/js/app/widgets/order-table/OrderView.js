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
 * app/widgets/order-table/OrderView
 *
 * @author Naresh Bhatia
 */
define(
    [
        'framework/BaseDynamicView',
        'text!app/widgets/order-table/OrderTemplate.html'
    ],
    function(BaseDynamicView, OrderTemplate) {
        'use strict';

        var KEY_CODE_ENTER  = 13,
            KEY_CODE_ESCAPE = 27;

        return BaseDynamicView.extend({

            tagName: 'tr',

            template: {
                name: 'OrderTemplate',
                source: OrderTemplate
            },

            events: {
                'click .edit-quantity': 'handleEditQuantity',
                'click .save-quantity': 'handleSaveQuantity',
                'click .delete': 'handleDeleteOrder',
                'keydown .quantityField': 'handleKeyDownOnQuantity' /* keypress for Escape is not detected on chrome */
            },

            initialize: function(/* options */) {
                this.listenTo(this.model, 'change', this.handleChange);
            },

            handleEditQuantity: function() {
                this.$el.find('.quantity').addClass('editing');
                this.$el.find('.quantityField').val(this.model.get('quantity')).focus();
                return false;
            },

            handleSaveQuantity: function() {
                this.stopEditing();
                this.model.save(
                    {quantity: this.$el.find('.quantityField').val()},
                    {wait: true});
                return false;
            },

            handleDeleteOrder: function() {
                this.model.destroy({wait: true});
            },

            handleKeyDownOnQuantity: function(event) {
                if (event.keyCode === KEY_CODE_ENTER) {
                    this.handleSaveQuantity();
                    return false;
                }
                else if (event.keyCode === KEY_CODE_ESCAPE) {
                    this.stopEditing();
                    return false;
                }

                // If not one of the keycodes above, let the event bubble up for the input box
            },

            handleChange: function() {
                this.render();
            },

            stopEditing: function() {
                this.$el.find('.quantity').removeClass('editing');
            }
        });
    }
);