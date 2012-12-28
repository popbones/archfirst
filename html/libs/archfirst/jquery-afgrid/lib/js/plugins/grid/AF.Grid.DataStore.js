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

    var DEFAULT_CLIENT_PAGE_SIZE = 100;

    AF.Grid.DataStore = function (source, clientCache) {

        var fullyLoaded,
            dataSet,
            dataStoreRows,
            dataStoreColumns,
            lastResponseData;

        function fetchRows(requestData, onSuccess) {
            callAction("fetchRows", requestData, onSuccess);
        }

        function filter(requestData, onSuccess) {
            callAction("filter", requestData, onSuccess);
        }

        function groupBy(requestData, onSuccess) {
            callAction("groupBy", requestData, onSuccess);
        }

        function sortBy(requestData, onSuccess) {
            callAction("sortBy", requestData, onSuccess);
        }

        function reorderColumn(requestData, onSuccess) {
            callAction("reorderColumn", requestData, onSuccess);
        }

        function load(requestData, onSuccess) {
            callAction("load", requestData, onSuccess);
        }

        function getCurrentMetaData() {
            if (dataSet) {
                return {
                    columns: (function () {
                        var cols = $.extend([], dataSet.columns);
                        $.each(cols, function (i, col) {
                            delete col.filterData;
                            delete col.filterType;
                        });
                        return cols;
                    }()),
                    filters: (function () {
                        var filters = $.extend([], dataSet.filters);
                        $.each(filters, function (i, filter) {
                            filter.type = filter.type || filter.filterType;
                            filter.value = filter.value || filter.filterData;
                            delete filter.filterData;
                            delete filter.filterType;
                        });
                        return filters;
                    }()),
                    state: $.extend({}, dataSet.state)
                };
            }
            return null;
        }

        function refresh(requestData, onSuccess) {
            fullyLoaded = false;
            load(requestData, onSuccess);
        }

        function destroy() {
            fullyLoaded = null;
            dataSet = null;
            dataStoreRows = null;
            dataStoreColumns = null;
            lastResponseData = null;
        }

        function callAction(actionType, requestData, callback) {
            requestData = requestData || {};
            if (!fullyLoaded) {
                source[actionType](transformDataForServer(requestData), function (responseData) {
                    sourceActionHandler(actionType, requestData, callback, responseData);
                });
            } else {
                clientActionsHandler(actionType, requestData, callback);
            }
        }

        function transformDataForServer(requestData) {
            var data = {};
            if (!$.isEmptyObject(requestData)) {
                data.state = $.extend({}, requestData);
            }
            if (requestData.pageSize) {
                data.pageSize = requestData.pageSize;
            }
            if (data.state && data.state.columnWidthOverride) {
                var columnWidthOverride = [];
                $.each(data.state.columnWidthOverride, function (key, value) {
                    columnWidthOverride.push({
                        id: key,
                        width: value
                    });
                });
                data.state.columnWidthOverride = columnWidthOverride;
            }
            if (data.state && data.state.pageSize) {
                delete data.state.pageSize;
            }
            return data;
        }

        function transformDataFromServer(responseData) {
            moveFilterDataInsideColumn(responseData.columns, responseData.filters);
            if (responseData.state) {
                if (responseData.state.columnWidthOverride) {
                    var columnWidthOverride = {};
                    $.each(responseData.state.columnWidthOverride, function (i, column) {
                        columnWidthOverride[column.id] = column.width;
                    });
                    responseData.state.columnWidthOverride = columnWidthOverride;
                }
                if (responseData.state.hiddenColumns) {
                    $.each(responseData.state.hiddenColumns, function (i, hiddenColumnId) {
                        getColumnInfoById(hiddenColumnId, responseData.columns).column.isHidden = true;
                    });
                }
                return $.extend(responseData, responseData.state);
            }
            return responseData;
        }

        function addNewColumnsInOrder(columnOrder, columns) {
            var columnsInNewOrder = [];
            var columnLast = [];
            $.each(columns, function (i, column) {
                if (columnOrder.indexOf(column.id) > -1) {
                    columnsInNewOrder[columnOrder.indexOf(column.id)] = column.id;
                } else {
                    columnLast.push(column.id);
                }
            });
            return columnsInNewOrder.concat(columnLast);
        }

        function clientActionsHandler(actionType, requestData, callback) {
            var transformedRows, reOrderedDataSet;
            transformedRows = getTransformedRowsIfJSON(dataSet.rows, dataSet.columns);
            dataStoreColumns = $.extend(true, [], dataSet.columns);
            dataStoreRows = getFilteredRows($.extend(true, [], transformedRows), requestData.filterBy, dataStoreColumns, dataSet.filters, false);
            var columnOrder;
            if (requestData.columnOrder && requestData.columnOrder.length) {
                columnOrder = requestData.columnOrder;
            } else if (dataSet.columnOrder && dataSet.columnOrder.length) {
                columnOrder = dataSet.columnOrder;
            } else {
                columnOrder = getColumnOrder(dataSet.columns);
            }
            columnOrder = addNewColumnsInOrder(columnOrder, dataSet.columns);
            reOrderedDataSet = reOrderDataSetAsPerColumnOrder(columnOrder, dataStoreColumns, dataStoreRows);
            dataStoreColumns = reOrderedDataSet.columns;
            dataStoreRows = reOrderedDataSet.rows;
            var stateData = $.extend({}, dataSet.state, requestData);
            sortDataSet(stateData, dataStoreColumns, dataStoreRows);
            var responseData = $.extend({}, requestData);
            if (actionType === "fetchRows") {
                responseData = {
                    rows: getRows(requestData.pageOffset - 1, requestData.pageSize, dataStoreRows)
                };
            } else {
                responseData = $.extend({}, getResponseData(DEFAULT_CLIENT_PAGE_SIZE, dataStoreColumns, dataStoreRows), responseData, {
                    filters: lastResponseData.filters,
                    isGridSortable: lastResponseData.isGridSortable,
                    isGridGroupable: lastResponseData.isGridGroupable,
                    isGridFilterable: lastResponseData.isGridFilterable,
                    isGridColumnReorderable: lastResponseData.isGridColumnReorderable
                });
            }
            setTimeout(function () {
                callback(responseData);
            }, 50);
        }

        function sourceActionHandler(actionType, requestData, callback, responseData) {
            responseData = transformDataFromServer(responseData);
            var transformedRows, reOrderedDataSet;
            lastResponseData = responseData;
            if (actionType === "fetchRows") {
                transformedRows = getTransformedRowsIfJSON(responseData.rows, dataSet.columns);
                var rowsWithReorderedData = reorderRowsDataBasedOnIndex(getColumnOrderInIndex(requestData.columnOrder, dataStoreColumns), transformedRows);
                dataSet.rows = dataStoreRows.concat(rowsWithReorderedData);
                dataStoreRows = dataSet.rows;
                if (clientCache && (dataSet.totalRows === dataSet.rows.length && isAllFilterInActive(dataSet.filterBy))) {
                    fullyLoaded = true;
                }
                callback({rows: rowsWithReorderedData});
            } else {
                dataSet = responseData;
                dataStoreColumns = $.extend(true, [], dataSet.columns);
                transformedRows = getTransformedRowsIfJSON(dataSet.rows, dataStoreColumns);
                var columnOrder;
                if (dataSet.columnOrder && dataSet.columnOrder.length) {
                    columnOrder = dataSet.columnOrder;
                } else {
                    columnOrder = getColumnOrder(dataStoreColumns);
                }
                columnOrder = addNewColumnsInOrder(columnOrder, dataSet.columns);
                reOrderedDataSet = reOrderDataSetAsPerColumnOrder(columnOrder, dataStoreColumns, transformedRows);
                dataStoreColumns = reOrderedDataSet.columns;
                dataStoreRows = reOrderedDataSet.rows;
                dataSet.rows = reOrderedDataSet.rows;
                dataSet.columns = reOrderedDataSet.columns;
                if (clientCache && (dataSet.totalRows <= dataSet.pageSize && isAllFilterInActive(dataSet.filterBy))) {
                    fullyLoaded = true;
                    callAction("load", requestData, callback);
                    return;
                }
                callback(dataSet);
            }
        }

        return {
            refresh: refresh,
            load: load,
            fetchRows: fetchRows,
            filter: filter,
            groupBy: groupBy,
            sortBy: sortBy,
            reorderColumn: reorderColumn,
            destroy: destroy,
            getCurrentMetaData: getCurrentMetaData
        };
    };

    function isAllFilterInActive(filter) {
        return filter === null || filter === undefined || filter.length === 0;
    }

    function moveFilterDataInsideColumn(columns, filters) {
        if (columns && filters) {
            $.each(columns, function (i, column) {
                var filterInfo = getFilterInfo(column, filters);
                column.filterType = filterInfo.type;
                column.filterData = filterInfo.value;
            });
        }
    }

    function getFilterInfo(column, filters) {
        var filterInfo = {};
        $.each(filters, function (i, filter) {
            if (filter.id === column.id) {
                filterInfo = {
                    type: filter.type || filter.filterType,
                    value: filter.value || filter.filterData
                };
                return false;
            }
            return true;
        });
        return filterInfo;
    }

    function isDataInJSONFormat(rows) {
        //noinspection OverlyComplexBooleanExpressionJS
        return rows && rows[0] && (!rows[0].data && !$.isArray(rows[0]));
    }

    function getTransformedRowsIfJSON(rows, columns) {
        if (isDataInJSONFormat(rows)) {
            return rowTransformer(rows, getColumnOrder(columns));
        } else {
            return rows;
        }
    }

    function rowTransformer(rows, columnOrder) {
        var transformedRows = [];
        var n, l;
        for (n = 0, l = rows.length; n < l; n++) {
            transformedRows[transformedRows.length] = {
                id: rows[n].id || null,
                orig: rows[n],
                data: flattenRowData(rows[n], columnOrder)
            };
        }
        return transformedRows;
    }

    function flattenRowData(row, columnOrder) {
        var rowData = [];
        $.each(columnOrder, function (i, column) {
            rowData[rowData.length] = row[column];
        });
        return rowData;
    }

    function getColumnOrder(columns) {
        var columnsOrder = [];
        $.each(columns, function (i, column) {
            columnsOrder[columnsOrder.length] = column.id;
        });
        return columnsOrder;
    }

    function sortData(data, dataStoreColumns, dataStoreRows, serverSort) {
        if (serverSort) {
            var reorderedData = reOrderDataSetAsPerColumnOrder(getColumnOrder(dataStoreColumns), dataStoreColumns, dataStoreRows);
            dataStoreColumns = reorderedData.columns;
            dataStoreRows = reorderedData.rows;
        }
        var groupByColumns = data.groupBy && data.groupBy.length ? $.map(data.groupBy, function (column) {
            return column.id;
        }) : [];
        var sortByColumns = data.sortBy && data.sortBy.length ? data.sortBy[0].id : null;
        var sortByDirection = data.sortBy && data.sortBy.length ? data.sortBy[0].direction : null;
        var sortByColumnIDsInOrder = $.merge([], groupByColumns || []),
            sortOrder = [],
            sortDirection = [];
        var n, l;

        if (serverSort) {
            if (sortByColumns) {
                if (sortByColumnIDsInOrder.indexOf(sortByColumns) < 0) {
                    sortByColumnIDsInOrder.push(sortByColumns);
                }
            }
            sortOrder = $.map(sortByColumnIDsInOrder, function (columnID) {
                return getColumnInfoById(columnID, dataStoreColumns).index;
            });
            sortDirection = $.map(sortByColumnIDsInOrder, function (columnID) {
                return (columnID === sortByColumns) ? (sortByDirection === "desc" ? -1 : 1) : 1;
            });
        } else {
            for (n = 0, l = sortByColumnIDsInOrder.length; n < l; n++) {
                sortOrder.push(n);
                sortDirection.push(sortByColumnIDsInOrder[n] === sortByColumns ? (sortByDirection === "desc" ? -1 : 1) : 1);
            }
            if (sortByColumns) {
                if (sortByColumnIDsInOrder.indexOf(sortByColumns) < 0) {
                    sortOrder[sortOrder.length] = getColumnInfoById(sortByColumns, dataStoreColumns).index;
                    sortDirection[sortDirection.length] = (sortByDirection === "desc" ? -1 : 1);
                }
            }
        }

        multiColumnSorting(dataStoreRows, sortOrder, sortDirection, dataStoreColumns);
    }

    function getColumnSortComparator(columnIndex, dataStoreColumns) {
        var column = dataStoreColumns[columnIndex],
            cellRenderer = column.type || column.renderer;
        if (cellRenderer) {
            cellRenderer = $.afGrid.renderer[cellRenderer];
        }
        if (cellRenderer && cellRenderer.comparator) {
            return cellRenderer.comparator;
        }
        return defaultSortComparator;
    }

    function defaultSortComparator(valA, valB) {
        return valA === valB ? 0 : (valA < valB ? -1 : 1);
    }

    function multiColumnSorting(TheArr, columnIndexInOrder, direction, dataStoreColumns) {
        if (!(columnIndexInOrder && columnIndexInOrder.length > 0)) {
            return;
        }
        var columnComparator = [];
        $.each(columnIndexInOrder, function (i, columnIndex) {
            columnComparator[columnIndex] = getColumnSortComparator(columnIndex, dataStoreColumns);
        });
        var columnIndexInOrderLength = columnIndexInOrder.length;
        TheArr.sort(sortMulti);
        function sortMulti(objA, objB, n) {
            n = (arguments.length === 2) ? 0 : n;
            var a = objA.data,
                b = objB.data,
                columnIndex = columnIndexInOrder[n],
                swap = swapValues(columnIndex, a, b, columnComparator[columnIndex]);
            if (columnIndexInOrderLength === 1 || columnIndex === undefined || swap !== 0) {
                return swap * direction[n];
            }
            if (n < columnIndexInOrderLength - 1) {
                return sortMulti(objA, objB, ++n);
            }
            return 0;
        }
    }

    function swapValues(colIndex, a, b, sortComparator) {
        var valA = a[colIndex];
        var valB = b[colIndex];
        return sortComparator(valA, valB);
    }

    function getRows(start, length, dataStoreRows) {
        var rows = [],
            i = 0,
            n;
        for (n = start; n < start + length; n++) {
            if (!dataStoreRows[n]) {
                break;
            }
            rows[i++] = dataStoreRows[n];
        }
        return rows;
    }

    function getResponseData(pageSize, dataStoreColumns, dataStoreRows) {
        return {
            columns: dataStoreColumns,
            rows: getRows(0, pageSize, dataStoreRows),
            totalRows: dataStoreRows.length,
            pageSize: pageSize
        };
    }

    function getColumnInfoById(columnId, columns) {
        var foundIndex = -1,
            column = $.grep(columns, function (column, index) {
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

    function getFilteredRows(dataRows, filterBy, dsColumns, filters, serverFilter) {
        var filterColumns, filterValues = [];
        if (filterBy) {
            filterColumns = $.map(filterBy, function (filter) {
                return filter.id;
            });
            $.each(filterBy, function (i, filter) {
                filterValues.push(filter);
            });
        }
        if (serverFilter) {
            moveFilterDataInsideColumn(dsColumns, filters);
            dataRows = getTransformedRowsIfJSON(dataRows, dsColumns);
        }
        var rows = [],
            filterColumnsIndex;
        var columns = [];
        if (filterColumns) {
            filterColumnsIndex = $.map(filterColumns, function (columnId) {
                var columnInfo = getColumnInfoById(columnId, dsColumns);
                var column = columnInfo.column;
                columns[columnInfo.index] = {
                    column: column,
                    filterFunc: ($.afGrid.filter[column.filterType] && $.afGrid.filter[column.filterType].filter) || defaultFilter
                };
                return (columnInfo.index);
            });
            $.each(dataRows, function (i, row) {
                var addRow = true;
                $.each(filterColumnsIndex, function (i, index) {
                    if (!columns[index].filterFunc(filterValues[i], row.data[index])) {
                        addRow = false;
                    }
                });
                if (addRow) {
                    rows.push(row);
                }
            });
        } else {
            rows = dataRows;
        }
        return rows;
    }

    function defaultFilter(filter, columnValue) {
        var addRow = true;
        var filterValue = filter.value;
        if ($.isArray(filterValue)) {
            if (filterValue.indexOf(columnValue) < 0) {
                addRow = false;
            }
        } else {
            if ((String(columnValue)).toLowerCase().indexOf((String(filterValue)).toLowerCase()) < 0) {
                addRow = false;
            }
        }
        return addRow;
    }

    function reorderRowsDataBasedOnIndex(newOrder, rows) {
        $.each(rows, function (i, row) {
            var newDataRow = [];
            var n, l;
            for (n = 0, l = row.data.length; n < l; n++) {
                newDataRow[n] = row.data[newOrder[n]];
            }
            row.data = newDataRow;
        });
        return rows;
    }

    function getColumnOrderInIndex(columnOrder, columns) {
        return $.map(columnOrder, function (columnId) {
            return (getColumnInfoById(columnId, columns).index);
        });
    }

    function getReOrderedColumn(columnOrder, columns) {
        return $.map(columnOrder, function (columnId) {
            return (getColumnInfoById(columnId, columns).column);
        });
    }

    function reorderData(columnOrder, columns, rows) {
        reorderRowsDataBasedOnIndex(getColumnOrderInIndex(columnOrder, columns), rows);
        columns = getReOrderedColumn(columnOrder, columns);
        return {
            columns: columns,
            rows: rows,
            columnOrder: columnOrder
        };
    }

    function reOrderDataSetAsPerColumnOrder(columnOrder, dataStoreColumns, dataStoreRows) {
        return reorderData(columnOrder, dataStoreColumns, dataStoreRows);
    }

    function hasGroupByOrSortBy(data) {
        //noinspection OverlyComplexBooleanExpressionJS
        return (data.groupBy && data.groupBy.length) || (data.sortBy && data.sortBy.length);
    }

    function sortDataSet(data, dataStoreColumns, dataStoreRows) {
        if (hasGroupByOrSortBy(data)) {
            sortData(data, dataStoreColumns, dataStoreRows);
        }
    }

    AF.Grid.DataStore.utils = {
        getFilteredRows: getFilteredRows,
        sortData: sortData,
        getRows: getRows
    };

}(jQuery));