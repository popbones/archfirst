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

    var filtersContainer = {};

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            filters: function ($afGrid, options) {

                options = $.extend({
                    isGridFilterable: true,
                    filterBy: null,
                    onFilter: $.noop
                }, options);

                var $filters;

                function onFilterChange() {
                    if ($filters) {
                        var filter = [];

                        forEachFilter($filters, function ($filter, type) {
                            var fValue = $.afGrid.filter[type].getValue($filter);
                            if (fValue) {
                                fValue.id = $.afGrid.getElementId($filter.attr("id"));
                                fValue.valueType = fValue.valueType || type;
                                filter.push(fValue);
                            }
                        });
                        if (filter && filter.length) {
                            $filters.addClass("filtered");
                        } else {
                            $filters.removeClass("filtered");
                        }
                        $afGrid.find(".afGrid-rows")[0].scrollTop = 0;
                        options.onFilter(filter);
                    }
                }

                function getFilters() {
                    return $filters;
                }

                function load() {
                    if (!options.isGridFilterable || !(options.filters && options.filters.length)) {
                        return;
                    }

                    $filters = renderFilters(options);

                    filtersContainer[options.id] = $filters;

                    forEachFilter($filters, function ($filter, type) {
                        $filter.addClass("afGrid-filter-control");
                        $.afGrid.filter[type].init($filter, onFilterChange, options.id, $afGrid);
                    });

                    if (options.filterBy && options.filterBy.length) {
                        $.each(options.filterBy, function (i, filter) {
                            var $filter = $filters.find("#" + options.id + "Filter_" + filter.id);
                            if ($filter.length) {
                                $.afGrid.filter[getFilterType($filter)].filterBy($filter, filter);
                            }
                        });
                        $filters.addClass("filtered");
                    } else {
                        $filters.removeClass("filtered");
                    }

                    $afGrid.find(".afGrid-head").append(getFilters());
                }

                function destroy() {
                    delete filtersContainer[options.id];
                    if ($filters) {
                        forEachFilter($filters, function ($filter, type) {
                            $.afGrid.filter[type].destroy($filter, $afGrid);
                        });
                        $filters.empty();
                        $filters = null;
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

    function renderFilters(options) {
        return headingRowElementsRenderer(options.columns, {
            container: "<div class='afGrid-filter'></div>",
            cell: "<span class='cell {columnId} {cssClass}' id='{id}'>{value}</span>",
            cellContent: function (column) {
                return {
                    value: getFilter(column.filterType, column.filterData, options.id + "Filter_" + column.id),
                    id: options.id + "ColFilter_" + column.id,
                    columnId: column.id,
                    cssClass: ""
                };
            }
        });
    }

    function headingRowElementsRenderer(columns, template) {
        var $row = $(template.container),
            colCount = columns.length;
        $.each(columns, function (i, column) {
            if (column.render !== false) {
                var templateData = template.cellContent(column),
                    $cell;
                templateData.cssClass = templateData.cssClass + (i === colCount - 1 ? " last" : "") + (i === 0 ? " first" : "");
                $cell = $(template.cell.supplant(templateData));
                $cell.css({
                    width: column.width,
                    display: column.isHidden ? "none" : ""
                });
                $row.append($cell);
            }
        });
        return $row;
    }

    function getFilter(filterType, filterData, id) {
        if (filterType === undefined) {
            return "";
        } else if ($.afGrid.filter[filterType]) {
            return $.afGrid.filter[filterType].render(id, filterData).supplant({
                filterIdentifier: filterType + "-filter"
            });
        }
        throw "Unknown filter type defined in column data.";
    }

    function forEachFilter($filters, callback) {
        if ($.afGrid.filter) {
            $.each($.afGrid.filter, function (key) {
                var $f = $filters.find("." + key + "-filter");
                $f.each(function () {
                    callback($(this), key);
                });
            });
        }
    }

    function getFilterType($filter) {
        var type = "";
        $.each($.afGrid.filter, function (key) {
            if ($filter.hasClass(key + "-filter")) {
                type = key;
                return false;
            }
            return true;
        });
        return type;
    }

}(jQuery));