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
 * bullsfirst/views/ExecutionView
 *
 * @author Naresh Bhatia
 */
define(['bullsfirst/framework/Formatter',
        'text!bullsfirst/templates/execution.tpl'],
       function(Formatter, executionTemplate) {

    return Backbone.View.extend({

        tagName: 'tr',

        render: function() {
            // Note that this.model is a raw Execution (not a Backbone model) attributes
            var execution = this.model;
            execution.creationTimeFormatted = Formatter.formatMoment2DateTime(moment(execution.creationTime));
            execution.priceFormatted = Formatter.formatMoney(execution.price);

            // Render using template
            var hash = {
                execution: this.model
            }
            $(this.el).html(Mustache.to_html(executionTemplate, hash));
            return this;
        }
    });
});