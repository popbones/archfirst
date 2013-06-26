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

    $.afGrid.updateRow = "afGrid-update-row";

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            realTimeData: function ($afGrid, options, cachedGridData) {

                options = $.extend({
                    isLive: true
                }, options);

                function load(helper) {
                    if (!options.isLive) {
                        return;
                    }

                    //noinspection JSUnusedLocalSymbols
                    function onRowUpdate(event, row) {
                        $.each(row, function(key, value) {
                            var column = helper.getColumnById(key, options.columns);
                            if (column) {
                                var $cell = helper.getRowElementById(row.id, options).find("."+key);
                                if (column.type === "NUMERIC") {
                                    var oldValue = cachedGridData[row.id].orig[key];
                                    if (value>oldValue) {
                                        $cell.removeClass("negative").addClass("updated-cell positive");
                                    } else if (value<oldValue) {
                                        $cell.removeClass("positive").addClass("updated-cell negative");
                                    }
                                    cachedGridData[row.id].orig[key] = value;
                                }
                                $cell.html(helper.getCellContent(value, column));
                                window.setTimeout(function() {
                                    $cell.removeClass("updated-cell");
                                    $cell = null;
                                }, 2000);
                            }
                        });
                    }

                    $afGrid.unbind($.afGrid.updateRow).bind($.afGrid.updateRow, onRowUpdate);

                }

                function destroy() {
                    $afGrid.unbind($.afGrid.updateRow);
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