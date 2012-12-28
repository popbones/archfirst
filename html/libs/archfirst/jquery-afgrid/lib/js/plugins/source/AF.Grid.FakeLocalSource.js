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

    AF.Grid.fakeData = {};
    AF.Grid.FakeLocalSource = function (dataset) {

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

        function hasGroupByOrSortBy(stateData) {
            //noinspection OverlyComplexBooleanExpressionJS
            return (stateData.groupBy && stateData.groupBy.length) || (stateData.sortBy && stateData.sortBy.length);
        }

        function callAction(actionType, requestData, callback) {
            if (window.console) {
                console.log("SERVER CALL");
                console.log("requestData:", requestData, {string: JSON.stringify(requestData)});
            }
            var stateData = $.extend({}, dataset.state);
            stateData = $.extend(stateData, requestData.state);
            var fakeDataStoreColumns = $.extend(true, [], dataset.columns);
            var fakeDataStoreRows = AF.Grid.DataStore.utils.getFilteredRows($.extend(true, [], dataset.rows), stateData.filterBy, fakeDataStoreColumns, dataset.filters, true);
            if (hasGroupByOrSortBy(stateData)) {
                AF.Grid.DataStore.utils.sortData(stateData, fakeDataStoreColumns, fakeDataStoreRows, true);
            }
            var dummyResponseData = {};
            var pageSize = (requestData.pageSize || 25);
            if (actionType === "fetchRows") {
                dummyResponseData = {
                    rows: AF.Grid.DataStore.utils.getRows(stateData.pageOffset - 1, pageSize, fakeDataStoreRows)
                };
            } else {
                var dataSetCopy = $.extend({}, dataset);
                delete dataSetCopy.rows;
                delete dataSetCopy.columns;
                dummyResponseData = $.extend(dataSetCopy, dummyResponseData);
                dummyResponseData.state = stateData;
                dummyResponseData = $.extend({}, getDummyDataForFirstRequest(pageSize, fakeDataStoreColumns, fakeDataStoreRows), dummyResponseData);
                dummyResponseData.pageSize = pageSize;
                dummyResponseData.filters = dataset.filters;
                dummyResponseData.isGridGroupable = dataset.isGridGroupable;
                dummyResponseData.isGridSortable = dataset.isGridSortable;
                dummyResponseData.isGridFilterable = dataset.isGridFilterable;
                $.each(dummyResponseData.columns, function (i, column) {
                    delete column.filterData;
                });
            }
            if (dummyResponseData.rows[0] && dummyResponseData.rows[0].orig) {
                $.each(dummyResponseData.rows, function (i, row) {
                    dummyResponseData.rows[i] = row.orig;
                });
            }
            if (window.console) {
                console.log("responseData:", dummyResponseData, {string: JSON.stringify(dummyResponseData)});
            }
            asyncCallback(callback, dummyResponseData);
        }

        function asyncCallback(callback, dummyResponseData) {
            setTimeout(function () {
                callback(dummyResponseData);
            }, 100);
        }

        function getDummyDataForFirstRequest(pageSize, fakeDataStoreColumns, fakeDataStoreRows) {
            return {
                columns: fakeDataStoreColumns,
                rows: AF.Grid.DataStore.utils.getRows(0, pageSize, fakeDataStoreRows),
                state: {
                    groupBy: [],
                    sortBy: []
                },
                totalRows: fakeDataStoreRows.length,
                pageSize: pageSize
            };
        }

        return {
            load: load,
            fetchRows: fetchRows,
            filter: filter,
            groupBy: groupBy,
            sortBy: sortBy,
            reorderColumn: reorderColumn
        };
    };

    AF.Grid.FakeLocalSource.getFilterData = function (columnIdentifier, rows) {
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

}(jQuery));