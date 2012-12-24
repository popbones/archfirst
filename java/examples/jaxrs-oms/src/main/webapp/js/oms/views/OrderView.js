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
 * oms/views/OrderView
 *
 * @author Naresh Bhatia
 */
define(['oms/views/TemplateManager'],
       function(TemplateManager) {
    'use strict';

    return Backbone.View.extend({

        tagName: 'tr',

        events: {
            'click .edit-quantity': 'handleEditQuantity',
            'click .save-quantity': 'handleSaveQuantity',
            'click .delete': 'handleDeleteOrder'
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
            this.$el.find('.quantity').removeClass('editing');
            this.model.save(
                {quantity: this.$el.find('.quantityField').val()},
                {wait: true});
            return false;
        },

        handleDeleteOrder: function() {
            this.model.destroy({wait: true});
        },

        handleChange: function() {
            this.render();
        },

        render: function() {
            var order = this.model.toJSON();
            var template = TemplateManager.getTemplate('order');
            $(this.el).html(template(order));
            return this;
        }
    });
});