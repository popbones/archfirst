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

    var fakeDataStoreRows, fakeDataStoreColumns;
    
    var DataType = {
        NUMBER: "NUMBER",
        TEXT: "TEXT"
    };
    
    AF.Grid.FakeLocalStore = function (dataset) {

        function fetchRows(requestData, onSuccess) {
            callAction("fetchRows", requestData, onSuccess);
        }

        function filter(requestData, onSuccess) {
            callAction("filterData", requestData, onSuccess);
        }

        function groupBy(requestData, onSuccess) {
            callAction("groupData", requestData, onSuccess);
        }

        function sortBy(requestData, onSuccess) {
            callAction("sortData", requestData, onSuccess);
        }

        function reorderColumn(requestData, onSuccess) {
            callAction("reOrderColumn", requestData, onSuccess);
        }

        function load(requestData, onSuccess) {
            callAction("load", requestData, onSuccess);
        }


        function callAction(actionType, data, callback) {
            fakeDataStoreColumns = $.extend(true, [], dataset.columns);
            fakeDataStoreRows = getFilteredRows($.extend(true, [], dataset.rows), data.filterColumns, data.filterValues);
            setupDataAsPerState(data);
            var dummyResponseData = getDummyResponseFromRequestData(data);

            switch (actionType) {
            case "fetchRows":
                dummyResponseData = {
                    rows: getRows(data.loadFrom - 1, data.count)
                };
                break;
            case "groupData":
                //server should come back with the columns id in groupBy.
                //{groupBy: ["col1", "col2"]}
                dummyResponseData = $.extend({}, getDummyDataForFirstRequest(), dummyResponseData);
                break;
            case "sortData":
                //the data needs to have below property for example
                //{sortBy: {column: "col1", direction: "desc"}}
                dummyResponseData = $.extend({}, getDummyDataForFirstRequest(), dummyResponseData);
                break;
            case "filterData":
                //server should come back with the columns filter data.
                //{filterBy: [{id:"", values:["",""]}, {id:"", values:["",""]}]
                dummyResponseData = $.extend({}, getDummyDataForFirstRequest(), dummyResponseData);
                break;
                //"reOrderColumn" server should come back with data columns re-order as per the column order in the request
            default:
                dummyResponseData = $.extend({}, getDummyDataForFirstRequest(), dummyResponseData);
            }

            if (window.console) {
                console.log("requestData:", data);
                console.log("responseData:", dummyResponseData);
                console.log("actualPostToServer:", (unescape($.param(data)).split("&")));
            }

            asyncCallback(callback, dummyResponseData);
        };

        function getFilteredRows(dataRows, filterColumns, filterValues) {
            var rows = [],
                filterColumnsIndex;
            if (filterColumns) {
                filterColumnsIndex = $.map(filterColumns, function (columnId) {
                    return (getColumnById(columnId).index);
                });
                $.each(dataRows, function (i, row) {
                    var addRow = true;
                    $.each(filterColumnsIndex, function (i, index) {
                        if ($.isArray(filterValues[i])) {
                            if (filterValues[i].indexOf(row.data[index]) < 0) {
                                addRow = false;
                            }
                        } else {
                            if (row.data[index].toLowerCase().indexOf(filterValues[i].toLowerCase()) < 0) {
                                addRow = false;
                            }
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

        function setupDataAsPerState(data) {
            if (data.columnOrder) {
                reorderData(data.columnOrder);
            }
            if (data.groupByColumns || data.sortByColumn) {
                sortData(data);
            }
        }

        function getDummyResponseFromRequestData(data) {
            var dummyResponseData = {};
            if (data.filterColumns) {
                dummyResponseData = $.extend(dummyResponseData, {
                    filterBy: getFilterByData(data.filterColumns, data.filterValues)
                });
            }
            if (data.sortByColumn) {
                dummyResponseData = $.extend(dummyResponseData, {
                    sortBy: {
                        column: data.sortByColumn,
                        direction: data.sortByDirection
                    }
                });
            }
            if (data.groupByColumns) {
                dummyResponseData = $.extend(dummyResponseData, {
                    groupBy: data.groupByColumns
                });
            }
            return dummyResponseData;
        }

        function getFilterByData(filterColumns, filterValues) {
            var filterByData = [],
                columnValues = filterValues;
            $.each(filterColumns, function (i, columnId) {
                filterByData.push({
                    id: columnId,
                    value: columnValues[i]
                });
            });
            return filterByData;
        }

        function asyncCallback(callback, dummyResponseData) {
            setTimeout(function () {
                callback(dummyResponseData);
            }, 100);
        }

        function reorderData(columnOrder) {
            var dummydataWithNewOrder = {},
                newOrder = [];
            dummydataWithNewOrder.columns = [];
            $.each(columnOrder, function (i, columnId) {
                var column = getColumnById(columnId);
                dummydataWithNewOrder.columns.push(column.column);
                newOrder.push(column.index);
            });
            fakeDataStoreColumns = dummydataWithNewOrder.columns;
            $.each(fakeDataStoreRows, function (i, row) {
                var newDataRow = [],
                    n = 0;
                for (n = 0, l = row.data.length; n < l; n++) {
                    newDataRow[n] = row.data[newOrder[n]];
                }
                row.data = newDataRow;
            });
        }

        function getColumnById(columnId) {
            var foundIndex = -1,
                column = $.grep(fakeDataStoreColumns, function (column, index) {
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

        function sortData(data) {
            var columnsInOrder = $.merge([], data.groupByColumns || []),
                sortOrder = [],
                sortDirection = [],
                n, l;
            for (n = 0, l = columnsInOrder.length; n < l; n++) {
                sortOrder.push(n);
                sortDirection.push(columnsInOrder[n] === data.sortByColumn ? (data.sortByDirection === "desc" ? -1 : 1) : 1);
            }
            if (data.sortByColumn) {
                if (columnsInOrder.indexOf(data.sortByColumn) < 0) {
                    sortOrder[sortOrder.length] = getColumnById(data.sortByColumn).index;
                    sortDirection[sortDirection.length] = (data.sortByDirection === "desc" ? -1 : 1);
                }
            }

            multiColumnSorting(fakeDataStoreRows, sortOrder, sortDirection);
        }

        function getColumnType(columnIndex) {           
            if (columnIndex!==undefined) {
                return DataType[fakeDataStoreColumns[columnIndex].renderer];
            }
            return undefined;
        }
        
        function multiColumnSorting(TheArr, columnIndexInOrder, direction) {

            function sortMulti(objA, objB, n) {
                n = n || 0;
                var a = objA.data,
                    b = objB.data,
                    columnType = getColumnType(columnIndexInOrder[n]),
                    swap = swapValues(columnIndexInOrder[n], a, b, columnType);                                
                if ((columnIndexInOrder[n] === undefined) || (swap !== 0)) {
                    return swap * direction[n];
                } else if (n < columnIndexInOrder.length) {
                    return sortMulti(objA, objB, ++n);
                } else {
                    return null;
                }
            }

            TheArr.sort(sortMulti);

            function swapValues(colIndex, a, b, columnType) {
                var valA = a[colIndex];
                var valB = b[colIndex];
                if (columnType===DataType.NUMBER) {
                    valA = isNaN(valA) ? valA.replace(/,/g, "") : valA;
                    valB = isNaN(valB) ? valB.replace(/,/g, "") : valB;
                    valA = valA + 0;
                    valB = valB + 0;
                    return valA === valB ? 0 : (valA - valB < 0 ? -1 : 1);
                }
                return valA === valB ? 0 : (valA < valB ? -1 : 1);
            }
        }

        function getRows(start, length) {
            var rows = [],
                i = 0,
                n;
            for (n = start; n < start + length; n++) {
                if (!fakeDataStoreRows[n]) {
                    break;
                }
                rows[i++] = fakeDataStoreRows[n];
            }
            return rows;
        }

        function getDummyDataForFirstRequest() {
            return {
                columns: fakeDataStoreColumns,
                rows: getRows(0, 25),
                groupBy: [],
                sortBy: {
                    column: "colAN",
                    direction: "asc"
                },
                totalRows: fakeDataStoreRows.length,
                rowsToLoad: 25
            };
        }

        return {
            load: load,
            fetchRows: fetchRows,
            filter: filter,
            groupBy: groupBy,
            sortBy: sortBy,
            reorderColumn: reorderColumn
        }
    }
    
    AF.Grid.FakeLocalStore.getFilterData = function (columnIndex, rows) {
        var filterData = [];
        $.each(rows, function (i, row) {
            if (filterData.indexOf(row.data[columnIndex]) < 0) {
                filterData.push(row.data[columnIndex]);
            }
        });
        return filterData;
    };
    
}(jQuery));