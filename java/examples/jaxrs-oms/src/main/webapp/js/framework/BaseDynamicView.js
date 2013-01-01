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
 * framework/BaseStaticView
 *
 * A dynamic view that uses a template that needs a context and compilation
 *
 * @author Naresh Bhatia
 */
define(
    [
        'framework/BaseView',
        'handlebars'
    ],
    function(BaseView, Handlebars) {
        'use strict';

        // Global template cache
        var _templates = {};

        return BaseView.extend({
            // This method expects the derived class to supply a template.name and
            // a template.source
            render: function() {
                var template = this.getTemplate(),
                    context = this.model.toJSON();

                // Remove existing children
                this.removeAllChildren();

                this.$el.html(template(context));

                this.postRender();
                return this;
            },

            getTemplate: function() {
                if (!_templates[this.template.name]) {
                    _templates[this.template.name] = Handlebars.compile(this.template.source);
                }

                return _templates[this.template.name];
            }
        });
    }
);