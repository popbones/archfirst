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

    var START_SCROLL_PROXIMITY = 100;

    var DIRECTION = {
        LEFT: "LEFT",
        RIGHT: "RIGHT"
    };

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            columnReorder: function ($afGrid, options) {

                var gridWidth, gridLeftOffset, $rowsContainer, $headingContainer;
                var direction = DIRECTION.RIGHT;

                options = $.extend({
                    isGridColumnReorderable: true,
                    onColumnReorder: $.noop
                }, options);

                function onColumnReorderDrop(event, ui) {
                    onColumnReordered(event, ui, options, $afGrid, direction);
                }

                function onReorderOver(event) {
                    onColumnReorderOver($(event.target), direction);
                }

                function load() {
                    if (!options.isGridColumnReorderable) {
                        return;
                    }
                    gridLeftOffset = $afGrid.offset().left;
                    gridWidth = $afGrid.width();
                    $rowsContainer = $afGrid.find(".afGrid-rows");
                    $headingContainer = $afGrid.find(".afGrid-heading");
                    var cellSelector = ".afGrid-heading .cell";
                    var scrollInterval, scrollLeftBy;

                    $afGrid.delegate(cellSelector, "dragstop", function () {
                        $afGrid.undelegate(".afGrid-heading .cell", "mouseout.reorder");
                        $afGrid.undelegate(".afGrid-heading .cell", "mousemove.reorder");
                        window.clearInterval(scrollInterval);
                    });

                    $afGrid.delegate(cellSelector, "dragstart", function (e) {
                        window.clearInterval(scrollInterval);
                        var currentTarget = e.currentTarget;
                        $afGrid.delegate(".afGrid-heading .cell", "mousemove.reorder", function (e) {
                            if (e.currentTarget.id !== currentTarget.id) {
                                direction = (e.clientX < ($(this).offset().left + ($(this).width() / 2))) ? DIRECTION.LEFT : DIRECTION.RIGHT;
                                onColumnReorderOver($(this), direction);
                            }
                        });
                        $afGrid.delegate(".afGrid-heading .cell", "mouseout.reorder", function () {
                            $(this).removeClass("reorder-left reorder-right");
                        });
                    });


                    $afGrid.delegate(cellSelector, "drag", function (event) {
                        if (event.clientX > (gridLeftOffset - START_SCROLL_PROXIMITY) && event.clientX < (gridLeftOffset + START_SCROLL_PROXIMITY)) {
                            window.clearInterval(scrollInterval);
                            scrollLeftBy = $rowsContainer[0].scrollLeft;
                            scrollInterval = window.setInterval(function () {
                                if ($rowsContainer[0].scrollLeft > 0) {
                                    $rowsContainer[0].scrollLeft -= 10;
                                }
                            }, 50);
                        } else if (event.clientX > (gridLeftOffset + gridWidth - START_SCROLL_PROXIMITY) && event.clientX < (gridLeftOffset + gridWidth + START_SCROLL_PROXIMITY)) {
                            window.clearInterval(scrollInterval);
                            scrollLeftBy = $rowsContainer[0].scrollLeft + $headingContainer.width() + 100;
                            scrollInterval = window.setInterval(function () {
                                if ($rowsContainer[0].scrollLeft < scrollLeftBy) {
                                    $rowsContainer[0].scrollLeft += 10;
                                }
                            }, 50);
                        } else {
                            window.clearInterval(scrollInterval);
                        }
                    });

                    if ($.fn.droppable) {
                        $afGrid.find(cellSelector).droppable({
                            drop: onColumnReorderDrop,
                            over: onReorderOver,
                            out: onColumnReorderOut,
                            accept: cellSelector,
                            tolerance: "pointer"
                        });
                    }

                    options.makeColumnDraggable($afGrid);
                }

                function update() {
                    gridLeftOffset = $afGrid.offset().left;
                    gridWidth = $afGrid.width();
                    $rowsContainer = $afGrid.find(".afGrid-rows");
                    $headingContainer = $afGrid.find(".afGrid-heading");
                }

                function destroy() {
                    options = null;
                    if ($.fn.droppable) {
                        $afGrid.find(".afGrid-heading .cell").droppable("destroy");
                    }
                    $afGrid.undelegate(".afGrid-heading .cell", "drag");
                    $afGrid.undelegate(".afGrid-heading .cell", "dragstop");
                    $rowsContainer = null;
                    $headingContainer = null;
                }

                return {
                    load: load,
                    update: update,
                    destroy: destroy
                };
            }
        }
    });

    function onColumnReordered(event, ui, options, $afGrid, direction) {
        var $ele = $(event.target);
        $ele.removeClass("reorder-left reorder-right");
        var columnIdToMove = $.afGrid.getElementId(ui.draggable.attr("id")),
            columnIdToMoveAfter = $.afGrid.getElementId($ele.attr("id")),
            newColumnOrder = [];
        $.each(options.columns, function (i, column) {
            if (column.id !== columnIdToMove) {
                newColumnOrder.push(column.id);
            }
            if (column.id === columnIdToMoveAfter) {
                if (direction === DIRECTION.RIGHT) {
                    newColumnOrder.push(columnIdToMove);
                } else {
                    newColumnOrder.splice((newColumnOrder.length - 1), 0, columnIdToMove);
                }
            }
        });
        $afGrid.removeClass("afGrid-initialized");
        options.onColumnReorder(newColumnOrder);
    }

    function onColumnReorderOver($ele, direction) {
        $ele.removeClass("reorder-left reorder-right").addClass(direction === DIRECTION.LEFT ? "reorder-left" : "reorder-right");
    }

    function onColumnReorderOut(event) {
        $(event.target).removeClass("reorder-left reorder-right");
    }

}(jQuery));