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

    window.AF = window.AF || {};
    AF.Grid = function (options) {

	var defaultOptions = {
            id: null,
            dataSource: null,
            statePersist: $.statePersistToCookie,
            canGroup: true,
            groupsPlaceHolder: "." + options.id + "-afGrid-group-by",
            columnWidthOverride: null,
			rowsToLoad: 20,
            afGridSelector: "#" + options.id,
            onRowClick: onRowClick,
			onSort: onSortBy,
            onGroupChange: onGroupBy,
			onGroupReorder: onGroupReorder,
            onFilter: onFilterBy,
            onColumnReorder: onColumnReorder,
            onColumnResize: onColumnResize,
            onScrollToBottom: fetchRowsIncrementally
        };
	
        options = $.extend(true, {}, defaultOptions, options);
        
        var $afGrid;
        
        var store = options.dataSource,
			loadedRows = 0,
            totalRows = 0,
			rowsToLoad = 0,
            columnData = null,
            afGridCurrentStateData = {};
        
        function render(data) {
			columnData = data.columns;
			totalRows = data.totalRows;
			loadedRows = data.rows.length;
			rowsToLoad = data.rowsToLoad || options.rowsToLoad;
			data.columnWidthOverride = afGridCurrentStateData.columnWidthOverride;
			renderData(data);
			afGridCurrentStateData.columnOrder = $.map(data.columns, function (column) {
				return column.id;
			});
			saveStateOfCurrentGrid();
        }

        function saveStateOfCurrentGrid() {
            if (options.statePersist) {
                options.statePersist.save("afGridState_" + options.id, JSON.stringify(afGridCurrentStateData));
            }
        }

        function getCurrentState(callback) {
            if (options.statePersist) {
                options.statePersist.load("afGridState_" + options.id, function (data) {
                    callback(JSON.parse(data));
                });
            } else {
				callback({});
			}
        }

        function fetchRowsIncrementally() {
            //This can be fetched from the serve
            if (loadedRows + 1 >= totalRows) {
                return;
            }
            var requestData = $.extend({}, afGridCurrentStateData, {
                loadFrom: loadedRows + 1,
                count: rowsToLoad
            });
			store.fetchRows(requestData, onReceiveOfNewRows);
        }

        function onReceiveOfNewRows(newRows) {
            loadedRows += newRows.rows.length;
            addNewRows(newRows);
        }

        function onReceiveOfData(data) {
            render(data);
        }

        function onFilterBy(filters) {
            //converting filters json to a format that will be easier to post and retrieve, to and from the server 
            afGridCurrentStateData.filterColumns = [];
            afGridCurrentStateData.filterValues = [];
            $.each(filters, function (i, filter) {
                afGridCurrentStateData.filterColumns.push(filter.id);
                afGridCurrentStateData.filterValues.push(filter.value);
            });
            store.filter(afGridCurrentStateData, render);
        }

        function onGroupBy(columnIds) {
            var newColumnOrder, requestData;
            if (afGridCurrentStateData.columnOrder) {
                newColumnOrder = [];
                $.each(columnIds, function (i, value) {
                    newColumnOrder.push(value);
                });
                $.each(afGridCurrentStateData.columnOrder, function (i, value) {
                    if (newColumnOrder.indexOf(value) < 0) {
                        newColumnOrder.push(value);
                    }
                });
                afGridCurrentStateData.columnOrder = newColumnOrder;
            }
            afGridCurrentStateData.groupByColumns = columnIds.length ? columnIds : [];
            store.groupBy(afGridCurrentStateData, render);
        }

        function onSortBy(columnId, direction) {
            afGridCurrentStateData.sortByColumn = columnId;
            afGridCurrentStateData.sortByDirection = direction;
			store.sortBy(afGridCurrentStateData, render);
        }

        function onColumnReorder(newColumnOrder) {
            var groupByColumnsLength, newGroupByColumns, n, foundColumn, requestData;

            if (afGridCurrentStateData.groupByColumns) {
                groupByColumnsLength = afGridCurrentStateData.groupByColumns.length;
                newGroupByColumns = [];
                for (n = 0; n < groupByColumnsLength; n += 1) {
                    foundColumn = getColumnById(newColumnOrder[n]);
                    if (foundColumn.column.groupBy) {
                        newGroupByColumns.push(newColumnOrder[n]);
                    } else {
                        break;
                    }
                }
                afGridCurrentStateData.groupByColumns = newGroupByColumns;
            }
			afGridCurrentStateData.columnOrder = newColumnOrder;
			store.reorderColumn(afGridCurrentStateData, render);
        }

        function getColumnById(columnId) {
            var foundIndex = -1,
                column = $.grep(columnData, function (column, index) {
                    if (column.id === columnId) {
                        foundIndex = index;
                        return true;
                    }
                    return false;
                })[0];
            return {
                column: column,
                index: foundIndex
            };
        }

        function onGroupReorder(newGroupOrder) {
            onGroupBy(newGroupOrder);
        }

        function onRowClick(rowId, rowData) {
            alert("Row id received: " + rowId + " Row data: " + JSON.stringify(rowData));
        }

        function onColumnResize(columnId, oldWidth, newWidth) {
            afGridCurrentStateData.columnWidthOverride = afGridCurrentStateData.columnWidthOverride || {};
            afGridCurrentStateData.columnWidthOverride[columnId] = newWidth;
            saveStateOfCurrentGrid();
        }

        function load() {
            getCurrentState(function (currentStateData) {
                afGridCurrentStateData = currentStateData || {};
		store.load(afGridCurrentStateData, onReceiveOfData);
            });
        }

        function renderData(data) {
            var afGridData = $.extend(options, data);
            $afGrid = $(options.afGridSelector);
	    $afGrid.afGrid(afGridData);
	}

        function addNewRows(newData) {
            $afGrid.trigger($.afGrid.appendRows, [newData.rows, afGridCurrentStateData.columnWidthOverride]);
        }

	function getDefaultOptions() {
	    return defaultOptions;    
	}
	
        return {
            load: load,
	    getDefaultOptions: getDefaultOptions
        };
    };
    
}(jQuery));/**
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

    $.afGrid = $.extend($.afGrid, {
        appendRows: "afGrid-append-rows",
        destroy: "afGrid-destroy",
        renderingComplete: "afGrid-rendering-complete",
        adjustRowWidth: "afGrid-adjust-row-width"
    });

    $.afGrid.plugin = $.afGrid.plugin || {};

    var scrollBottomTimer;

    var TOTAL_ROW_LABEL_TEMPLATE = "<div class='total-row-count'>Showing {loadedRows} of {totalRows}</div>",
        GROUP_CONTAINER_WRAPPER_TEMPLATE = "<div></div>",
        HEADING_ROW_TEMPLATE = "<div class='afGrid-heading'></div>",
        HEADING_ROW_COLUMN_HELPER_TEMPLATE = "<div class='{cssClass} column-helper'></div>",
        HEADING_ROW_CONTAINER_TEMPLATE = "<div class='afGrid-head'></div>",
        HEADING_ROW_CELL_TEMPLATE = "<div class='cell {cssClass}' id='{id}'>{value}<span class='sort-arrow'></span></div>",
        GROUP_HEADING_TEMPLATE = "<div class='group level{level}'><div class='group-header'><span class='open-close-indicator'>-</span>{value}</div></div>",
        ROW_TEMPLATE = "<div class='row level{level}' id='{id}'></div>",
        CELL_TEMPLATE = "<div class='cell {columnId} {cssClass}'>{value}</div>",
        ROWS_CONTAINER_TEMPLATE = "<div class='afGrid-rows'></div>";
    
    //var TOTAL_ROW_LABEL_TEMPLATE = "<div class='total-row-count'>Showing {loadedRows} of {totalRows}</div>",
    //    GROUP_CONTAINER_WRAPPER_TEMPLATE = "<table><tbody><tr></tr><tbody></table>",
    //    HEADING_ROW_TEMPLATE = "<tr class='afGrid-heading'></tr>",
    //    HEADING_ROW_COLUMN_HELPER_TEMPLATE = "<div class='{cssClass} column-helper'></div>",
    //    HEADING_ROW_CONTAINER_TEMPLATE = "<thead class='afGrid-head'></thead>",
    //    HEADING_ROW_CELL_TEMPLATE = "<td class='cell {cssClass}' id='{id}'>{value}<span class='sort-arrow'></span></td>",
    //    GROUP_HEADING_TEMPLATE = "<table class='group level{level}'><tboby><tr class='group-header'><table><tr><td><span class='open-close-indicator'>-</span>{value}</td></tr></table></tbody></table>",
    //    ROW_TEMPLATE = "<tr class='row level{level}' id='{id}'></tr>",
    //    CELL_TEMPLATE = "<td class='cell {columnId} {cssClass}'>{value}</td>",
    //    ROWS_CONTAINER_TEMPLATE = "<tbody class='afGrid-rows'></tbody>";

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
            headingRowElementsRenderer: headingRowElementsRenderer,
            makeColumnDraggable: makeColumnDraggable,
            showTotalRows: true,
            totalRowLabelTemplate: TOTAL_ROW_LABEL_TEMPLATE,
            headingRowCellTemplate: HEADING_ROW_CELL_TEMPLATE
        }, options);

        var plugins = {},
            addedRows = [];

        updateColumnHashMap(options);
        updateColumnWidth(options);

        if (!options.id) {
            throw "You need to provide id for the afGrid";
        }

        return this.each(function () {
            var $afGrid = $(this);
            if (!$afGrid.hasClass("afGrid-initialized")) {
                $afGrid.trigger($.afGrid.destroy);
                $afGrid = $(this);
            }
            /*if (this.tagName!=="TABLE") {
                var prop = {
                    id: $afGrid.attr("id"),
                    class: $afGrid.attr("class"),
                    cellSpacing: 0,
                    cellPadding: 0
                };
                var $table = $("<table></table>").attr(prop);
                $afGrid.replaceWith($table);
                $afGrid = $table;
            }*/
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
                $head = renderHeading(options).wrap(HEADING_ROW_CONTAINER_TEMPLATE).parent();
                $afGrid.addClass("afGrid").empty().append($head.add($rows));
                if (options.showTotalRows) {
                    $afGrid.append(options.totalRowLabelTemplate.supplant({
                        totalRows: "",
                        loadedRows: ""
                    }));
                }
                $rows.bind("scroll.afGrid", function() {
                    onafGridScroll($head, $rows, options);
                    $afGrid.data("lastScrollPos", $rows[0].scrollLeft);
                });
            }
            
            //Fix for the grid width issue
            adjustRowWidth($afGrid);

	    $rows[0].scrollLeft = $afGrid.data("lastScrollPos");

            function destroy() {
                callMethodOnPlugins(plugins, "destroy", options);					
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

            function onRowAppend(event, newRows, columnWidthOverride) {
                addedRows = $.merge(addedRows, newRows);
                countOfLoadedRows += newRows.length;
                updateCountLabel($afGrid, options, countOfLoadedRows);
                options.columnWidthOverride = columnWidthOverride;
    		updateColumnWidth(options);				
                var totalRows = $afGrid.find(".afGrid-rows .row").length,
                    $groupContainers = rowsAndGroup.lastGroupInformation.$groupContainers,
                    currentGroupValues = rowsAndGroup.lastGroupInformation.currentGroupValues,
                    $rowsMainContainer = rowsAndGroup.$rowsMainContainer,
                    isStartRowEven = $rowsMainContainer.find(".row:last").hasClass("even");
                rowsAndGroup.lastGroupInformation = addRows(options.id, newRows, options.columns, options.groupBy, $rowsMainContainer, $groupContainers, currentGroupValues, isStartRowEven, cachedafGridData, rowWidth);
            }
            $afGrid.unbind($.afGrid.appendRows).bind($.afGrid.appendRows, onRowAppend);
            
            function adjustRowWidth() {
                rowWidth=0;
                $afGrid.find(".afGrid-rows .row:eq(0)").children().each(function() {
                    rowWidth+=$(this).outerWidth();    
                });
                $afGrid.find(".afGrid-rows .row").width(rowWidth);
            }
            $afGrid.unbind($.afGrid.adjustRowWidth).bind($.afGrid.adjustRowWidth, adjustRowWidth);
            
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

            updateCountLabel($afGrid, options, countOfLoadedRows);

            $.each($.afGrid.plugin, function (key, plugin) {
                plugins[key] = plugin($afGrid, options, cachedafGridData);
                plugins[key].load();
            });

            $afGrid.addClass("afGrid-initialized");
            $afGrid.trigger($.afGrid.renderingComplete);
						
        });

    };

    function callMethodOnPlugins(plugins, methodName, options) {
            $.each(plugins, function (key, plugin) {					
                    if (plugin[methodName]) {
                            plugin[methodName](options);
                    }
            });		
    }
    
    function onafGridScroll($head, $rows, options) {
            var eleRow = $rows[0];
            $head.css({
                marginLeft: -1 * eleRow.scrollLeft
            });
            clearTimeout(scrollBottomTimer);
            scrollBottomTimer = setTimeout(function () {
                var scrolled = (eleRow.scrollHeight - $rows.scrollTop()),
                        containerHeight = $rows.outerHeight();
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

    function makeColumnDraggable($afGrid) {
		if (!$afGrid.data("afGridColumnDraggable")) {
			$.fn.draggable && $afGrid.find(".afGrid-heading .cell").draggable({
				helper: function (event) {
					return getHelper(event, $afGrid.attr("class"));
				},
				revert: false,
				cancel: ".resize-handle",
				appendTo: "body"
			});
			$afGrid.data("afGridColumnDraggable", true);
		}
    }

    function removeColumnDraggable($afGrid) {
		$.fn.draggable && $afGrid.find(".afGrid-heading .cell").draggable("destroy");
		$afGrid.removeData("afGridColumnDraggable");
    }

    function getHelper(event, cssClass) {
        return $(event.currentTarget).clone(false).wrap(HEADING_ROW_TEMPLATE).parent().wrap(HEADING_ROW_COLUMN_HELPER_TEMPLATE.supplant({
            cssClass: cssClass
        })).parent().css("width", "auto");
    }

    function renderHeading(options) {
        return options.headingRowElementsRenderer(options.columns, {
            container: HEADING_ROW_TEMPLATE,
            cell: options.headingRowCellTemplate,
            cellContent: function (column) {
                return {
                    value: column.label,
                    id: options.id + "Col_" + column.id,
                    cssClass: column.renderer || ""
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
        var $rowsMainContainer = $(ROWS_CONTAINER_TEMPLATE),
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
        return $(GROUP_HEADING_TEMPLATE.supplant({
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
                $wrapper = $(GROUP_CONTAINER_WRAPPER_TEMPLATE);
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
                $wrapper = $(GROUP_CONTAINER_WRAPPER_TEMPLATE);
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

    function addRows(tableId, rows, columns, groups, $rowMainContainer, $groupContainers, currentGroupValues, isStartEven, cachedafGridData, rowWidth) {
        var groupsLength = groups && groups.length;
        $.each(rows, function (i, row) {
            var rowId = row.id,
                rowData = rowId ? row.data : row,
                $rowContainer = $rowMainContainer,
                $row;
            if (rowId) {
                (cachedafGridData[rowId] = row);
            }
            if (groupsLength) {
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
            if (rowWidth) {
                $row.css("width",rowWidth);
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
        var $cell = $(CELL_TEMPLATE.supplant({
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
}/**
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
            columnReorder: function ($afGrid, options) {
                options = $.extend({
                    canReorderColumn: true,
                    onColumnReorder: $.noop
                }, options);

                function onColumnReorderDrop(event, ui) {
                    $(this).removeClass("reorder");
                    var columnIdToMove = ui.draggable.attr("id").split("_")[1],
                        columnIdToMoveAfter = $(this).attr("id").split("_")[1],
                        newColumnOrder = [];                    
					$.each(options.columns, function (i, column) {
						if (column.id !== columnIdToMove) {
                            newColumnOrder.push(column.id);
                        }
                        if (column.id === columnIdToMoveAfter) {
                            newColumnOrder.push(columnIdToMove);
                        }
                    });
		    $afGrid.removeClass("afGrid-initialized");			
                    options.onColumnReorder(newColumnOrder);
                }

                function load() {
                    if (!options.canReorderColumn || $afGrid.hasClass("afGrid-initialized")) {
                        return;
                    }

                    $.fn.droppable && $afGrid.find(".afGrid-heading .cell").droppable({
                        drop: onColumnReorderDrop,
                        over: onColumnReorderOver,
                        out: onColumnReorderOut,
                        accept: ".afGrid-heading .cell"
                    });

                    options.makeColumnDraggable($afGrid);
                }

                function destroy() {
                    options = null;
                    $.fn.droppable && $afGrid.find(".afGrid-heading .cell").droppable("destroy");
                }
				
                return {
                    load: load,
                    destroy: destroy
                };
            }
        }
    });

    function onColumnReorderOver(event, ui) {
        $(this).addClass("reorder");
    }

    function onColumnReorderOut(event, ui) {
        $(this).removeClass("reorder");
    }

}(jQuery));/**
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
            columnResize: function ($afGrid, options) {

                options = $.extend({
                    canResizeColumn: true,
                    onColumnResize: $.noop,
                    minColumnWidth: 30,
                    maxColumnWidth: 700
                }, options);

                var columns = options.columns;

                function load() {
                    if (!options.canResizeColumn || $afGrid.hasClass("afGrid-initialized")) {
                        return;
                    }
                    var $headingCells = $afGrid.find(".afGrid-heading .cell");
                    $headingCells.each(function () {
                        var $cell = $(this),
						$resizeHandle = $("<span class='resize-handle'></span>");
                        $resizeHandle.bind("click", function () {
                            return false;
                        });

                        $resizeHandle.bind("mousedown", function (event) {
                            var columnId = $(this).parents(".cell").eq(0).attr("id").split("_")[1],
								posX,
								originalWidth,
								$guide,
								newWidth;
                            $guide = $("<div class='resize-guide'></div>");
                            $guide.css({
                                height: $afGrid.height(),
                                top: $afGrid.position().top + parseInt($afGrid.css("margin-top"), 10),
                                left: $resizeHandle.offset().left + $resizeHandle.width()
                            });
                            $("body").append($guide);
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
					left: $resizeHandle.offset().left + $resizeHandle.width()
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


                        $cell.append($resizeHandle);
                    });

                }

                function destroy() {
                    $afGrid.find(".resize-handle,.resize-guide").unbind().remove();
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

}(jQuery));/**
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

    var filtersContainer = {},
	filtersLastVal = {};
    
    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            filters: function ($afGrid, options) {

                options = $.extend({
                    canFilter: true,
                    filterBy: null,
                    typeSearchDelay: 600,
                    headingRowElementsRenderer: $.noop,
                    onFilter: $.noop
                }, options);

                var $filters;

                function onFilterChange() {
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
                    if (!options.canFilter || $afGrid.hasClass("afGrid-initialized")) {
			$filters = filtersContainer[options.id];
                        return;
                    }

                    $filters = renderFilters(options);
		    
                    var typeSearchDelayTimer = null;
		    
		    $filters.find(".input-filter").bind("change.filter", onFilterChange).bind("keyup.filter", function (event) {
			var $ele = $(this);
			if(filtersLastVal[options.id] && filtersLastVal[options.id][$ele.attr("id")]!==$ele.val() && filtersLastVal[options.id][$ele.attr("id")]!==undefined) {
			    window.clearTimeout(typeSearchDelayTimer);
			    typeSearchDelayTimer = window.setTimeout(function () {
				onFilterChange.call($ele[0]);
				typeSearchDelayTimer = null;
			    }, options.typeSearchDelay);
			}
			filtersLastVal[options.id] = filtersLastVal[options.id] || {};
			filtersLastVal[options.id][$ele.attr("id")] = $ele.val();
		    });

		    filtersContainer[options.id] = $filters;
		    
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
                }

                function onMutliSelectChange() {
                    $(this).addClass("filter-changed");
                }

                function destroy() {
                    delete filtersContainer[options.id];
		    $filters.find(".select-filter,.input-filter").unbind("change.filter").unbind("keyup.filter").unbind("focus.filter");
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
        return options.headingRowElementsRenderer(options.columns, {
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

}(jQuery));/**
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

    var groupContainers = {};
    
    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            groups: function ($afGrid, options) {
                options = $.extend({
                    id: options.id,
                    canGroup: true,
                    onGroupChange: $.noop,
                    onGroupReorder: $.noop,
                    groupsPlaceHolder: null,
                    groupBy: null
                }, options);

                var $groupsMainContainer,
                    currentGroupColumnIds;

                function renderGroups(columns, groupedColumnIds) {
                    var groupedColumnIdsLength = groupedColumnIds.length,
                        $groupContainer,
                        $groups;
                    if (groupedColumnIdsLength) {
                        $groupsMainContainer.find(".empty-message").hide();
                        $groupContainer = $groupsMainContainer.find(".groups").show();
                        $groupContainer.empty();
                        $groups = $j();
                        $j.each(groupedColumnIds, function (i, columnId) {
                            var $group = $j("<span id='{id}' class='cell'><span class='arrow'><span class='label'><a class='remove' href='#'>x</a> {label}</span></span></span>".supplant({
                                label: columns[options.columnsHashMap[columnId]].label,
                                id: options.id + "GroupBy_" + columnId
                            }));
                            $groups = $groups.add($group);
                            if (i === 0) {
                                $group.addClass("first");
                            }
                            if (i === groupedColumnIdsLength - 1) {
                                $group.addClass("last");
                            }
                        });
                        $groupContainer.append($groups);
                    } else {
                        $groupsMainContainer.find(".empty-message").show();
                        $groupsMainContainer.find(".groups").hide();
                    }
                    currentGroupColumnIds = groupedColumnIds;
                }

                function removeColumnFromGroup(columnId) {
                    var newGroupColumnIds = $j.grep(currentGroupColumnIds, function (id, i) {
                        return id !== columnId;
                    });
		    $afGrid.removeClass("afGrid-initialized");			
                    options.onGroupChange(newGroupColumnIds);
                }

                function onColumnGroupingDrop(event, ui) {
                    var columnId = ui.draggable.attr("id").split("_")[1];
                    if (currentGroupColumnIds && currentGroupColumnIds.indexOf(columnId) > -1) {
                        return false;
                    }
                    currentGroupColumnIds.push(columnId);
                    setTimeout(function () {
			$afGrid.removeClass("afGrid-initialized");			
			options.onGroupChange(currentGroupColumnIds);
                    }, 10);
                    return true;
                }

                function onGroupExpandCollapse() {
                    var $ele = $(this),
                        currentState = !$ele.data("state");
                    $ele.data("state", currentState);
                    $ele.find(".open-close-indicator").html(currentState ? "+" : "-");
                    $ele.removeClass("open close").addClass(currentState ? "close" : "open");
                    $ele.parents(".group").eq(0).children(":not('.group-header:eq(0)')")[currentState ? "hide" : "show"]();
                }

                function onGroupReorderDrop(event, ui) {
                    $(this).removeClass("reorder");
                    var groupIdToMove = ui.draggable.attr("id").split("_")[1],
                        groupIdToMoveAfter = $(this).attr("id").split("_")[1],
                        newGroupOrder = [];
                    $.each(options.groupBy, function (i, columnId) {
                        if (columnId !== groupIdToMove) {
                            newGroupOrder.push(columnId);
                        }
                        if (columnId === groupIdToMoveAfter) {
                            newGroupOrder.push(groupIdToMove);
                        }
                    });
		    $afGrid.removeClass("afGrid-initialized");			
                    options.onGroupReorder(newGroupOrder);
                }

                function load() {
                    if (!options.canGroup || $afGrid.hasClass("afGrid-initialized")) {
                        $groupsMainContainer = groupContainers[options.id];
			return;
                    }

                    $afGrid.undelegate(".group .group-header", "click").delegate(".group .group-header", "click", onGroupExpandCollapse);
                    $groupsMainContainer = $(options.groupsPlaceHolder).undelegate("a.remove", "click.groups").delegate("a.remove", "click.groups", function () {
                        removeColumnFromGroup($j(this).parents(".cell").eq(0).attr("id").split("_")[1]);
                        return false;
                    });
		    groupContainers[options.id] = $groupsMainContainer;
                    renderGroups(options.columns, options.groupBy);

                    $.fn.droppable && $groupsMainContainer.droppable({
                        drop: onColumnGroupingDrop,
                        accept: "#" + options.id + " .groupBy",
                        activeClass: "ui-state-highlight"
                    });

                    $.fn.draggable && $groupsMainContainer.find(".cell").draggable({
                        drop: onColumnGroupingDrop,
                        helper: getGroupHelper,
                        accept: "#" + options.id + " .groupBy",
                        containment: $groupsMainContainer
                    });

                    $.fn.droppable && $groupsMainContainer.find(".cell").droppable({
                        accept: ".groups .cell",
                        drop: onGroupReorderDrop,
                        over: onGroupReorderOver,
                        out: onGroupReorderOut
                    });

                    options.makeColumnDraggable($afGrid);
                }

                function destroy() {
                    $.fn.droppable && $groupsMainContainer.droppable("destroy");
                    $.fn.droppable &&  $.fn.draggable && $groupsMainContainer.find(".cell").droppable("destroy").draggable("destroy");
                    delete groupContainers[options.id];
		    $groupsMainContainer.undelegate("a.remove", "click.groups");
                    $groupsMainContainer.find(".groups").empty();
                    $groupsMainContainer = null;
                    currentGroupColumnIds = null;
                    options = null;
                }
				
                return {
                    load: load,
                    destroy: destroy
                };
            }
        }
    });

    function onGroupReorderOver(event, ui) {
        $(this).addClass("reorder");
    }

    function onGroupReorderOut(event, ui) {
        $(this).removeClass("reorder");
    }

    function getGroupHelper(event) {
        return $(event.currentTarget).clone(false).addClass("group-helper");
    }

    function onGroupReorder(x, y, z) {
        console.log(x, y, z);
    }
}(jQuery));/**
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
                    if (!options.canSort || $afGrid.hasClass("afGrid-initialized")) {
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

}(jQuery));/**
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
    $.statePersistToCookie = $.cookie && {
        load: function (key, callback) {
            callback($.cookie(key));
        },
        save: function (key, value, callback) {
            $.cookie(key, value, {
                expires: 100,
                path: '/'
            });
            if (callback) {
                callback();
            }
        }
    };
}(jQuery));