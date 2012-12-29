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

    if ($.browser.msie && parseInt($.browser.version.slice(0, 1), 10) <= 7 && document.documentMode !== 8) {
        $("html").addClass("ie7below");
    }

    $.afGrid = $.extend($.afGrid, {
        appendRows: "afGrid-append-rows",
        destroy: "afGrid-destroy",
        renderingComplete: "afGrid-rendering-complete",
        adjustRowWidth: "afGrid-adjust-row-width",
        showLoading: "afGrid-showLoading",
        hideLoading: "afGrid-hideLoading",
        getElementId: function (id) {
            var ids = id.split("_");
            ids.splice(0, 1);
            return ids.join("_");
        }
    });

    $.afGrid.renderer = {};
    $.afGrid.filter = {};

    $.afGrid.plugin = $.afGrid.plugin || {};

    var gridPluginMap = {};

    var scrollBottomTimer;

    var TOTAL_ROW_LABEL_TEMPLATE = "<div class='total-row-count'>Showing {loadedRows} of {totalRows}</div>",
        GROUP_CONTAINER_WRAPPER_TEMPLATE = "<div class='group-data'></div>",
        HEADING_ROW_TEMPLATE = "<div class='afGrid-heading'></div>",
        HEADING_ROW_COLUMN_HELPER_TEMPLATE = "<div class='{cssClass} column-helper'></div>",
        HEADING_ROW_CONTAINER_TEMPLATE = "<div class='afGrid-head'></div>",
        HEADING_ROW_CELL_TEMPLATE = "<div class='cell {columnId} {cssClass}' id='{id}'><span class='label'>{value}</span></div>",
        GROUP_HEADING_TEMPLATE = "<div class='group level{level}'><div class='group-header'><span class='open-close-indicator'>-</span>{value}</div></div>",
        ROW_TEMPLATE = "<div class='row level{level}' id='{id}'></div>",
        CELL_TEMPLATE = "<div class='cell {columnId} {cssClass} {spacerClass}'>{value}</div>",
        ROWS_CONTAINER_TEMPLATE = "<div class='afGrid-rows'><div class='afGrid-rows-content'></div></div>",
        LOADING_MESSAGE = "<div class='loading-message'>Loading...</div>";

//    var TOTAL_ROW_LABEL_TEMPLATE = "<div class='total-row-count'>Showing {loadedRows} of {totalRows}</div>",
//        GROUP_CONTAINER_WRAPPER_TEMPLATE = "<table class='group-data'></table>",
//        HEADING_ROW_TEMPLATE = "<tr class='afGrid-heading'></tr>",
//        HEADING_ROW_COLUMN_HELPER_TEMPLATE = "<div class='{cssClass} column-helper'></div>",
//        HEADING_ROW_CONTAINER_TEMPLATE = "<thead class='afGrid-head'></thead>",
//        HEADING_ROW_CELL_TEMPLATE = "<td class='cell {cssClass}' id='{id}'>{value}<span class='sort-arrow'></span></td>",
//        GROUP_HEADING_TEMPLATE = "<tr class='group level{level}'><tboby><tr class='group-header'><table><tr><td><span class='open-close-indicator'>-</span>{value}</td></tr></table></tbody></tr>",
//        ROW_TEMPLATE = "<tr class='row level{level}' id='{id}'></tr>",
//        CELL_TEMPLATE = "<td class='cell {columnId} {cssClass}'>{value}</td>",
//        ROWS_CONTAINER_TEMPLATE = "<table class='afGrid-rows'><tbody class='afGrid-rows-content'></tbody></table>",
//        LOADING_MESSAGE = "<div class='loading-message'>Loading...</div>";

    $.fn.afGrid = function (options) {

        options = $.extend({
            id: null,
            rows: [],
            columns: [],
            rowHover: true,
            onRowClick: null,
            onScrollToBottom: $.noop,
            columnWidthOverride: null,
            makeColumnDraggable: makeColumnDraggable,
            showTotalRows: true,
            totalRowLabelTemplate: TOTAL_ROW_LABEL_TEMPLATE,
            loadingMessage: LOADING_MESSAGE
        }, options);

        var plugins = {},
            addedRows = [];

        updateColumnHashMap(options);
        updateColumnWidth(options);

        if (!(options.id && /^[a-zA-Z0-9]*$/.test(options.id))) {
            throw "You need to provide id for the afGrid and ensure that the id don't have any special characters in it.";
        }

        return this.each(function () {
            var $afGrid = $(this);
            if (!$afGrid.hasClass("afGrid-initialized")) {
                $afGrid.trigger($.afGrid.destroy);
                $afGrid = $(this);
            }
//            if (this.tagName !== "TABLE") {
//                var prop = {
//                    id:$afGrid.attr("id"),
//                    class:$afGrid.attr("class"),
//                    cellSpacing:0,
//                    cellPadding:0
//                };
//                var $table = $("<table></table>").attr(prop);
//                $afGrid.replaceWith($table);
//                $afGrid = $table;
//            }
            var cachedafGridData = {},
                $head,
                rowsAndGroup = renderRowsAndGroups(options, cachedafGridData),
                $rows = rowsAndGroup.$rowsMainContainer,
                countOfLoadedRows = options.rows.length,
                rowWidth;

            if ($afGrid.hasClass("afGrid-initialized")) {
                $rows = $afGrid.find(".afGrid-rows").empty().append($rows.children());
                rowsAndGroup.$rowsMainContainer = $rows;
                $head = $afGrid.find(".afGrid-head");
            } else {
                $head = renderHeading($afGrid, options).wrap(HEADING_ROW_CONTAINER_TEMPLATE).parent();
                $afGrid.addClass("afGrid").empty().append($head.add($rows));
                if (options.showTotalRows) {
                    $afGrid.append(options.totalRowLabelTemplate.supplant({
                        totalRows: "",
                        loadedRows: ""
                    }));
                }
                $afGrid.append(options.loadingMessage);
                $rows.bind("scroll.afGrid", function () {
                    onafGridScroll($head, $rows, options);
                    $afGrid.data("lastScrollPos", $rows[0].scrollLeft);
                });
                $afGrid.unbind($.afGrid.hideLoading).bind($.afGrid.hideLoading, function () {
                    $afGrid.find(".loading-message").hide();
                });
                $afGrid.unbind($.afGrid.showLoading).bind($.afGrid.showLoading, function () {
                    $afGrid.find(".loading-message").show();
                });
            }

            //Fix for the grid width issue
            adjustRowWidth();

            if ($rows && $rows.length) {
                $rows[0].scrollLeft = $afGrid.data("lastScrollPos");
            }

            function destroy() {
                destroyPlugins(plugins, options);
                if ($.draggable) {
                    $afGrid.find(".afGrid-heading .cell").draggable("destroy");
                }
                $head.undelegate().unbind().empty().remove();
                $head = null;
                rowsAndGroup = null;
                $rows.undelegate().unbind().remove();
                $rows = null;
                removeColumnDraggable($afGrid);
                $afGrid
                    .unbind($.afGrid.hideLoading)
                    .unbind($.afGrid.showLoading)
                    .unbind($.afGrid.adjustRowWidth)
                    .unbind($.afGrid.destroy)
                    .unbind($.afGrid.appendRows)
                    .undelegate(".group .group-header", "click")
                    .undelegate(".afGrid-rows .row", "click")
                    .undelegate(".afGrid-rows .row", "mouseenter")
                    .undelegate(".afGrid-rows .row", "mouseleave")
                    .empty();
                $afGrid.data("afGridColumnDraggable", false);
                options = null;
                $afGrid = null;
                cachedafGridData = null;
            }

            $afGrid.unbind($.afGrid.destroy).bind($.afGrid.destroy, destroy);

            //noinspection JSUnusedLocalSymbols
            function onRowAppend(event, newRows, columnWidthOverride) {
                addedRows = $.merge(addedRows, newRows);
                countOfLoadedRows += newRows.length;
                updateCountLabel($afGrid, options, countOfLoadedRows);
                options.columnWidthOverride = columnWidthOverride;
                updateColumnWidth(options);
                var $groupContainers = rowsAndGroup.lastGroupInformation.$groupContainers,
                    currentGroupValues = rowsAndGroup.lastGroupInformation.currentGroupValues,
                    $rowsMainContainer = rowsAndGroup.$rowsMainContainer,
                    isStartRowEven = $rowsMainContainer.find(".row:last").hasClass("even");
                rowsAndGroup.lastGroupInformation = addRows(options.id, newRows, options.columns, options.groupBy, $rowsMainContainer.find(".afGrid-rows-content"), $groupContainers, currentGroupValues, isStartRowEven, cachedafGridData, rowWidth);
                if ($afGrid.find(".afGrid-rows")[0].scrollHeight <= $afGrid.find(".afGrid-rows").height()) {
                    options.onScrollToBottom();
                }
            }

            $afGrid.unbind($.afGrid.appendRows).bind($.afGrid.appendRows, onRowAppend);

            function adjustRowWidth() {
                var gridRowWidth = (function () {
                    var width = 0;
                    $head.find(".afGrid-heading .cell:visible").each(function () {
                        width += $(this).outerWidth(true);
                    });
                    return width;
                }());
                $afGrid.find(".afGrid-rows-content").width(gridRowWidth).css({minHeight: 1, overflow: "hidden"});
                rowWidth = 0;
                $afGrid.find(".afGrid-heading .cell:visible").each(function () {
                    rowWidth += $(this).outerWidth();
                });
                $afGrid.find(".afGrid-rows .row").width(rowWidth);
            }

            $afGrid.unbind($.afGrid.adjustRowWidth).bind($.afGrid.adjustRowWidth, adjustRowWidth);

            if (options.rowHover) {
                $afGrid.undelegate(".afGrid-rows .row", "mouseenter").undelegate(".afGrid-rows .row", "mouseleave").delegate(".afGrid-rows .row", "mouseenter", function () {
                    $(this).addClass("row-hover");
                }).delegate(".afGrid-rows .row", "mouseleave", function () {
                    $(this).removeClass("row-hover");
                });
            }

            if (options.onRowClick) {
                $afGrid.undelegate(".afGrid-rows .row", "click").delegate(".afGrid-rows .row", "click", function () {
                    var rowId = $.afGrid.getElementId($(this).attr("id"));
                    options.onRowClick(cachedafGridData[rowId].orig || cachedafGridData[rowId], $(this));
                });
            }

            updateCountLabel($afGrid, options, countOfLoadedRows);

            var helper = {
                getColumnElementById: getColumnElementById
            };

            $.each($.afGrid.plugin, function (key, plugin) {
                if ($afGrid.hasClass("afGrid-initialized")) {
                    plugins[key] = gridPluginMap[options.id][key];
                    if (plugins[key].update) {
                        plugins[key].update(cachedafGridData);
                    }
                } else {
                    gridPluginMap[options.id] = gridPluginMap[options.id] || {};
                    gridPluginMap[options.id][key] = plugins[key] = plugin($afGrid, options, cachedafGridData);
                    plugins[key].load(helper);
                }
            });

            $afGrid.addClass("afGrid-initialized");
            $afGrid.trigger($.afGrid.renderingComplete);

        });

    };

    function destroyPlugins(plugins, options) {
        $.each(plugins, function (key, plugin) {
            if (plugin.destroy) {
                plugin.destroy();
            }
        });
        delete gridPluginMap[options.id];
    }

    function onafGridScroll($head, $rows, options) {
        var eleRow = $rows[0];
        $head.css({
            marginLeft: -1 * eleRow.scrollLeft
        });
        clearTimeout(scrollBottomTimer);
        scrollBottomTimer = setTimeout(function () {
            var scrolled = (eleRow.scrollHeight - $rows.scrollTop()),
                containerHeight = $rows.height();
            if ((scrolled <= (containerHeight - 17)) || (scrolled <= (containerHeight))) {
                options.onScrollToBottom();
            }
        }, 100);
    }

    function updateCountLabel($afGrid, options, countOfLoadedRows) {
        if (options.showTotalRows) {
            $afGrid.find(".total-row-count").replaceWith(options.totalRowLabelTemplate.supplant({
                totalRows: options.totalRows,
                loadedRows: countOfLoadedRows
            }));
        }
    }

    function updateColumnWidth(options) {
        if (options.columnWidthOverride) {
            $.each(options.columnWidthOverride, function (columnId, width) {
                options.columns[options.columnsHashMap[columnId]].width = width;
            });
        }
    }

    function updateColumnHashMap(options) {
        options.columnsHashMap = {};
        $.each(options.columns, function (i, column) {
            options.columnsHashMap[column.id] = i;
        });
    }

    function getColumnElementById(columnId, options) {
        return $("#" + options.id + "Col_" + columnId);
    }

    function makeColumnDraggable($afGrid) {
        if (!$afGrid.data("afGridColumnDraggable")) {
            if ($.fn.draggable) {
                $afGrid.find(".afGrid-heading .cell").draggable({
                    helper: function (event) {
                        return getHelper(event, $afGrid.attr("class"));
                    },
                    revert: false,
                    cancel: ".resize-handle",
                    appendTo: "body",
                    refreshPositions: true,
                    cursorAt: { top: 0, left: 0 }
                });
            }
            $afGrid.data("afGridColumnDraggable", true);
        }
    }

    function removeColumnDraggable($afGrid) {
        if ($.fn.draggable) {
            $afGrid.find(".afGrid-heading .cell").draggable("destroy");
        }
        $afGrid.removeData("afGridColumnDraggable");
    }

    function getHelper(event, cssClass) {
        return $(event.currentTarget).clone(false).wrap(HEADING_ROW_TEMPLATE).parent().wrap(HEADING_ROW_COLUMN_HELPER_TEMPLATE.supplant({
            cssClass: cssClass
        })).parent().css("width", "auto");
    }

    function renderHeading($afGrid, options) {
        return headingRowElementsRenderer($afGrid, options.columns, {
            container: HEADING_ROW_TEMPLATE,
            cell: HEADING_ROW_CELL_TEMPLATE,
            cellContent: function (column) {
                return {
                    value: column.label,
                    id: options.id + "Col_" + column.id,
                    cssClass: column.type || column.renderer || "",
                    columnId: column.id
                };
            }
        }, options.id);
    }

    function headingRowElementsRenderer($afGrid, columns, template, gridId) {
        var $row = $(template.container),
            colCount = columns.length;
        $.each(columns, function (i, column) {
            if (column.render !== false) {
                var templateData = template.cellContent(column),
                    $cell;
                templateData.cssClass = templateData.cssClass + (i === colCount - 1 ? " last" : "") + (i === 0 ? " first" : "");
                if ($.afGrid.renderer[column.type] && $.afGrid.renderer[column.type].headerCell) {
                    templateData.value = $.afGrid.renderer[column.type].headerCell($afGrid, column, columns, gridId);
                }
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

    function renderRowsAndGroups(options, cachedafGridData) {
        var $rowsMainContainer = $(ROWS_CONTAINER_TEMPLATE),
            lastGroupInformation = addRows(options.id, options.rows, options.columns, options.groupBy, $rowsMainContainer.find(".afGrid-rows-content"), null, [], false, cachedafGridData);
        return {
            $rowsMainContainer: $rowsMainContainer,
            lastGroupInformation: lastGroupInformation
        };
    }

    function getGroupContainer(n, currentValues, columns) {
        var cellContent = currentValues[n];
        var cellRenderer = (columns[n].type || columns[n].renderer);
        if (cellRenderer) {
            cellContent = $.afGrid.renderer[cellRenderer].cell(cellContent, columns[n]);
        }
        return $(GROUP_HEADING_TEMPLATE.supplant({
            value: cellContent,
            level: n
        }));
    }

    function renderGroupHeading($placeHolder, groups, level, currentValues, $groupContainers, columns) {
        var n, l, $wrapper;
        if ($groupContainers === null) {
            $groupContainers = [];
            for (n = 0, l = groups.length; n < l; n += 1) {
                $groupContainers[n] = getGroupContainer(n, currentValues, columns);
                $wrapper = $(GROUP_CONTAINER_WRAPPER_TEMPLATE);
                if (n !== 0) {
                    $wrapper.append(getCell(columns[n - 1], "", "spacer"));
                }
                $wrapper.append($groupContainers[n]);
                $placeHolder.append($wrapper);
                $placeHolder = $groupContainers[n];
            }
        } else {
            for (n = level, l = groups.length; n < l; n += 1) {
                $groupContainers[n] = getGroupContainer(n, currentValues, columns);
                $wrapper = $(GROUP_CONTAINER_WRAPPER_TEMPLATE);
                if (n === 0) {
                    $wrapper.append($groupContainers[n]);
                    $placeHolder.append($wrapper);
                } else {
                    $wrapper.append(getCell(columns[n - 1], "", "spacer"));
                    $wrapper.append($groupContainers[n]);
                    $groupContainers[n - 1].append($wrapper);
                }
            }
        }
        return $groupContainers;
    }

    function addRows(tableId, rows, columns, groups, $rowMainContainer, $groupContainers, currentGroupValues, isStartEven, cachedafGridData, rowWidth) {
        var groupsLength = groups && groups.length;
        var idPostFix = new Date().getTime() + Math.floor(Math.random() * 100);
        $.each(rows, function (i, row) {
            row.id = row.id || tableId + "Row" + (idPostFix + i);
            var rowId = row.id,
                rowData = rowId ? row.data : row,
                $rowContainer = $rowMainContainer,
                $row;
            if (rowId) {
                (cachedafGridData[rowId] = row);
            }
            if (groupsLength) {
                if ($groupContainers === null) {
                    $.each(groups, function (index) {
                        currentGroupValues[index] = rowData[index];
                    });
                    $groupContainers = renderGroupHeading($rowMainContainer, groups, null, currentGroupValues, $groupContainers, columns);
                } else {
                    $.each(groups, function (index) {
                        var x;
                        if (rowData[index] !== currentGroupValues[index]) {
                            for (x = index; x < groupsLength; x += 1) {
                                currentGroupValues[x] = rowData[x];
                            }
                            $groupContainers = renderGroupHeading($rowMainContainer, groups, index, currentGroupValues, $groupContainers, columns);
                        }
                    });
                }
                $rowContainer = $groupContainers[groupsLength - 1];
            }
            $row = getNewRow(tableId, rowId, row, groupsLength, columns);
            if ((i + (isStartEven ? 1 : 0)) % 2 === 0) {
                $row.addClass("even");
            }
            if (i === 0) {
                $row.addClass("row-first");
            }
            if (rowWidth) {
                $row.css("width", rowWidth);
            }
            $rowContainer.append($row);
        });

        return {
            $groupContainers: $groupContainers,
            currentGroupValues: currentGroupValues
        };
    }

    function getNewRow(tableId, rowId, row, groupLength, columns) {
        rowId = row.id;
        var rowData = rowId ? row.data : row,
            $row = $(ROW_TEMPLATE.supplant({
                level: groupLength,
                id: tableId + "DataRow_" + rowId
            })),
            previousColumn = columns[groupLength - 1];
        var n, l, cellContent;
        if (previousColumn) {
            $row.append(getCell(previousColumn, ""));
        }
        for (n = groupLength, l = rowData.length; n < l; n += 1) {
            cellContent = rowData[n];
            var cellRenderer = (columns[n].type || columns[n].renderer);
            if (cellRenderer) {
                cellContent = $.afGrid.renderer[cellRenderer].cell(cellContent, columns[n], n, row);
            }
            $row.append(getCell(columns[n], cellContent, null, n === (l - 1)));
        }
//        $row.data("rowData", rowData);
        return $row;
    }

    function getCell(column, value, spacerClass, isLastCell) {
        var $cell = $(CELL_TEMPLATE.supplant({
            value: value,
            columnId: column.id,
            cssClass: (column.type || column.renderer || "") + (isLastCell ? " last" : ""),
            spacerClass: spacerClass || ""
        }));
        $cell.css({
            "width": column.width,
            "display": column.isHidden ? "none" : ""
        });
        $cell.css("width", column.width);
        return $cell;
    }

}(jQuery));

if (!Array.indexOf) {
    Array.prototype.indexOf = function (obj, start) {
        "use strict";

        var i, l;
        for (i = (start || 0), l = this.length; i < l; i += 1) {
            if (this[i] === obj) {
                return i;
            }
        }
        return -1;
    };
}

if (!String.hasOwnProperty("supplant")) {
    String.prototype.supplant = function (jsonObject, keyPrefix) {
        "use strict";

        return this.replace(/\{([^{}]*)\}/g, function (matchedString, capturedString1) {
            var jsonPropertyKey = keyPrefix ? capturedString1.replace(keyPrefix + ".", "") : capturedString1,
                jsonPropertyValue = jsonObject[jsonPropertyKey];
            return jsonPropertyValue !== undefined ? jsonPropertyValue : matchedString;
        });
    };
}