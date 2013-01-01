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
 * A fixed view that uses a static template that needs no context or compilation
 *
 * @author Naresh Bhatia
 */
define(
    [
        'framework/BaseView'
    ],
    function(BaseView) {
        'use strict';

        return BaseView.extend({
            // This method expects the derived class to supply a template.source
            render: function() {
                // Remove existing children
                this.removeAllChildren();

                this.$el.html(this.template.source);

                this.postRender();
                return this;
            }
        });
    }
);