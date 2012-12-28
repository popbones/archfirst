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

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            columnResize: function ($afGrid, options) {
                options = $.extend({
                    isGridColumnResizable: true,
                    onColumnResize: $.noop,
                    minColumnWidth: 30,
                    maxColumnWidth: 700
                }, options);

                var columns = options.columns;

                function load(helper) {
                    if (!options.isGridColumnResizable) {
                        return;
                    }

                    $.each(options.columns, function (index, column) {
                        if (column.isResizable !== false) {
                            helper.getColumnElementById(column.id, options)
                                .append("<span class='resize-handle'></span>")
                                .addClass("resizable-column");
                        }
                    });


                    var $headingRow = $afGrid.find(".afGrid-heading");

                    undelegateEvents();

                    $headingRow.delegate(".resize-handle", "click", function () {
                        return false;
                    });

                    $headingRow.delegate(".resize-handle", "mousedown", function () {
                        var $cell = $(this).parents(".cell").eq(0);
                        var $resizeHandle = $(this);
                        var columnId = $.afGrid.getElementId($cell.attr("id")),
                            posX,
                            originalWidth,
                            $guide,
                            newWidth;
                        $guide = $("<div class='resize-guide'></div>");
                        $guide.css({
                            height: $afGrid.height(),
                            top: 0,
                            left: $resizeHandle.offset().left - $afGrid.offset().left + $resizeHandle.width()
                        });
                        $afGrid.append($guide);
                        originalWidth = $cell.width();
                        posX = event.screenX;

                        $(document).bind("mousemove.afGridResizeGuide", function (event) {
                            newWidth = originalWidth + (event.screenX - posX);
                            if (newWidth <= options.minColumnWidth) {
                                newWidth = options.minColumnWidth;
                            } else if (newWidth >= options.maxColumnWidth) {
                                newWidth = options.maxColumnWidth;
                            }
                            $guide.css({
                                left: $resizeHandle.offset().left - $afGrid.offset().left + $resizeHandle.width()
                            });
                            $cell.width(newWidth);
                            options.columns[options.columnsHashMap[columnId]].width = newWidth;
                            return false;
                        });

                        $(document).bind("mouseup.afGridResizeGuide", function () {
                            $(document).unbind("mousemove.afGridResizeGuide mouseup.afGridResizeGuide");
                            $guide.unbind();
                            $guide.remove();
                            posX = null;
                            $afGrid.find(".afGrid-rows ." + columnId).width(newWidth);
                            $afGrid.find(".afGrid-filter ." + columnId).width(newWidth);
                            options.onColumnResize(columnId, originalWidth, newWidth);
                            $afGrid.trigger($.afGrid.adjustRowWidth);
                            return false;
                        });
                        return false;
                    });

                }


                function undelegateEvents() {
                    var $headingRow = $afGrid.find(".afGrid-heading");
                    $headingRow.undelegate(".resize-handle", "mousedown");
                    $headingRow.undelegate(".resize-handle", "click");
                }

                function destroy() {
                    undelegateEvents();
                    columns = null;
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