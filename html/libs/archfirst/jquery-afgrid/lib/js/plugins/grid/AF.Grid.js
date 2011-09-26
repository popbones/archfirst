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
 
(function($) {
 
window.AF = window.AF || {}; 
AF.Grid = function(options) {
	
	options = $.extend(true, {
		id: null,
		dataSource: "/dummyData",
		requestTypeParamName: {
			fetchRows: "fetchRows",
			filterData: "filterData",
			load: "load",
			reOrderColumn: "reOrderColumn",
			sortData: "sortData",
			groupData: "groupData"
		},
		statePersist: $.statePersistToCookie,
		onRowClick: defaultOnRowClick
	}, options);
	
    var renderer;

	var loadedRows = 0;
	var totalRows = 0;
    var rowsToLoad = 0;

    var columnData = null;

	var afGridCurrentStateData = {};
	
	function render(data) {
        columnData = data.columns;
		totalRows = data.totalRows;
		loadedRows = data.rows.length;
        rowsToLoad = data.rowsToLoad || 20;
		data.columnWidthOverride = afGridCurrentStateData.columnWidthOverride;
		renderer.renderData(data);
		afGridCurrentStateData.columnOrder = $.map(data.columns, function(column) {
            return column.id
        });
        saveStateOfCurrentGrid();
	}
	
	function saveStateOfCurrentGrid() {
		options.statePersist && options.statePersist.save("afGridState_" + options.id, JSON.stringify(afGridCurrentStateData));
	}
	
	function getCurrentState(callback) {
		options.statePersist && options.statePersist.load("afGridState_" + options.id, function(data) {
			callback(JSON.parse(data));
		});		
	}
	
    function fetchRowsIncrementally() {		
        //This can be fetched from the serve
		if (loadedRows+1>=totalRows) {
			return;
		}		
		var requestData = $.extend({}, afGridCurrentStateData, {
			loadFrom: loadedRows+1, 
			count: rowsToLoad,
            requestType: options.requestTypeParamName.fetchRows
		});		
        $.server.getData(options.dataSource, requestData, onRecieveOfNewRows);
    }

    function onRecieveOfNewRows(newRows) {
		loadedRows += newRows.rows.length;
	    renderer.addNewRows(newRows);
    }

    function onRecieveOfData(data) {
        render(data);		
    }

	function onFilterBy(filters) {
		//converting filters json to a format that will be easier to post and retrieve, to and from the server 
		afGridCurrentStateData.filterColumns = [];
		afGridCurrentStateData.filterValues = [];
		$.each(filters, function(i, filter){
			afGridCurrentStateData.filterColumns.push(filter.id);
			afGridCurrentStateData.filterValues.push(filter.value);
		});
		var requestData = $.extend({ requestType: options.requestTypeParamName.filterData}, afGridCurrentStateData);
        $.server.getData(options.dataSource, requestData, function(data) {
			render(data);
		});
	}

	function onGroupBy(columnIds) {
        if (afGridCurrentStateData.columnOrder) {
            var newColumnOrder = [];
            $.each(columnIds, function(i, value) {
                newColumnOrder.push(value);
            });
            $.each(afGridCurrentStateData.columnOrder, function(i, value) {
                if (newColumnOrder.indexOf(value)<0) {
                    newColumnOrder.push(value);
                }
            });
            afGridCurrentStateData.columnOrder = newColumnOrder;
        }
		afGridCurrentStateData.groupByColumns = columnIds.length ? columnIds : [];
		var requestData = $.extend({requestType: options.requestTypeParamName.groupData}, afGridCurrentStateData);
        $.server.getData(options.dataSource, requestData, function(data) {
			render(data);
		});
	}
		
    function onSortBy(columnId, direction) {
		afGridCurrentStateData.sortByColumn = columnId;
		afGridCurrentStateData.sortByDirection = direction;
		var requestData = $.extend({requestType: options.requestTypeParamName.sortData}, afGridCurrentStateData);
        $.server.getData(options.dataSource, requestData, function(data) {
			render(data);
		});
    }

    function onColumnReorder(newColumnOrder) {
        if (afGridCurrentStateData.groupByColumns) {
            var groupByColumnsLength = afGridCurrentStateData.groupByColumns.length;
            var newGroupByColumns = [];
            for (var n=0; n<groupByColumnsLength; n++) {
                var foundColumn = getColumnById(newColumnOrder[n]);
                if (foundColumn.column.groupBy) {
                    newGroupByColumns.push(newColumnOrder[n]);
                } else {
                    break;
                }
            }
            afGridCurrentStateData.groupByColumns = newGroupByColumns;
        }
        afGridCurrentStateData.columnOrder = newColumnOrder;
		var requestData = $.extend({requestType: options.requestTypeParamName.reOrderColumn}, afGridCurrentStateData);
        $.server.getData(options.dataSource, requestData, function(data) {
			render(data);
		});
    }

     function getColumnById(columnId) {
        var foundIndex = -1;
        var column = $.grep(columnData, function(column, index) {
            if (column.id === columnId) {
                foundIndex = index;
                return true;
            }
            return false;
        })[0];
        return {
            column: column,
            index: foundIndex
        }
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
		getCurrentState(function(currentStateData) {
			afGridCurrentStateData = currentStateData || {};		
			var requestData = $.extend({requestType: options.requestTypeParamName.load}, afGridCurrentStateData);
			$.server.getData(options.dataSource, requestData, onRecieveOfData);
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
    })();

	return {
		load: load
	};
};

})(jQuery);