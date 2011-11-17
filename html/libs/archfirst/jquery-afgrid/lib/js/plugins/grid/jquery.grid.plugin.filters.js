/**
 * Copyright 2011 Archfirst
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
            filters: function ($afGrid, options) {

                options = $.extend({
                    canFilter: true,
                    filterBy: null,
                    typeSearchDelay: 1500,
                    headingRowsRenderer: $.noop,
                    onFilter: $.noop
                }, options);


                var $filters;

                function onFilterChange() {
                    $afGrid.data("lastFilter", $(this).attr("id"));
                    if ($filters) {
                        if ($(this).hasClass("select-filter") && !$(this).hasClass("filter-changed")) {
                            return;
                        }

                        var filter = [];
                        $filters.find(".input-filter").each(function () {
                            var $ele = $(this);
                            if ($ele.val() !== "") {
                                filter.push({
                                    value: $ele.val(),
                                    id: $(this).attr("id").split("_")[1]
                                });
                            }
                        });
                        $filters.find(".select-filter").each(function () {
                            var $ele = $(this),
                                checkedValues = $ele.multiselect("getChecked").map(function () {
                                    return this.value;
                                }).get();
                            if (checkedValues.length) {
                                filter.push({
                                    value: checkedValues,
                                    id: $ele.attr("id").split("_")[1]
                                });
                            }
                        });

                        forEachCustomFilter($filters, function ($filter, type) {
                            var fValue = $.afGrid.filter[type].getValue($filter);
                            if (fValue) {
                                filter.push({
                                    value: fValue,
                                    id: $filter.attr("id").split("_")[1]
                                });
                            }
                        });

                        options.onFilter(filter);
                    }
                }

                function getFilters() {
                    return $filters;
                }

                function load() {

                    if (!options.canFilter) {
                        return;
                    }

                    $filters = renderFilters(options);

                    var typeSearchDelayTimer = null,
                        lastFilter;

                    $filters.find(".input-filter").bind("change.filter", onFilterChange).bind("keyup.filter", function () {
                        var ele = this;
                        window.clearTimeout(typeSearchDelayTimer);
                        typeSearchDelayTimer = window.setTimeout(function () {
                            onFilterChange.call(ele);
                            typeSearchDelayTimer = null;
                        }, options.typeSearchDelay);
                    });

                    forEachCustomFilter($filters, function ($filter, type) {
                        $.afGrid.filter[type].init($filter, onFilterChange);
                    });

                    if (options.filterBy) {
                        $.each(options.filterBy, function (i, filter) {
                            var $filter = $filters.find("#" + options.id + "Filter_" + filter.id),
                                filterValues;
                            if ($filter.length) {
                                if ($filter.hasClass("input-filter")) {
                                    $filter.val(filter.value);
                                } else if ($filter.hasClass("select-filter")) {
                                    filterValues = filter.value;
                                    $filter.find("option").each(function () {
                                        if (filterValues.indexOf($(this).val()) > -1) {
                                            $(this).attr("selected", "true");
                                        }
                                    }).multiselect("refresh");
                                } else {
                                    $.afGrid.filter[getFilterType($filter)].filterBy($filter, filter);
                                }
                            }
                        });
                    }

                    $.fn.multiselect && $filters.find(".select-filter").multiselect({
                        overrideWidth: "100%",
                        overrideMenuWidth: "200px",
                        close: onFilterChange,
                        click: onMutliSelectChange,
                        checkAll: onMutliSelectChange,
                        uncheckAll: onMutliSelectChange,
                        noneSelectedText: "&nbsp;",
                        selectedText: "Filtered",
                        selectedList: 1
                    });

                    $afGrid.find(".afGrid-head").append(getFilters());

                    lastFilter = $afGrid.data("lastFilter");
                    if (lastFilter) {
                        $afGrid.bind($.afGrid.renderingComplete, function () {
                            var $filter = $("#" + lastFilter);
                            if ($filter.hasClass("select-filter") || $filter.hasClass("input-filter")) {
                                $("#" + lastFilter).focus();
                            }
                        });
                    }
                }

                function onMutliSelectChange() {
                    $(this).addClass("filter-changed");
                }

                function destroy() {
                    $filters.find(".select-filter,.input-filter").unbind("change.filter");
                    $.fn.multiselect && $filters.find(".select-filter").multiselect("destroy");
                    forEachCustomFilter($filters, function ($filter, type) {
                        $.afGrid.filter[type].destroy($filter);
                    });
                    $filters.empty();
                    $filters = null;
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
        return options.headingRowsRenderer(options.columns, {
            container: "<div class='afGrid-filter'></div>",
            cell: "<span class='cell {columnId} {cssClass}' id='{id}'>{value}</span>",
            cellContent: function (column) {
                return {
                    value: getFilter(column.filterData, options.id + "Filter_" + column.id),
                    id: options.id + "ColFilter_" + column.id,
                    columnId: column.id,
                    cssClass: ""
                };
            }
        });
    }

    function getFilter(filterData, id) {
        var select, text, options;
        if (filterData === undefined) {
            return "";
        }
        if ($.isArray(filterData)) {
            select = "<select id={id} class='select-filter' multiple='true'>{options}</select>";
            options = [];
            $.each(filterData, function (i, value) {
                options[options.length] = "<option value='{value}'>{value}</option>".supplant({
                    value: value
                });
            });
            return select.supplant({
                id: id,
                options: options.join("")
            });
        } else if (filterData === "") {
            text = "<input id='{id}' type='text' class='input-filter'/>";
            return text.supplant({
                id: id
            });
        } else if ($.afGrid.filter[filterData]) {
            return $.afGrid.filter[filterData].render(id);
        }
        throw "Unknown filter type defined in column data.";
    }

    function forEachCustomFilter($filters, callback) {
        $.afGrid.filter && $.each($.afGrid.filter, function (key, value) {
            var $f = $filters.find("." + key + "-filter");
            $f.each(function () {
                callback($(this), key);
            });
        });
    }

    function getFilterType($filter) {
        var type = "";
        $.each($.afGrid.filter, function (key, value) {
            if ($filter.hasClass(key + "-filter")) {
                type = key;
                return false;
            }
            return true;
        });
        return type;
    }

}(jQuery));