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
            dataset.rows = getTransformedRowsIfJSON(dataset.rows, getColumnOrder(fakeDataStoreColumns));
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
        }

        function getTransformedRowsIfJSON(rows, columnOrder) {
            if (rows && rows[0] && (!rows[0].data && !$.isArray(rows[0]))) {
                var transformedRows = [];
                for (var n= 0,l=rows.length; n<l; n++) {
                    var row = rows[n];
                    transformedRows[transformedRows.length] = {
                        data: ($.map(columnOrder, function(column){
                            return row[column];
                        }))
                    }
                }
                return transformedRows;
            } else {
                return rows;
            }
        }

        function getColumnOrder(columns) {
            var columnsOrder = [];
            $.each(columns, function(i, column) {
                columnsOrder[columnsOrder.length] = column.id;
            });
            return columnsOrder;
        }

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
                            if ((row.data[index]+"").toLowerCase().indexOf((filterValues[i]+"").toLowerCase()) < 0) {
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
                var newDataRow = [];
                for (var n = 0, l = row.data.length; n < l; n++) {
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
    };
    
    AF.Grid.FakeLocalStore.getFilterData = function (columnIdentifier, rows) {
        var filterData = [];
        if (typeof columnIdentifier === "string") {
            $.each(rows, function (i, row) {
                if (filterData.indexOf(row[columnIdentifier]) < 0) {
                    filterData.push(row[columnIdentifier]);
                }
            });
        } else {
            $.each(rows, function (i, row) {
                if (filterData.indexOf(row.data[columnIdentifier]) < 0) {
                    filterData.push(row.data[columnIdentifier]);
                }
            });
        }
        return filterData;
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

    AF.Grid.fakeDataSet1 = (function () {
        function getColumns() {
            return [{
                label: "Column 1",
                id: "colAN",
                width: 240,
                filterData: AF.Grid.FakeLocalStore.getFilterData(0, rows),
                groupBy: true
            }, {
                label: "Column 2",
                id: "colAS",
                width: 150,
                filterData: "",
                groupBy: true
            }, {
                label: "Column 3",
                id: "colAT",
                width: 150,
                groupBy: true,
                filterData: AF.Grid.FakeLocalStore.getFilterData(2, rows)
            }, {
                label: "Column 4",
                id: "colDate",
                width: 100,
                renderer: "DATE",
                filterData: "DATERANGE"
            }, {
                label: "Comment",
                id: "colComment",
                sortable: false,
                width: 100,
                renderer: "LABEL_BUTTON"
            }];
        }

        var rows = [{
            id: 1,
            data: ["Sample Data", "Sample Data 4", "Sample Data 5", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 2,
            data: ["Sample Data", "Sample Data 4", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 3,
            data: ["Sample Data 7", "True", "Value", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 4,
            data: ["Sample Data 3", "Large", "Small", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 5,
            data: ["Sample Data 3", "Large", "Small", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 6,
            data: ["Sample Data 3", "Large", "Small", "25-May-2011", "Last Name, First Name2"]
        }, {
            id: 7,
            data: ["Sample Data 2", "True", "False", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 8,
            data: ["Sample Data 2", "True", "False", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 9,
            data: ["Sample Data 2", "True", "False", "25-May-2011", "Last Name, First Name3"]
        }, {
            id: 10,
            data: ["Sample Data 2", "True", "False", "25-May-2011", "Last Name, First Name121"]
        }, {
            id: 11,
            data: ["Sample Data 2", "True", "False", "25-May-2011", "Last Name, First Name111"]
        }, {
            id: 12,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 13,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 14,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name21"]
        }, {
            id: 15,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name11"]
        }, {
            id: 16,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name221"]
        }, {
            id: 17,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name211"]
        }, {
            id: 18,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name321"]
        }, {
            id: 19,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name31"]
        }, {
            id: 20,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name321"]
        }, {
            id: 21,
            data: ["Region", "Global", "UK", "25-May-2011", "Last Name, First Name3"]
        }, {
            id: 22,
            data: ["Region", "Global", "UK", "25-May-2011", "Last Name, First Name4"]
        }, {
            id: 23,
            data: ["Style", "Sector", "False", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 24,
            data: ["Style", "Sector", "Value", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 25,
            data: ["New Sample Data", "Sample Data 4", "Sample Data 5", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 26,
            data: ["New Sample Data", "Sample Data 4", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 27,
            data: ["New Sample Data 6", "True", "Value", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 28,
            data: ["New Sample Data 3", "Large", "Small", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 29,
            data: ["New 1 Sample Data", "Sample Data 4", "Sample Data 5", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 30,
            data: ["New 1 Sample Data 1", "Sample Data 4 1", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 31,
            data: ["New 1 Sample Data 1", "Sample Data 4 2", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 32,
            data: ["New 1 Sample Data 1", "Sample Data 4 3", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 33,
            data: ["New 1 Sample Data 1", "Sample Data 4 4", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 34,
            data: ["New 1 Sample Data 2", "Sample Data 4 1", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 35,
            data: ["New 1 Sample Data 2", "Sample Data 4 2", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 36,
            data: ["New 1 Sample Data 2", "Sample Data 4 3", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 37,
            data: ["New 1 Sample Data 2", "Sample Data 4 4", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 38,
            data: ["New 1 Sample Data 3", "Sample Data 4 1", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 39,
            data: ["New 1 Sample Data 3", "Sample Data 4 2", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 40,
            data: ["New 1 Sample Data 3", "Sample Data 4 3", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 41,
            data: ["New 1 Sample Data 3", "Sample Data 4 4", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 42,
            data: ["New 1 Sample Data 4", "Sample Data 4 1", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 43,
            data: ["New 1 Sample Data 4", "Sample Data 4 2", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 44,
            data: ["New 1 Sample Data 4", "Sample Data 4 3", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 45,
            data: ["New 1 Sample Data 4", "Sample Data 4 4", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 46,
            data: ["New 1 Sample Data 5", "Sample Data 4 1", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 47,
            data: ["New 1 Sample Data 5", "Sample Data 4 2", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 48,
            data: ["New 1 Does Rep", "True", "Value", "25-May-2011", "Last Name, First Name"]
        }];

        return {
            columns: getColumns(),
            rows: rows
        };

    }());

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

    AF.Grid.fakeDataSet2 = (function () {

        function getColumns() {
            return [{
                label: "Col 1",
                id: "colAN",
                width: 240,
                filterData: AF.Grid.FakeLocalStore.getFilterData(0, rows),
                groupBy: true
            }, {
                label: "Col 2",
                id: "colAS",
                width: 150,
                filterData: "",
                groupBy: true
            }, {
                label: "Col 3",
                id: "colAT",
                width: 150,
                groupBy: true,
                filterData: AF.Grid.FakeLocalStore.getFilterData(2, rows)
            }, {
                label: "Col 4",
                id: "colDate",
                width: 100,
                renderer: "DATE",
                filterData: "DATE"
            }, {
                label: "Col 5",
                id: "colComment",
                width: 100,
                renderer: "LABEL_BUTTON"
            }];
        }

        var rows = [{
            id: 1,
            data: ["Sample Data 1 2", "Broadly Marketed", "Sample Data 2", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 2,
            data: ["Sample Data 1 2", "Broadly Marketed", "Sample Data 2", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 3,
            data: ["Sample Data 3 2", "True", "Value", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 4,
            data: ["Sample Data 4 2", "Large", "Small", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 5,
            data: ["Sample Data 4 2", "Large", "Small", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 6,
            data: ["Sample Data 4 2", "Large", "Small", "25-May-2011", "Last Name, First Name2"]
        }, {
            id: 7,
            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 8,
            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 9,
            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name3"]
        }, {
            id: 10,
            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name121"]
        }, {
            id: 11,
            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name111"]
        }, {
            id: 12,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 13,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 14,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name21"]
        }, {
            id: 15,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name11"]
        }, {
            id: 16,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name221"]
        }, {
            id: 17,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name211"]
        }, {
            id: 18,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name321"]
        }, {
            id: 19,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name31"]
        }, {
            id: 20,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name321"]
        }, {
            id: 21,
            data: ["Region 2", "Global", "UK", "25-May-2011", "Last Name, First Name3"]
        }, {
            id: 22,
            data: ["Region 2", "Global", "UK", "25-May-2011", "Last Name, First Name4"]
        }, {
            id: 23,
            data: ["Style 2", "Sector", "False", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 24,
            data: ["Style 2", "Sector", "Value", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 25,
            data: ["New Sample Data 1 2", "Broadly Marketed", "Sample Data 2", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 26,
            data: ["New Sample Data 1 2", "Broadly Marketed", "Sample Data 2", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 27,
            data: ["New Sample Data 3 2", "True", "Value", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 28,
            data: ["New Sample Data 4 2", "Large", "Small", "25-May-2011", "Last Name, First Name"]
        }];

        return {
            columns: getColumns(),
            rows: rows
        };

    }());

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

    AF.Grid.fakeDataSet3 = (function () {

        function getColumns() {
            return [{
                label: "Col 1",
                id: "colAN",
                width: 240,
                filterData: ""
            }, {
                label: "Col 2",
                id: "colAS",
                width: 150,
                filterData: ""
            }, {
                label: "Col 3",
                id: "colAT",
                width: 150,
                filterData: ""
            }, {
                label: "Col 4",
                id: "colDate",
                width: 100,
                filterData: ""
            }, {
                label: "Col 5",
                id: "colComment",
                width: 200
            }];
        }

        var rows = [{
            id: 1,
            data: ["Sample Data 1 2", "Broadly Marketed", "Sample Data 2", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 2,
            data: ["Sample Data 1 2", "Broadly Marketed", "Sample Data 2", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 3,
            data: ["Sample Data 3 2", "True", "Value", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 4,
            data: ["Sample Data 4 2", "Large", "Small", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 5,
            data: ["Sample Data 4 2", "Large", "Small", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 6,
            data: ["Sample Data 4 2", "Large", "Small", "25-May-2011", "Last Name, First Name2"]
        }, {
            id: 7,
            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 8,
            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 9,
            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name3"]
        }, {
            id: 10,
            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name121"]
        }, {
            id: 11,
            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name111"]
        }, {
            id: 12,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 13,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 14,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name21"]
        }, {
            id: 15,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name11"]
        }, {
            id: 16,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name221"]
        }, {
            id: 17,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name211"]
        }, {
            id: 18,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name321"]
        }, {
            id: 19,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name31"]
        }, {
            id: 20,
            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name321"]
        }, {
            id: 21,
            data: ["Region 2", "Global", "UK", "25-May-2011", "Last Name, First Name3"]
        }, {
            id: 22,
            data: ["Region 2", "Global", "UK", "25-May-2011", "Last Name, First Name4"]
        }, {
            id: 23,
            data: ["Style 2", "Sector", "False", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 24,
            data: ["Style 2", "Sector", "Value", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 25,
            data: ["New Sample Data 1 2", "Broadly Marketed", "Sample Data 2", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 26,
            data: ["New Sample Data 1 2", "Broadly Marketed", "Sample Data 2", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 27,
            data: ["New Sample Data 3 2", "True", "Value", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 28,
            data: ["New Sample Data 4 2", "Large", "Small", "25-May-2011", "Last Name, First Name"]
        }];

        return {
            columns: getColumns(),
            rows: rows
        };

    }());

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

    AF.Grid.fakeDataSet4 = (function () {
        function getColumns() {
            return [{
                label: "Title Name",
                id: "colTitleName",
                width: 150,
                filterData: "",
                groupBy: true
            }, {
                label: "Title Released",
                id: "colTitleReleased",
                width: 100,
                filterData: "",
                groupBy: true           
            }, {
                label: "Artist Name",
                id: "colName",
                width: 150,
                filterData: "",
                groupBy: true
            }, {
                label: "Born",
                id: "colBorn",
                width: 100,
                renderer: "SYSTEM_DATE",
                filterData: "DATERANGE",
                groupBy: true
            }, {
                label: "Died",
                id: "colDied",
                renderer: "SYSTEM_DATE",
                width: 100,
                filterData: "DATERANGE",
                groupBy: true
            }, {
                label: "Genre",
                id: "colGenre",
                width: 150,
                groupBy: true,
                filterData: AF.Grid.FakeLocalStore.getFilterData(5, rows)
            }];
        }
                
        var rows = [{"id":1,"data":["Billie Jean","1983","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":2,"data":["Beat It","1983","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":3,"data":["Thriller","1984","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":4,"data":["Bad","1987","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":5,"data":["I Just Can't Stop Loving You","1987","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":6,"data":["Man in the Mirror","1987","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":7,"data":["Black or White","1991","Michael Jackson","1958-08-29","2009-06-25","Pop"]},{"id":8,"data":["Please Mister Postman","1963","John Lennon","1940-10-09","1980-12-08","Rock"]},{"id":9,"data":["Ticket to Ride","1965","John Lennon","1940-10-09","1980-12-08","Rock"]},{"id":10,"data":["Come Together","1969","John Lennon","1940-10-09","1980-12-08","Rock"]},{"id":11,"data":["All My Loving","1963","Paul McCartney","1942-06-18","-","Rock"]},{"id":12,"data":["Can't Buy Me Love","1964","Paul McCartney","1942-06-18","-","Rock"]},{"id":13,"data":["Yesterday","1965","Paul McCartney","1942-06-18","-","Rock"]},{"id":14,"data":["Ob-La-Di, Ob-La-Da","1968","Paul McCartney","1942-06-18","-","Rock"]},{"id":15,"data":["Let It Be","1970","Paul McCartney","1942-06-18","-","Rock"]},{"id":16,"data":["Get Back","1970","Paul McCartney","1942-06-18","-","Rock"]},{"id":17,"data":["Superstition","1972","Stevie Wonder","1950-05-13","-","Pop"]},{"id":18,"data":["Ebony and Ivory","1982","Stevie Wonder","1950-05-13","-","Pop"]},{"id":19,"data":["I Just Called to Say I Love You","1984","Stevie Wonder","1950-05-13","-","Pop"]},{"id":20,"data":["Love Me Tender","1956","Elvis Presley","1935-01-08","1977-08-16","Rock and Roll"]},{"id":21,"data":["Heartbreak Hotel","1956","Elvis Presley","1935-01-08","1977-08-16","Rock and Roll"]},{"id":22,"data":["All Shook Up","1957","Elvis Presley","1935-01-08","1977-08-16","Rock and Roll"]},{"id":23,"data":["Are You Lonesome Tonight?","1960","Elvis Presley","1935-01-08","1977-08-16","Rock and Roll"]},{"id":24,"data":["The Power of Love","1993","Celine Dion","1968-03-30","-","Pop"]},{"id":25,"data":["Because You Loved Me","1996","Celine Dion","1968-03-30","-","Pop"]},{"id":26,"data":["It's All Coming Back to Me Now","1996","Celine Dion","1968-03-30","-","Pop"]},{"id":27,"data":["My Heart Will Go On","1997","Celine Dion","1968-03-30","-","Pop"]},{"id":28,"data":["Rock n' Roll Madonna","1970","Elton John","1947-03-25","-","Rock"]},{"id":29,"data":["Victim of Love","1979","Elton John","1947-03-25","-","Rock"]},{"id":30,"data":["Like a Virgin","1984","Madonna","1958-08-16","-","Pop"]},{"id":31,"data":["Papa Don't Preach","1986","Madonna","1958-08-16","-","Pop"]},{"id":32,"data":["La Isla Bonita","1986","Madonna","1958-08-16","-","Pop"]},{"id":33,"data":["Paint It Black","1966","Mick Jagger","1943-07-26","-","Rock"]},{"id":34,"data":["(I Can't Get No) Satisfaction","1965","Mick Jagger","1943-07-26","-","Rock"]},{"id":35,"data":["-","-","Barbra Streisand","1942-04-24","-","Pop"]},{"id":36,"data":["-","-","Barbra Streisand","1942-04-24","-","Pop"]},{"id":37,"data":["Born in the U.S.A.","1984","Bruce Springsteen","1949-09-23","-","Rock"]},{"id":38,"data":["Dancing in the Dark","1984","Bruce Springsteen","1949-09-23","-","Rock"]},{"id":39,"data":["We've Only Just Begun","1970","Karen Carpenter","1950-03-02","-","Pop"]},{"id":40,"data":["Superstar","1971","Karen Carpenter","1950-03-02","-","Pop"]},{"id":41,"data":["Rainy Days And Mondays","1971","Karen Carpenter","1950-03-02","-","Pop"]},{"id":42,"data":["Top Of The World","1973","Karen Carpenter","1950-03-02","-","Pop"]},{"id":43,"data":["-","-","Frank Sinatra","1915-12-12","1998-05-14","Pop"]},{"id":44,"data":["-","-","Frank Sinatra","1915-12-12","1998-05-14","Pop"]},{"id":45,"data":["Lady","1980","Kenny Rogers","1938-08-21","-","Country"]},{"id":46,"data":["Islands in the Stream","1983","Kenny Rogers","1938-08-21","-","Country"]},{"id":47,"data":["Endless Love","1981","Lionel Richie","1949-06-20","-","Soul"]},{"id":48,"data":["All Night Long","1983","Lionel Richie","1949-06-20","-","Soul"]},{"id":49,"data":["Hello","1984","Lionel Richie","1949-06-20","-","Soul"]},{"id":50,"data":["Say You, Say Me","1985","Lionel Richie","1949-06-20","-","Soul"]}];

        return {
            columns: getColumns(),
            rows: rows
        };

    }());

}(jQuery));
 
 
 
 
  
  
 /*   
        
        var data = {
  "Artists": {
    "Artist": [
      {
        "Name": "Michael Jackson",
        "Genre": "Pop",
        "Born": "1958-08-29",
        "Died": "2009-06-25",
        "Title": [
          {
            "Name": "Billie Jean",
            "Released": "1983"
          },
          {
            "Name": "Beat It",
            "Released": "1983"
          },
          {
            "Name": "Thriller",
            "Released": "1984"
          },
          {
            "Name": "Bad",
            "Released": "1987"
          },
          {
            "Name": "I Just Can't Stop Loving You",
            "Released": "1987"
          },
          {
            "Name": "Man in the Mirror",
            "Released": "1987"
          },
          {
            "Name": "Black or White",
            "Released": "1991"
          }
        ]
      },
      {
        "Name": "John Lennon",
        "Genre": "Rock",
        "Born": "1940-10-09",
        "Died": "1980-12-08",
        "Title": [
          {
            "Name": "Please Mister Postman",
            "Released": "1963"
          },
          {
            "Name": "Ticket to Ride",
            "Released": "1965"
          },
          {
            "Name": "Come Together",
            "Released": "1969"
          }
        ]
      },
      {
        "Name": "Paul McCartney",
        "Genre": "Rock",
        "Born": "1942-06-18",
        "Title": [
          {
            "Name": "All My Loving",
            "Released": "1963"
          },
          {
            "Name": "Can't Buy Me Love",
            "Released": "1964"
          },
          {
            "Name": "Yesterday",
            "Released": "1965"
          },
          {
            "Name": "Ob-La-Di, Ob-La-Da",
            "Released": "1968"
          },
          {
            "Name": "Let It Be",
            "Released": "1970"
          },
          {
            "Name": "Get Back",
            "Released": "1970"
          }
        ]
      },
      {
        "Name": "Stevie Wonder",
        "Genre": "Pop",
        "Born": "1950-05-13",
        "Title": [
          {
            "Name": "Superstition",
            "Released": "1972"
          },
          {
            "Name": "Ebony and Ivory",
            "Released": "1982"
          },
          {
            "Name": "I Just Called to Say I Love You",
            "Released": "1984"
          }
        ]
      },
      {
        "Name": "Elvis Presley",
        "Genre": "Rock and Roll",
        "Born": "1935-01-08",
        "Died": "1977-08-16",
        "Title": [
          {
            "Name": "Love Me Tender",
            "Released": "1956"
          },
          {
            "Name": "Heartbreak Hotel",
            "Released": "1956"
          },
          {
            "Name": "All Shook Up",
            "Released": "1957"
          },
          {
            "Name": "Are You Lonesome Tonight?",
            "Released": "1960"
          }
        ]
      },
      {
        "Name": "Celine Dion",
        "Genre": "Pop",
        "Born": "1968-03-30",
        "Title": [
          {
            "Name": "The Power of Love",
            "Released": "1993"
          },
          {
            "Name": "Because You Loved Me",
            "Released": "1996"
          },
          {
            "Name": "It's All Coming Back to Me Now",
            "Released": "1996"
          },
          {
            "Name": "My Heart Will Go On",
            "Released": "1997"
          }
        ]
      },
      {
        "Name": "Elton John",
        "Genre": "Rock",
        "Born": "1947-03-25",
        "Title": [
          {
            "Name": "Rock n' Roll Madonna",
            "Released": "1970"
          },
          {
            "Name": "Victim of Love",
            "Released": "1979"
          }
        ]
      },
      {
        "Name": "Madonna",
        "Genre": "Pop",
        "Born": "1958-08-16",
        "Title": [
          {
            "Name": "Like a Virgin",
            "Released": "1984"
          },
          {
            "Name": "Papa Don't Preach",
            "Released": "1986"
          },
          {
            "Name": "La Isla Bonita",
            "Released": "1986"
          }
        ]
      },
      {
        "Name": "Mick Jagger",
        "Genre": "Rock",
        "Born": "1943-07-26",
        "Title": [
          {
            "Name": "Paint It Black",
            "Released": "1966"
          },
          {
            "Name": "(I Can't Get No) Satisfaction",
            "Released": "1965"
          }
        ]
      },
      {
        "Name": "Barbra Streisand",
        "Genre": "Pop",
        "Born": "1942-04-24",
        "Title": {
          "Name": "Woman in Love",
          "Released": "1980"
        }
      },
      {
        "Name": "Bruce Springsteen",
        "Genre": "Rock",
        "Born": "1949-09-23",
        "Title": [
          {
            "Name": "Born in the U.S.A.",
            "Released": "1984"
          },
          {
            "Name": "Dancing in the Dark",
            "Released": "1984"
          }
        ]
      },
      {
        "Name": "Karen Carpenter",
        "Genre": "Pop",
        "Born": "1950-03-02",
        "Title": [
          {
            "Name": "We've Only Just Begun",
            "Released": "1970"
          },
          {
            "Name": "Superstar",
            "Released": "1971"
          },
          {
            "Name": "Rainy Days And Mondays",
            "Released": "1971"
          },
          {
            "Name": "Top Of The World",
            "Released": "1973"
          }
        ]
      },
      {
        "Name": "Frank Sinatra",
        "Genre": "Pop",
        "Born": "1915-12-12",
        "Died": "1998-05-14",
        "Title": {
          "Name": "Fly Me To The Moon",
          "Released": "1964"
        }
      },
      {
        "Name": "Kenny Rogers",
        "Genre": "Country",
        "Born": "1938-08-21",
        "Title": [
          {
            "Name": "Lady",
            "Released": "1980"
          },
          {
            "Name": "Islands in the Stream",
            "Released": "1983"
          }
        ]
      },
      {
        "Name": "Lionel Richie",
        "Genre": "Soul",
        "Born": "1949-06-20",
        "Title": [
          {
            "Name": "Endless Love",
            "Released": "1981"
          },
          {
            "Name": "All Night Long",
            "Released": "1983"
          },
          {
            "Name": "Hello",
            "Released": "1984"
          },
          {
            "Name": "Say You, Say Me",
            "Released": "1985"
          }
        ]
      }
    ]
  }
};

var rows=[];
var counter=1;
for (var artist in data.Artists.Artist) {
    var aArtist = data.Artists.Artist[artist];
    for (var title in aArtist.Title) {
        var row = []            
        row.push(aArtist.Title[title].Name)
        row.push(aArtist.Title[title].Released)
        row.push(aArtist.Name)
        row.push(aArtist.Born)  
        row.push(aArtist.Died)
        row.push(aArtist.Genre)
        rows.push({id:counter++, data:row});
    }
}
console.log(JSON.stringify(rows))

*//**
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
    AF.Grid.MyRemoteStore = function (options) {

        options = $.extend(true, {
            urls: {
                load: "/dummyData?requestType=load",
                fetchRows: "/dummyData?requestType=fetchRows",
                filterData: "/dummyData?requestType=filterData",
                reOrderColumn: "/dummyData?requestType=reOrderColumn",
                sortData: "/dummyData?requestType=sortData",
                groupData: "/dummyData?requestType=groupData"
            }
        }, options);

        function fetchRows(requestData, onSuccess) {
            $.post(options.urls.fetchRows, requestData, onSuccess);
        }

        function filter(requestData, onSuccess) {
            $.post(options.urls.filterData, requestData, onSuccess);
        }

        function groupBy(requestData, onSuccess) {
            $.post(options.urls.groupData, requestData, onSuccess);
        }

        function sortBy(requestData, onSuccess) {
            $.post(options.urls.sortData, requestData, onSuccess);
        }

        function reorderColumn(requestData, onSuccess) {
            $.post(options.urls.reOrderColumn, requestData, onSuccess);
        }

        function load(requestData, onSuccess) {
            $.post(options.urls.load, requestData, onSuccess);
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
}(jQuery));