(function ($) {

    $.server = $.server || {};
    var fakeDataStoreRows, fakeDataStoreColumns;

    $.server.fakeStore = function (url, data, callback) {
        fakeDataStoreColumns = $.extend(true, [], $.server.fakeStore[url].columns);
        fakeDataStoreRows = getFilteredRows($.extend(true, [], $.server.fakeStore[url].rows), data.filterColumns, data.filterValues);
        setupDataAsPerState(data);
        var dummyResponseData = getDummyResponseFromRequestData(data);
        switch (data.requestType) {
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

    $.server.fakeStore.getFilterData = function (columnIndex, rows) {
        var filterData = [];
        $.each(rows, function (i, row) {
            if (filterData.indexOf(row.data[columnIndex]) < 0) {
                filterData.push(row.data[columnIndex]);
            }
        });
        return filterData;
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
            reorderColumn(data.columnOrder);
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

    function reorderColumn(columnOrder) {
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

}(jQuery));