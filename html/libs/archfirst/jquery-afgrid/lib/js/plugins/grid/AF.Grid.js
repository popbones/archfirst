/*!
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

/*!
 * @author Manish Shanker
 * @revision $Rev$
 * @date $Date$
 */

(function ($) {
    "use strict";

    window.AF = window.AF || {};

    AF.Grid = function (options) {

        var defaultOptions = {
            id: null,
            dataSource: null,
            statePersist: $.statePersistToCookie,
            isGridGroupable: true,
            isGridSortable: true,
            groupsPlaceHolder: "." + options.id + "-afGrid-group-by",
            columnWidthOverride: null,
            pageSize: null,
            afGridSelector: "#" + options.id,
            onRowClick: $.noop,
            onSort: onSortBy,
            onGroupChange: onGroupBy,
            onGroupReorder: onGroupReorder,
            onFilter: onFilterBy,
            onColumnReorder: onColumnReorder,
            onColumnResize: onColumnResize,
            onScrollToBottom: fetchRowsIncrementally,
            onStateChange: $.noop,
            onReset: resetAndRefresh,
            onRefresh: refresh,
            onGridDataLoaded: $.noop,
            groupBy: [],
            clientCache: false
        };

        options = $.extend(true, {}, defaultOptions, options);

        var $afGrid = $();

        var store = new AF.Grid.DataStore(options.dataSource, options.clientCache),
            loadedRows = 0,
            totalRows = 0,
            pageSize = 0,
            columnData = null,
            afGridCurrentStateData;

        function render(data) {
            columnData = data.columns;
            totalRows = data.totalRows;
            loadedRows = data.rows.length;
            pageSize = data.pageSize || options.pageSize;
            data.columnWidthOverride = data.columnWidthOverride || afGridCurrentStateData.columnWidthOverride;
            if (data.groupBy && data.groupBy.length) {
                data.groupBy = $.map(data.groupBy, function (column) {
                    return column.id;
                });
            }
            if (data.sortBy && data.sortBy.length) {
                data.sortBy = {
                    column: data.sortBy[0].id,
                    direction: data.sortBy[0].direction
                };
            }
            renderData(data);
            afGridCurrentStateData.columnOrder = $.map(data.columns, function (column) {
                return column.id;
            });
            afGridCurrentStateData.hiddenColumns = data.hiddenColumns;
            saveStateOfCurrentGrid();
            $afGrid.trigger($.afGrid.hideLoading);
        }

        function saveStateOfCurrentGrid() {
            if (options.statePersist) {
                options.statePersist.save("afGridState_" + options.id, JSON.stringify(afGridCurrentStateData));
            }
            options.onStateChange(afGridCurrentStateData);
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
            if (loadedRows >= totalRows) {
                return;
            }
            var requestData = $.extend({}, afGridCurrentStateData, {
                pageOffset: loadedRows + 1,
                pageSize: pageSize
            });
            $afGrid.trigger($.afGrid.showLoading);
            store.fetchRows(requestData, onReceiveOfNewRows);
        }

        function onReceiveOfNewRows(newRows) {
            afGridCurrentStateData = afGridCurrentStateData || {};
            loadedRows += newRows.rows.length;
            addNewRows(newRows);
            $afGrid.trigger($.afGrid.hideLoading);
        }

        function onReceiveOfData(data) {
            afGridCurrentStateData = afGridCurrentStateData || {};
            afGridCurrentStateData.pageSize = options.pageSize = data.pageSize || afGridCurrentStateData.pageSize;
            afGridCurrentStateData = $.extend(true, afGridCurrentStateData, data.state);
            render(data);
        }

        function onFilterBy(filters) {
            afGridCurrentStateData.filterBy = filters;
            $afGrid.trigger($.afGrid.showLoading);
            store.filter(afGridCurrentStateData, render);
        }

        function onGroupBy(columnIds) {
            var newColumnOrder;
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
            afGridCurrentStateData.groupBy = columnIds.length ? $.map(columnIds, function (columnId) {
                var column = getColumnById(columnId).column;
                return {
                    id: columnId,
                    type: column.type || column.renderer || null,
                    direction: "desc"
                };
            }) : [];
            $afGrid.trigger($.afGrid.showLoading);
            store.groupBy(afGridCurrentStateData, render);
        }

        function onSortBy(columnId, direction) {
            var column = getColumnById(columnId).column;
            afGridCurrentStateData.sortBy = [
                {
                    id: columnId,
                    type: column.type || column.renderer || null,
                    direction: direction
                }
            ];
            $afGrid.trigger($.afGrid.showLoading);
            store.sortBy(afGridCurrentStateData, render);
        }

        function onColumnReorder(newColumnOrder) {
            var groupByColumnsLength, newGroupByColumns, n, foundColumn;

            if (afGridCurrentStateData.groupBy && afGridCurrentStateData.groupBy.length) {
                groupByColumnsLength = afGridCurrentStateData.groupBy.length;
                newGroupByColumns = [];
                for (n = 0; n < groupByColumnsLength; n += 1) {
                    foundColumn = getColumnById(newColumnOrder[n]);
                    if (foundColumn.column.isGroupable) {
                        newGroupByColumns.push(newColumnOrder[n]);
                    } else {
                        break;
                    }
                }
                afGridCurrentStateData.groupBy = $.map(newGroupByColumns, function (column) {
                    return {id: column, direction: "desc"};
                });
            }
            afGridCurrentStateData.columnOrder = newColumnOrder;
            $afGrid.trigger($.afGrid.showLoading);
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

        //noinspection JSUnusedLocalSymbols
        function onColumnResize(columnId, oldWidth, newWidth) {
            afGridCurrentStateData.columnWidthOverride = afGridCurrentStateData.columnWidthOverride || {};
            afGridCurrentStateData.columnWidthOverride[columnId] = newWidth;
            saveStateOfCurrentGrid();
        }

        function load(overrideState) {
            getCurrentState(function (currentStateData) {
                afGridCurrentStateData = overrideState || currentStateData || {};
                if (options.pageSize) {
                    afGridCurrentStateData.pageSize = options.pageSize;
                }
                store.load(afGridCurrentStateData, onReceiveOfData);
            });
        }

        function destroy() {
            $afGrid.unbind($.afGrid.renderingComplete);
            gridViewRefresh();
            if (store) {
                store.destroy();
                store = null;
            }
        }

        function refresh() {
            $afGrid.trigger($.afGrid.destroy);
            $afGrid.removeClass("afGrid-initialized");
            if (store) {
                store.refresh(afGridCurrentStateData, onReceiveOfData);
            }
        }

        function gridViewRefresh() {
            if (options.statePersist) {
                options.statePersist.save("afGridState_" + options.id, null);
            }
            afGridCurrentStateData = {};
            afGridCurrentStateData.pageSize = options.pageSize;
            $afGrid.trigger($.afGrid.destroy);
            $afGrid.removeClass("afGrid-initialized");
        }

        function resetAndRefresh(overrideState) {
            options.groupBy = [];
            options.state = {};
            options.columnWidthOverride = null;
            options.sortBy = [];
            options.filterBy = [];
            gridViewRefresh();
            afGridCurrentStateData = overrideState || null;
            if (store) {
                store.refresh(afGridCurrentStateData, onReceiveOfData);
            }
        }

        function getSource() {
            return options.dataSource;
        }

        function getCurrentMetaData() {
            return store.getCurrentMetaData();
        }

        function renderData(data) {
            var afGridData = $.extend(options, data);
            $afGrid = $(options.afGridSelector);
            $afGrid.bind($.afGrid.renderingComplete, options.onGridDataLoaded);
            $afGrid.afGrid(afGridData);
        }

        function addNewRows(newData) {
            $afGrid.trigger($.afGrid.appendRows, [newData.rows, afGridCurrentStateData.columnWidthOverride]);
        }

        function getDefaultOptions() {
            return defaultOptions;
        }

        function getCurrentOptions() {
            return $.extend({}, options);
        }

        return $.extend({}, AF.Grid.extension, {
            load: load,
            destroy: destroy,
            refresh: refresh,
            resetAndRefresh: resetAndRefresh,
            getDefaultOptions: getDefaultOptions,
            getCurrentOptions: getCurrentOptions,
            getCurrentMetaData: getCurrentMetaData,
            getSource: getSource
        });
    };

    AF.Grid.extension = {};

}(jQuery));