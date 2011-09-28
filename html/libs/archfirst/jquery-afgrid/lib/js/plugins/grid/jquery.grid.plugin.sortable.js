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

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            sortable: function ($afGrid, options) {

                options = $.extend({
                    canSort: true,
                    sortBy: null,
                    onSort: $.noop
                }, options);

                var SortDirection = {
                    ASC: "asc",
                    DESC: "desc"
                };

                function onColumnSort() {
                    var $cell = $(this),
						columnId = this.id.split("_")[1],
						direction;
                    
					$afGrid.find(".afGrid-heading .cell.sortable-column").not($cell).removeClass("asc desc").removeData("direction");
                    direction = $cell.data("direction");
                    if (!direction) {
                        direction = SortDirection.ASC;
                    } else if (direction === SortDirection.ASC) {
                        direction = SortDirection.DESC;
                    } else {
                        direction = SortDirection.ASC;
                    }
                    $cell.data("direction", direction);
                    $cell.removeClass("asc desc").addClass(direction);
                    options.onSort(columnId, direction);
                }

                function load() {
                    if (!options.canSort) {
                        return;
                    }

                    if (options.sortBy) {
                        var $column = $afGrid.find("#" + options.id + "Col_" + options.sortBy.column);
                        $column.addClass(options.sortBy.direction);
                        $column.data("direction", options.sortBy.direction);
                    }

                    $.each(options.columns, function (index, column) {
                        if (column.sortable !== false) {
                            $afGrid.find("#" + options.id + "Col_" + column.id).addClass("sortable-column");
                        }
                    });

                    $afGrid.undelegate(".afGrid-heading .cell.sortable-column", "click").delegate(".afGrid-heading .cell.sortable-column", "click", onColumnSort);
                    $afGrid.undelegate(".afGrid-heading .cell.sortable-column", "mouseenter").delegate(".afGrid-heading .cell.sortable-column", "mouseenter", function () {
                        $(this).addClass("sort-hover");
                    });
                    $afGrid.undelegate(".afGrid-heading .cell.sortable-column", "mouseleave").delegate(".afGrid-heading .cell", "mouseleave", function () {
                        $(this).removeClass("sort-hover");
                    });
                }

                function destroy() {
                    $afGrid.undelegate(".afGrid-heading .cell.sortable-column", "click");
                    $afGrid.undelegate(".afGrid-heading .cell.sortable-column", "mouseleave");
                    $afGrid.undelegate(".afGrid-heading .cell.sortable-column", "mouseenter");
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