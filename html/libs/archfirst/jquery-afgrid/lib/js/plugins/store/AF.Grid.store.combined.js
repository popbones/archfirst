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

    var fakeDataStoreRows, fakeDataStoreColumns;

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

        function multiColumnSorting(TheArr, order, direction) {


            function sortMulti(objA, objB, n) {
                n = n || 0;
                var a = objA.data,
                    b = objB.data,
                    swap = swapValues(order[n], a, b);
                if ((order[n] === undefined) || (swap !== 0)) {
                    return swap * direction[n];
                } else if (n < order.length) {
                    return sortMulti(objA, objB, ++n);
                } else {
                    return null;
                }
            }

            TheArr.sort(sortMulti);

            function swapValues(colIndex, a, b) {
                var swap = 0;
                if (isNaN(a[colIndex] - b[colIndex])) {
                    if ((isNaN(a[colIndex])) && (isNaN(b[colIndex]))) {
                        swap = (b[colIndex] < a[colIndex]) - (a[colIndex] < b[colIndex]);
                    } else {
                        swap = (isNaN(a[colIndex]) ? 1 : -1);
                    }
                } else {
                    swap = (a[colIndex] - b[colIndex]);
                }
                return swap;
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
    
}(jQuery));/**
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
                width: 100
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