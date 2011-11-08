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

    $.afGrid = $.extend($.afGrid, {
        appendRows: "afGrid-append-rows",
        destroy: "afGrid-destroy",
        renderingComplete: "afGrid-rendering-complete"
    });

    $.afGrid.plugin = $.afGrid.plugin || {};

    $.fn.afGrid = function (options) {

        options = $.extend({
            id: null,
            rows: [],
            columns: [],
            canRowHover: true,
            canRowClick: true,
            onRowClick: $.noop,
            onScrollToBottom: $.noop,
            columnWidthOverride: null,
            headingRowsRenderer: renderHeadingRow,
            makeColumnDraggable: makeColumnDraggable,
            showTotalRows: true,
            totalRowLabelTemplate: "<div class='total-row-count'>Showing {loadedRows} of {totalRows}</div>"
        }, options);

        options.columnsHashMap = {};
        $.each(options.columns, function (i, column) {
            options.columnsHashMap[column.id] = i;
        });

        if (options.columnWidthOverride) {
            $.each(options.columnWidthOverride, function (columnId, width) {
                options.columns[options.columnsHashMap[columnId]].width = width;
            });
        }

        var plugins = {},
            addedRows = [];

        if (!options.id) {
            throw "You need to provide id for the afGrid";
        }

        return this.each(function () {
            var cachedafGridData = {},
                $afGrid = $(this),
                $head = renderHeading(options).wrap("<div class='afGrid-head'></div>").parent(),
                rowsAndGroup = renderRowsAndGroups(options, cachedafGridData),
                $rows = rowsAndGroup.$rowsMainContainer,
                $headingRows = $head,
                $afGridRows = $headingRows.add($rows),
                countOfLoadedRows = options.rows.length,
                scrollBottomTimer;

            $afGrid.addClass("afGrid").empty().append($afGridRows);

            if (options.showTotalRows) {
                $afGrid.append(options.totalRowLabelTemplate.supplant({
                    totalRows: "",
                    loadedRows: ""
                }));
            }

            function onafGridScroll() {
                $headingRows.css({
                    marginLeft: -1 * this.scrollLeft
                });
                clearTimeout(scrollBottomTimer);
                scrollBottomTimer = setTimeout(function () {
                    var scrolled = ($rows[0].scrollHeight - $rows.scrollTop()),
                        containerHeight = $rows.outerHeight();
                    if ((scrolled <= (containerHeight - 17)) || (scrolled <= (containerHeight))) {
                        options.onScrollToBottom();
                    }
                }, 100);
            }
            $rows.bind("scroll.afGrid", onafGridScroll);

            function destroy() {
                $.each(plugins, function (key, plugin) {
                    plugin.destroy();
                });
                if ($.draggable) {
                    $afGrid.find(".afGrid-heading .cell").draggable("destroy");
                }
                $head.undelegate().unbind().empty().remove();
                $head = null;
                rowsAndGroup = null;
                $rows.undelegate().unbind().remove();
                $rows = null;
                $afGrid.unbind($.afGrid.destroy).unbind($.afGrid.appendRows).undelegate(".group .group-header", "click");
                $afGrid.undelegate(".afGrid-rows .row", "click").undelegate(".afGrid-rows .row", "mouseenter").undelegate(".afGrid-rows .row", "mouseleave").empty();
                options = null;
                $afGrid = null;
                cachedafGridData = null;
            }
            $afGrid.bind($.afGrid.destroy, destroy);

            function onRowAppend(event, newRows) {
                addedRows = $.merge(addedRows, newRows);
                countOfLoadedRows += newRows.length;
                updateCountLabel();
                var totalRows = $afGrid.find(".afGrid-rows .row").length,
                    $groupContainers = rowsAndGroup.lastGroupInformation.$groupContainers,
                    currentGroupValues = rowsAndGroup.lastGroupInformation.currentGroupValues,
                    $rowsMainContainer = rowsAndGroup.$rowsMainContainer,
                    isStartRowEven = $rowsMainContainer.find(".row:last").hasClass("even");
                rowsAndGroup.lastGroupInformation = addRows(options.id, newRows, options.columns, options.groupBy, $rowsMainContainer, $groupContainers, currentGroupValues, isStartRowEven, cachedafGridData);
            }
            $afGrid.unbind($.afGrid.appendRows).bind($.afGrid.appendRows, onRowAppend);

            function updateCountLabel() {
                if (options.showTotalRows) {
                    $afGrid.find(".total-row-count").replaceWith(options.totalRowLabelTemplate.supplant({
                        totalRows: options.totalRows,
                        loadedRows: countOfLoadedRows
                    }));
                }
            }

            if (options.canRowHover) {
                $afGrid.undelegate(".afGrid-rows .row", "mouseenter").undelegate(".afGrid-rows .row", "mouseleave").delegate(".afGrid-rows .row", "mouseenter", function () {
                    $(this).addClass("row-hover");
                }).delegate(".afGrid-rows .row", "mouseleave", function () {
                    $(this).removeClass("row-hover");
                });
            }

            if (options.canRowClick) {
                $afGrid.undelegate(".afGrid-rows .row", "click").delegate(".afGrid-rows .row", "click", function () {
                    var rowId = $(this).attr("id").split("_")[1];
                    options.onRowClick(rowId, cachedafGridData[rowId]);
                });
            }

            updateCountLabel();

            $.each($.afGrid.plugin, function (key, plugin) {
                plugins[key] = plugin($afGrid, options, cachedafGridData);
                plugins[key].load();
            });

            $afGrid.trigger($.afGrid.renderingComplete);
        });

    };

    function makeColumnDraggable($afGrid) {
        $.fn.draggable && $afGrid.find(".afGrid-heading .cell").draggable({
            helper: function (event) {
                return getHelper(event, $afGrid.attr("class"));
            },
            revert: false,
            cancel: ".resize-handle",
            appendTo: "body"
        });
    }

    function getHelper(event, cssClass) {
        return $(event.currentTarget).clone(false).wrap("<div class='afGrid-heading'></div>").parent().wrap("<div class='{cssClass} column-helper'></div>".supplant({
            cssClass: cssClass
        })).parent().css("width", "auto");
    }

    function renderHeading(options) {
        return renderHeadingRow(options.columns, {
            container: "<div class='afGrid-heading'></div>",
            cell: "<span class='cell {cssClass}' id='{id}'>{value}<span class='sort-arrow'></span></span>",
            cellContent: function (column) {
                return {
                    value: column.label,
                    id: options.id + "Col_" + column.id,
                    cssClass: column.renderer || ""
                };
            }
        });
    }

    function renderHeadingRow(columns, template) {
        var $row = $(template.container),
            colCount = columns.length;
        $.each(columns, function (i, column) {
            if (column.render !== false) {
                var templateData = template.cellContent(column),
                    $cell;
                templateData.cssClass = templateData.cssClass + (column.groupBy ? " groupBy" : "") + (i === colCount - 1 ? " last" : "") + (i === 0 ? " first" : "");
                $cell = $(template.cell.supplant(templateData));
                $cell.css({
                    width: column.width
                });
                $row.append($cell);
            }
        });
        return $row;
    }

    function renderRowsAndGroups(options, cachedafGridData) {
        var $rowsMainContainer = $("<div class='afGrid-rows'></div>"),
            lastGroupInformation = addRows(options.id, options.rows, options.columns, options.groupBy, $rowsMainContainer, null, [], false, cachedafGridData);
        return {
            $rowsMainContainer: $rowsMainContainer,
            lastGroupInformation: lastGroupInformation
        };
    }

    function getGroupContainer(n, currentValues, columns) {
        var cellContent = currentValues[n];
        if (columns[n].renderer) {
            cellContent = $.afGrid.renderer[columns[n].renderer](cellContent);
        }
        return $("<div class='group level{level}'><div class='group-header'><span class='open-close-indicator'>-</span>{value}</div></div>".supplant({
            value: cellContent,
            level: n
        }));
    }

    function renderGroupHeading($placeHolder, groups, level, currentValues, $groupContainers, columns) {
        var n, l, cellContent, $wrapper;
        if ($groupContainers === null) {
            $groupContainers = [];
            for (n = 0, l = groups.length; n < l; n += 1) {
                $groupContainers[n] = getGroupContainer(n, currentValues, columns);
                $wrapper = $("<div></div>");
                if (n !== 0) {
                    $wrapper.append(getCell(columns[n - 1], ""));
                }
                $wrapper.append($groupContainers[n]);
                $placeHolder.append($wrapper);
                $placeHolder = $groupContainers[n];
            }
        } else {
            for (n = level, l = groups.length; n < l; n += 1) {
                $groupContainers[n] = getGroupContainer(n, currentValues, columns);
                $wrapper = $("<div></div>");
                if (n === 0) {
                    $wrapper.append($groupContainers[n]);
                    $placeHolder.append($wrapper);
                } else {
                    $wrapper.append(getCell(columns[n - 1], ""));
                    $wrapper.append($groupContainers[n]);
                    $groupContainers[n - 1].append($wrapper);
                }
            }
        }
        return $groupContainers;
    }

    function addRows(tableId, rows, columns, groups, $rowMainContainer, $groupContainers, currentGroupValues, isStartEven, afGridData) {
        var groupsLength = groups && groups.length;
        $.each(rows, function (i, row) {
            var rowId = row.id,
                rowData = rowId ? row.data : row,
                $rowContainer = $rowMainContainer,
                $row;
            if (rowId) {
                (afGridData[rowId] = row);
            }
            if (groups && groupsLength) {
                if ($groupContainers === null) {
                    $.each(groups, function (index, v) {
                        currentGroupValues[index] = rowData[index];
                    });
                    $groupContainers = renderGroupHeading($rowMainContainer, groups, null, currentGroupValues, $groupContainers, columns);
                } else {
                    $.each(groups, function (index, v) {
                        if (rowData[index] !== currentGroupValues[index]) {
                            for (var x = index; x < groupsLength; x += 1) {
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
            $row = $("<div class='row level{level}' id='{id}'></div>".supplant({
                level: groupLength,
                id: tableId + "DataRow_" + rowId
            })),
            previousColumn = columns[groupLength - 1],
            n, l, cellContent;
        if (previousColumn) {
            $row.append(getCell(previousColumn, ""));
        }
        for (n = groupLength, l = rowData.length; n < l; n += 1) {
            cellContent = rowData[n];
            if (columns[n].renderer) {
                cellContent = $.afGrid.renderer[columns[n].renderer](cellContent, columns[n], n, row);
            }
            $row.append(getCell(columns[n], cellContent));
        }
        $row.data("rowData", rowData);
        return $row;
    }

    function getCell(column, value) {
        var $cell = $("<span class='cell {columnId} {cssClass}'>{value}</span>".supplant({
            value: value,
            columnId: column.id,
            cssClass: column.renderer || ""
        }));
        $cell.css("width", column.width);
        return $cell;
    }

}(jQuery));

if (!Array.indexOf) {
    Array.prototype.indexOf = function (obj, start) {
        for (var i = (start || 0); i < this.length; i += 1) {
            if (this[i] === obj) {
                return i;
            }
        }
        return -1;
    };
}

if (!String.hasOwnProperty("supplant")) {
    String.prototype.supplant = function (jsonObject, keyPrefix) {
        return this.replace(/\{([^{}]*)\}/g, function (matchedString, capturedString1) {
            var jsonPropertyKey = keyPrefix ? capturedString1.replace(keyPrefix + ".", "") : capturedString1,
                jsonPropertyValue = jsonObject[jsonPropertyKey];
            return jsonPropertyValue !== undefined ? jsonPropertyValue : matchedString;
        });
    };
}