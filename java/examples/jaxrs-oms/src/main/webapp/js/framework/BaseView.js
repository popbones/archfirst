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
 * framework/BaseView
 * Based on: https://github.com/rmurphey/srchr-demo/blob/master/app/views/base.js
 *
 * This is a view base class built on top of the default Backbone.View; it
 * provides a set of rendering, binding, and lifecycle methods that tend to
 * be useful in Backbone applications. As part lifecycle methods, it provides
 * the facility to maintain a set of child views, especially to avoid zombies.
 *
 * This view has been further extended to specialize the render method.
 * To use this view, you should call the 'extend' method of the appropriate
 * sub-class just like you would extend the normal 'Backbone.View'.
 *
 * @author Naresh Bhatia
 */
define(
    [
        'backbone',
        'jquery'
    ],
    function(Backbone, $) {
        'use strict';

        return Backbone.View.extend({
            // Map of ids to child views
            // The view id is any unique string, e.g. the id of the associated model
            childViews: {},

            addChild: function(id, childView) {
                this.childViews[id] = childView;
            },

            removeChild: function(id) {
                this.childViews[id].remove();
                delete this.childViews[id];
            },

            removeAllChildren: function() {
                for (var id in this.childViews) {
                    if (this.childViews.hasOwnProperty(id)) {
                        this.childViews[id].remove();
                    }
                }
                this.childViews = {};
            },

            // Once the view has been rendered, it still needs to be placed in the
            // document. The 'place' method allows you to specify a destination for
            // the view; this destination can either be a jQuery object, a DOM node,
            // or a selector. The 'place' method also optionally takes a position
            // argument, which determines how the object will be placed in the
            // destination node: as the first, last, or only child.
            place: function(node, position) {
                position = position || 'last';

                var method = {
                    'first':     'prepend',
                    'last':      'append',
                    'only':      'html'
                }[position] || 'append';

                $(node)[method](this.$el);

                this.postPlace();
                return this;
            },

            // 'postRender' fires just before the view's 'render' method returns. Do
            // things here that require the view's basic markup to be in place, but
            // that do NOT require the view to be placed in the document.
            postRender: function() {
            },

            // 'postPlace' fires just before the view's 'place' method returns. Do
            // things here that require the view to be placed in the document, such as
            // operations that require knowing the dimensions of the view.
            postPlace: function() {
            }
        });
    }
);