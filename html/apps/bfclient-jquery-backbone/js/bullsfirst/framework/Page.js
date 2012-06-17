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
 * bullsfirst/framework/Page
 *
 * @author Naresh Bhatia
 */
define(function() {
    return Backbone.View.extend({
        hide: function() {
            if (this.$el.is(':visible') === false) {
                return null;
            }
            var deferred = $.Deferred(_.bind(function(dfd) {
                    this.$el.fadeOut('fast', dfd.resolve);
                }, this));
            return deferred.promise();
        },

        show: function() {
            if (this.$el.is(':visible')) {
                return;
            }
            var deferred = $.Deferred(_.bind(function(dfd) {
                    this.$el.fadeIn('fast', dfd.resolve);
                }, this))
            return deferred.promise();
        },

        isVisible: function() {
            return this.$el.is(':visible');
        }
    });
});