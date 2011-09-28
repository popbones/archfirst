/**
 * Copyright 2011 Manish Shanker
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
 * @author Manish Shanker
 */

(function ($) {
    $.server = $.server || {};
    $.server = $.extend($.server, {
        getData: function (url, data, callback) {
            if (url.indexOf('fakeStore') > -1) {
                $.server.fakeStore(url.split(".")[1], data, callback);
            } else {
                $.post(url, data, callback);
            }
        }
    });
}(jQuery));