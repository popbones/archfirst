/**
 * Copyright 2011-2013 Archfirst
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
    "use strict";

    var toolbarContainer = {};

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            toolbar: function ($afGrid, options) {

                options = $.extend({
                    showToolbar: true,
                    toolbarTemplate: "<div class='afGrid-toolbar'><a href='#' class='afGrid-reset'>Reset</a><a href='#' class='afGrid-refresh'>Refresh</a></div>",
                    onReset: $.noop
                }, options);

                var $toolbar;

                function load() {
                    if (!options.showToolbar) {
                        return;
                    }
                    $toolbar = $(options.toolbarTemplate);
                    toolbarContainer[options.id] = $toolbar;
                    $afGrid.prepend($toolbar);
                    $afGrid.undelegate(".afGrid-reset", "click").delegate(".afGrid-reset", "click", function () {
                        options.onReset();
                        return false;
                    });
                    $afGrid.undelegate(".afGrid-refresh", "click").delegate(".afGrid-refresh", "click", function () {
                        options.onRefresh();
                        return false;
                    });
                }

                function destroy() {
                    delete toolbarContainer[options.id];
                    if ($toolbar) {
                        $afGrid.undelegate(".afGrid-reset", "click");
                        $afGrid.undelegate(".afGrid-refresh", "click");
                    }
                    options = null;
                }

                return {
                    load: load,
                    destroy: destroy
                };
            }
        }
    });

}(jQuery));