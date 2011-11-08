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

    window.AF = window.AF || {};
    AF.Grid = function (options) {

        options = $.extend(true, {
            id: null,
            dataSource: null,
            statePersist: $.statePersistToCookie,
            onRowClick: defaultOnRowClick
        }, options);

		
        var store = options.dataSource,
	    renderer, loadedRows = 0,
            totalRows = 0,
            rowsToLoad = 0,
            columnData = null,
            afGridCurrentStateData = {};

        function render(data) {
            columnData = data.columns;
            totalRows = data.totalRows;
            loadedRows = data.rows.length;
            rowsToLoad = data.rowsToLoad || 20;
            data.columnWidthOverride = afGridCurrentStateData.columnWidthOverride;
            renderer.renderData(data);
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
	    store.fetchRows(requestData, onRecieveOfNewRows);
        }

        function onRecieveOfNewRows(newRows) {
            loadedRows += newRows.rows.length;
            renderer.addNewRows(newRows);
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

        function defaultOnRowClick(rowId, rowData) {
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

        //Constructor
        (function init() {
            renderer = new AF.renderer.Grid({
                id: options.id,
                fetchData: fetchRowsIncrementally,
                onGroupBy: onGroupBy,
                onSortBy: onSortBy,
                onFilterBy: onFilterBy,
                onColumnReorder: onColumnReorder,
                onColumnResize: onColumnResize,
                onRowClick: options.onRowClick,
                onGroupReorder: onGroupReorder
            });
        }());

        return {
            load: load
        };
    };

}(jQuery));