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

})(jQuery);/**
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
AF.renderer = AF.renderer || {};

AF.renderer.Grid = function(options) {
	
	options = $.extend({
		id: null,
		afGridSelector: "#"+options.id,
		onSortBy: $.noop,
		onGroupBy: $.noop,
		onFilterBy: $.noop,
		onColumnReorder: $.noop,
        onGroupReorder: $.noop
	}, options);

	var $afGrid;
	
    function renderData(data) {
        var afGridData = $.extend({
            onScrollToBottom: options.fetchData,
            id: options.id,
            onSort: options.onSortBy,
			onGroupChange: options.onGroupBy,
			groupsPlaceHolder: "." + options.id + "-afGrid-group-by",
			canGroup: true,
            onFilter: options.onFilterBy,
			onColumnReorder: options.onColumnReorder,
			onColumnResize: options.onColumnResize,
            onGroupReorder: options.onGroupReorder,
			columnWidthOverride: null,
            onRowClick: options.onRowClick
		}, data);
        $afGrid.trigger($.afGrid.destroy);
        $afGrid.afGrid(afGridData);
    }

    function addNewRows(newData) {
        $afGrid.trigger($.afGrid.appendRows, [newData.rows]);
    }

    //Constructor
    (function init() {
		$afGrid = $(options.afGridSelector);
    })();

	return {
		renderData: renderData,
		addNewRows: addNewRows
	}
};

})(jQuery);/**
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

    $.afGrid = $.extend($.afGrid, {
        appendRows: "afGrid-append-rows",
		destroy: "afGrid-destroy",
		renderingComplete: "afGrid-rendering-complete"
    });

    $.afGrid.plugin = $.afGrid.plugin || {};

    $.fn.afGrid = function(options) {

        options = $.extend({
            id: null,
            rows: [],
            columns: [],
            canRowHover: true,
            canRowClick: true,
            onRowClick: $.noop,
            onScrollToBottom: $.noop,
			columnWidthOverride: null,
            headingRowsRenderer: renderHeadingRow,
            makeColumnDraggable: makeColumnDraggable,
            showTotalRows: true,
            totalRowLabelTemplate: "<div class='total-row-count'>Showing {loadedRows} of {totalRows}</div>"
        }, options);

		options.columnsHashMap = {};
		$.each(options.columns, function(i, column) {
			options.columnsHashMap[column.id] = i;	
		});
		
		if (options.columnWidthOverride) {
			$.each(options.columnWidthOverride, function(columnId, width) {
				options.columns[options.columnsHashMap[columnId]].width = width;	
			});
		}
		
        var plugins = {};

		var addedRows = [];
		
        if (!options.id) {
            throw "You need to provide id for the afGrid";
        }

        return this.each(function() {
			var cachedafGridData = {};
			var $afGrid = $(this);
			$afGrid.addClass("afGrid");
            var $head = renderHeading(options).wrap("<div class='afGrid-head'></div>").parent();
            var rowsAndGroup = renderRowsAndGroups(options, cachedafGridData);
			var $rows = rowsAndGroup.$rowsMainContainer;

			var $headingRows = $head; 

			var $afGridRows = $headingRows.add($rows);
			$afGrid.empty().append($afGridRows);
			
			var countOfLoadedRows = options.rows.length;
			
			if (options.showTotalRows) {
			    $afGrid.append(options.totalRowLabelTemplate.supplant({
			        totalRows: "",
			        loadedRows: ""
			    }));
			}
			
            $rows.bind("scroll.afGrid", onafGridScroll);
			var scrollBottomTimer;
			function onafGridScroll() {
                $headingRows.css({marginLeft:-1*this.scrollLeft});
				clearTimeout(scrollBottomTimer);
				scrollBottomTimer = setTimeout(function() {
                    var scrolled = ($rows[0].scrollHeight - $rows.scrollTop());
                    var containerHeight = $rows.outerHeight();
					if ((scrolled <= (containerHeight - 17)) || (scrolled <= (containerHeight))) {
						options.onScrollToBottom();
					}
				}, 100);
            }


			$afGrid.bind($.afGrid.destroy, destroy);
			function destroy() {
                $.each(plugins, function(key, plugin) {
                    plugin.destroy();
                });
                $.draggable && $afGrid.find(".afGrid-heading .cell").draggable("destroy");
				$head
                    .undelegate()
				    .unbind()
				    .empty()
				    .remove();
				$head = null;
				rowsAndGroup = null;
				$rows
                    .undelegate()
				    .unbind()
                    .remove();
				$rows = null;
				$afGrid
                    .unbind($.afGrid.destroy)
				    .unbind($.afGrid.appendRows)
                    .undelegate(".group .group-header", "click")
                    .undelegate(".afGrid-rows .row", "click")
                    .undelegate(".afGrid-rows .row", "mouseenter")
                    .undelegate(".afGrid-rows .row", "mouseleave")
				    .empty();
				options = null;
				$afGrid = null;
				cachedafGridData = null;
			}
			
            $afGrid.unbind($.afGrid.appendRows).bind($.afGrid.appendRows, onRowAppend);
			function onRowAppend(event, newRows) {
				addedRows = $.merge(addedRows, newRows);
				countOfLoadedRows += newRows.length;
				updateCountLabel();
                var totalRows = $afGrid.find(".afGrid-rows .row").length;
				var $groupContainers =  rowsAndGroup.lastGroupInformation.$groupContainers;
				var currentGroupValues = rowsAndGroup.lastGroupInformation.currentGroupValues;
				var $rowsMainContainer = rowsAndGroup.$rowsMainContainer;
				var isStartRowEven = $rowsMainContainer.find(".row:last").hasClass("even");
				rowsAndGroup.lastGroupInformation = addRows(options.id, newRows, options.columns, options.groupBy, $rowsMainContainer, $groupContainers, currentGroupValues, isStartRowEven, cachedafGridData);
            }
			function updateCountLabel() {
				if (options.showTotalRows) {
					$afGrid.find(".total-row-count").replaceWith(options.totalRowLabelTemplate.supplant({
						totalRows: options.totalRows,
						loadedRows: countOfLoadedRows
					}));
				}
			}
			
            if (options.canRowHover) {
                $afGrid
                    .undelegate(".afGrid-rows .row", "mouseenter")
                    .undelegate(".afGrid-rows .row", "mouseleave")
                    .delegate(".afGrid-rows .row", "mouseenter", function() {
                        $(this).addClass("row-hover");
                    })
                    .delegate(".afGrid-rows .row", "mouseleave", function() {
                        $(this).removeClass("row-hover");
                    });
            }

            if (options.canRowClick) {
                $afGrid.undelegate(".afGrid-rows .row", "click").delegate(".afGrid-rows .row", "click", function() {
					var rowId = $(this).attr("id").split("_")[1];
                    options.onRowClick(rowId, cachedafGridData[rowId]);
                });
            }
			
			updateCountLabel();

            $.each($.afGrid.plugin, function(key, plugin) {
                plugins[key] = plugin($afGrid, options, cachedafGridData);
                plugins[key].load();
            });
			
			$afGrid.trigger($.afGrid.renderingComplete);
        });

    };

    function makeColumnDraggable($afGrid) {
        $afGrid.find(".afGrid-heading .cell").draggable({
            helper: function(event) {
				return getHelper(event, $afGrid.attr("class"));
			},
            revert: false,
            cancel: ".resize-handle",
            appendTo: "body"
        });
    }

    function getHelper(event, cssClass) {
        return $(event.currentTarget)
                .clone(false)
                .wrap("<div class='afGrid-heading'></div>")
                .parent()
                .wrap("<div class='{cssClass} column-helper'></div>".supplant({cssClass:cssClass}))
                .parent().css("width","auto");
    }

	function renderHeading(options) {
		return renderHeadingRow(options.columns, {
			container: "<div class='afGrid-heading'></div>",
			cell: "<span class='cell {cssClass}' id='{id}'>{value}<span class='sort-arrow'></span></span>",
			cellContent: function(column) {
				return {
					value: column.label,
					id: options.id+"Col_"+column.id,
                    cssClass: column.renderer || ""
				}
			}			
		});
    }

	function renderHeadingRow(columns, template) {
		var $row = $(template.container);
		var colCount = columns.length; 
        $.each(columns, function(i, column) {
            if (column.render !== false) {
                var templateData = template.cellContent(column);
                templateData.cssClass = templateData.cssClass +
                                        (column.groupBy?" groupBy":"") +
                                        (i===colCount-1?" last":"") +
                                        (i===0?" first":"");
                var $cell = $(template.cell.supplant(templateData));
                $cell.css({width: column.width});
                $row.append($cell);
            }
        });
        return $row;
	}
	
    function renderRowsAndGroups(options, cachedafGridData) {
        var $rowsMainContainer = $("<div class='afGrid-rows'></div>");
        var lastGroupInformation = addRows(options.id, options.rows, options.columns, options.groupBy, $rowsMainContainer, null, [], false, cachedafGridData);
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
        return $("<div class='group level{level}'><div class='group-header'><span class='open-close-indicator'>-</span>{value}</div></div>".supplant({value: cellContent, level:n}));         
	}
	
    function renderGroupHeading($placeHolder, groups, level, currentValues, $groupContainers, columns) {
        var n, l, cellContent, $wrapper;
        if ($groupContainers===null) {
            $groupContainers = [];
            for (n = 0, l = groups.length; n<l; n++) {
                $groupContainers[n] = getGroupContainer(n, currentValues, columns);
                $wrapper = $("<div></div>");
                if (n!==0) {
                    $wrapper.append(getCell(columns[n-1], ""))
                }
                $wrapper.append($groupContainers[n]);
                $placeHolder.append($wrapper);
                $placeHolder = $groupContainers[n];
            }
        } else {
            for (n = level, l = groups.length; n<l; n++) {
                $groupContainers[n] = getGroupContainer(n, currentValues, columns);
                $wrapper = $("<div></div>");
                if (n===0) {
                    $wrapper.append($groupContainers[n]);
                    $placeHolder.append($wrapper);
                } else {
                    $wrapper.append(getCell(columns[n-1], ""));
                    $wrapper.append($groupContainers[n]);
                    $groupContainers[n-1].append($wrapper);
                }
            }
        }
        return $groupContainers;
    }

    function addRows(tableId, rows, columns, groups, $rowMainContainer, $groupContainers, currentGroupValues, isStartEven, afGridData) {
		var groupsLength = groups && groups.length;
		$.each(rows, function(i, row) {
            var rowId = row.id;
            var rowData = rowId?row.data:row;
			rowId && (afGridData[rowId]=row);
            var $rowContainer = $rowMainContainer;
            if (groups && groupsLength) {
                if ($groupContainers === null) {
                    $.each(groups, function(index, v) {
                        currentGroupValues[index] = rowData[index];
                    });
                    $groupContainers = renderGroupHeading($rowMainContainer, groups, null, currentGroupValues, $groupContainers, columns);
                } else {
                    $.each(groups, function(index, v) {
                        if (rowData[index] !== currentGroupValues[index]) {
                            for (var x = index; x < groupsLength; x++) {
                                currentGroupValues[x] = rowData[x];
                            }
                            $groupContainers = renderGroupHeading($rowMainContainer, groups, index, currentGroupValues, $groupContainers, columns);
                        }
                    });
                }
                $rowContainer = $groupContainers[groupsLength - 1]
            }
            var $row = getNewRow(tableId, rowId, row, groupsLength, columns);
            if ((i+(isStartEven?1:0))%2 === 0) {
                $row.addClass("even");
            }
            if (i === 0) {
                $row.addClass("row-first");
            }
            $rowContainer.append($row);
        });
		
		
		return {
			$groupContainers: $groupContainers,
			currentGroupValues: currentGroupValues	
		}
    }

    function getNewRow(tableId, rowId, row, groupLength, columns) {
        var rowId = row.id;
        var rowData = rowId?row.data:row;	
		var $row = $("<div class='row level{level}' id='{id}'></div>".supplant({
            level: groupLength,
            id: tableId + "DataRow_" + rowId
        }));
        var previousColumn = columns[groupLength-1];
        if (previousColumn) {
            $row.append(getCell(previousColumn, ""));	
        }
        for (var n=groupLength, l = rowData.length; n<l; n++) {
            var cellContent = rowData[n];
            if (columns[n].renderer) {
                cellContent = $.afGrid.renderer[columns[n].renderer](cellContent, columns[n], n, row);
            }
            $row.append(getCell(columns[n], cellContent));
        }
		$row.data("rowData", rowData);
        return $row;
    }
	
	function getCell(column, value) {
		var $cell = $("<span class='cell {columnId} {cssClass}'>{value}</span>".supplant({
            value: value,
            columnId: column.id,
            cssClass: column.renderer || ""
        }));
        $cell.css("width", column.width);
		return $cell;
	}

})(jQuery);

if (!Array.indexOf) {
  Array.prototype.indexOf = function (obj, start) {
    for (var i = (start || 0); i < this.length; i++) {
      if (this[i] == obj) {
        return i;
      }
    }
    return -1;
  }
}

if (!String.hasOwnProperty("supplant")) {
    String.prototype.supplant = function(jsonObject, keyPrefix) {
        return this.replace(/{([^{}]*)}/g, function (matchedString, capturedString1) {
	        var jsonPropertyKey = keyPrefix ? capturedString1.replace(keyPrefix+".", "") : capturedString1;
	        var jsonPropertyValue = jsonObject[jsonPropertyKey];
            return jsonPropertyValue !== undefined ? jsonPropertyValue : matchedString;
        });
    };
}/**
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

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            columnReorder: function($afGrid, options) {

                options = $.extend({
                    canReorderColumn: true,
                    onColumnReorder: $.noop
                }, options);

                function onColumnReorderDrop(event, ui) {
                    $(this).removeClass("reorder");
                    var columnIdToMove = ui.draggable.attr("id").split("_")[1];
                    var columnIdToMoveAfter = $(this).attr("id").split("_")[1];
                    var newColumnOrder = [];
                    $.each(options.columns, function(i, column) {
                        if (column.id !== columnIdToMove) {
                            newColumnOrder.push(column.id);
                        }
                        if (column.id === columnIdToMoveAfter) {
                            newColumnOrder.push(columnIdToMove);
                        }
                    });
                    options.onColumnReorder(newColumnOrder)
                }

                function load() {
                    if (!options.canReorderColumn) {
                        return;
                    }

                    $afGrid.find(".afGrid-heading .cell").droppable({
                        drop: onColumnReorderDrop,
                        over: onColumnReorderOver,
                        out: onColumnReorderOut,
                        accept: ".afGrid-heading .cell"
                    });

                    options.makeColumnDraggable($afGrid);
                }

                function destroy() {
                    options = null;
                    $afGrid.find(".afGrid-heading .cell").droppable("destroy");
                }

                return {
                    load: load,
                    destroy: destroy
                }
            }
        }
    });

    function onColumnReorderOver(event, ui) {
        $(this).addClass("reorder");
    }

    function onColumnReorderOut(event, ui) {
        $(this).removeClass("reorder");
    }

})(jQuery);

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

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            columnResize: function($afGrid, options) {

                options = $.extend({
                    canResizeColumn: true,
                    onColumnResize: $.noop,
                    minColumnWidth: 100,
                    maxColumnWidth: 700
                }, options);

                var columns = options.columns;

                function load() {
                    if (!options.canResizeColumn) {
                        return;
                    }
                    var $headingCells = $afGrid.find(".afGrid-heading .cell");
                    $headingCells.each(function() {
                        var $cell = $(this);
                        var $resizeHandle = $("<span class='resize-handle'></span>");
                        $resizeHandle.bind("click", function() {
                            return false;
                        });
                        
                        $resizeHandle.bind("mousedown", function(event) {
							var columnId = $(this).parents(".cell").eq(0).attr("id").split("_")[1];
							var posX;
							var originalWidth;
							var $guide;
							var newWidth;
							$guide = $("<div class='resize-guide'></div>");
							$guide.css({
								height: $afGrid.height(),
								top: $afGrid.position().top + parseInt($afGrid.css("margin-top"), 10),
								left: event.clientX
							});
							$("body").append($guide);
                            originalWidth = $cell.width();
                            posX = event.screenX;

							$(document).bind("mousemove.afGridResizeGuide", function(event) {
								newWidth = originalWidth + (event.screenX - posX);
                                if (newWidth <= options.minColumnWidth) {
                                    newWidth = options.minColumnWidth;
                                } else if (newWidth >= options.maxColumnWidth) {
                                    newWidth = options.maxColumnWidth;
                                } else {
								    $guide.css({left: event.clientX});
                                }
                                $cell.width(newWidth);
								options.columns[options.columnsHashMap[columnId]].width = newWidth;
								return false;
							});
						
							$(document).bind("mouseup.afGridResizeGuide", function() {
								$(document).unbind("mousemove.afGridResizeGuide mouseup.afGridResizeGuide");
								$guide.unbind();
								$guide.remove();
								posX = null;
								$afGrid.find(".afGrid-rows ."+columnId).width(newWidth);
								$afGrid.find(".afGrid-filter ."+columnId).width(newWidth);
								options.onColumnResize(columnId, originalWidth, newWidth);
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
                }
            }
        }
    });

})(jQuery);

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

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            filters: function($afGrid, options) {

                options = $.extend({
                    canFilter: true,
                    filterBy: null,
                    typeSearchDelay: 1500,
                    headingRowsRenderer: $.noop,
                    onFilter: $.noop
                }, options);


                var $filters;

				function onFilterChange(){
					$afGrid.data("lastFilter", $(this).attr("id"));
					if ($filters) {
						if ($(this).hasClass("select-filter") && !$(this).hasClass("filter-changed")) {
							return;
						}
							
						var filter = [];
						$filters.find(".input-filter").each(function(){
							var $ele = $(this);
							if ($ele.val() !== "") {
								filter.push({
									value: $ele.val(),
									id: $(this).attr("id").split("_")[1]
								});
							}
						});
						$filters.find(".select-filter").each(function(){
							var $ele = $(this);
							var checkedValues = $ele.multiselect("getChecked").map(function(){
							   return this.value;
							}).get();
							if (checkedValues.length) {
								filter.push({
									value: checkedValues,
									id: $ele.attr("id").split("_")[1]
								});
							}
						});
						
						forEachCustomFilter($filters, function($filter, type) {
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

                    if (!options.canFilter) {
                        return;
                    }

                    $filters = renderFilters(options);

                    var typeSearchDelayTimer = null;
                    $filters.find(".input-filter")
                            .bind("change.filter", onFilterChange)
                            .bind("keyup.filter", function() {
                                var ele = this;
                                window.clearTimeout(typeSearchDelayTimer);
                                typeSearchDelayTimer = window.setTimeout(function() {
                                    onFilterChange.call(ele);
                                    typeSearchDelayTimer = null;
                                }, options.typeSearchDelay);
                            });

					forEachCustomFilter($filters, function($filter, type) {
						$.afGrid.filter[type].init($filter, onFilterChange);
					});

                    if (options.filterBy) {
                        $.each(options.filterBy, function(i, filter) {
                            var $filter = $filters.find("#"+options.id+"Filter_"+filter.id);
                            if ($filter.length) {
                                if ($filter.hasClass("input-filter")) {
                                    $filter.val(filter.value);
                                } else if ($filter.hasClass("select-filter")) {
                                    var filterValues = filter.value;
                                    $filter.find("option").each(function() {
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

                    $filters.find(".select-filter").multiselect({
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

					var lastFilter = $afGrid.data("lastFilter");
					if (lastFilter) {
						$afGrid.bind($.afGrid.renderingComplete, function() {
							var $filter = $("#"+lastFilter);
							if ($filter.hasClass("select-filter") || $filter.hasClass("input-filter")) { 
								$("#"+lastFilter).focus();
							}
						});
					}
                }

                function onMutliSelectChange() {
                    $(this).addClass("filter-changed");
                }

                function destroy() {
                    $filters.find(".select-filter,.input-filter").unbind("change.filter");
                    $filters.find(".select-filter").multiselect("destroy");
					forEachCustomFilter($filters, function($filter, type) {
						$.afGrid.filter[type].destroy($filter);
					});					
                    $filters.empty();
                    $filters = null;
                    options = null;
                }

                return {
                    load: load,
                    destroy: destroy
                }
            }
        }
    });

    function renderFilters(options) {
		return options.headingRowsRenderer(options.columns, {
			container: "<div class='afGrid-filter'></div>",
			cell: "<span class='cell {columnId} {cssClass}' id='{id}'>{value}</span>",
			cellContent: function(column) {
				return {
					value: getFilter(column.filterData, options.id+"Filter_"+column.id),
					id: options.id+"ColFilter_"+column.id,
					columnId: column.id,
                    cssClass: ""
				}
			}
		});
    }

	function getFilter(filterData, id) {
		if (filterData===undefined) {
			return "";
		}
		if ($.isArray(filterData)) {
			var select = "<select id={id} class='select-filter' multiple='true'>{options}</select>";
			var options = [];
			$.each(filterData, function(i, value) {
				options[options.length] = "<option value='{value}'>{value}</option>".supplant({value: value});
			});
			return select.supplant({
				id: id,
				options: options.join("")
			});
		} else if (filterData === "") {
			var text = "<input id='{id}' type='text' class='input-filter'/>";
			return text.supplant({
				id: id
			});
		} else if ($.afGrid.filter[filterData]) {
			return $.afGrid.filter[filterData].render(id)
		}
		throw "Unknown filter type defined in column data.";
	}
	
	function forEachCustomFilter($filters, callback) {
		$.each($.afGrid.filter, function(key, value) {
			var $f = $filters.find("."+key+"-filter");
			$f.each(function() {
				callback($(this), key);
			});
		});		
	}
	
	function getFilterType($filter) {
		var type = "";
		$.each($.afGrid.filter, function(key, value) {
			if ($filter.hasClass(key+"-filter")) {
				type = key;
				return false;
			}
		});
		return type;
	}

})(jQuery);/**
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

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            groups: function($afGrid, options) {
                options = $.extend({
                    id: options.id,
                    canGroup: true,
                    onGroupChange: $.noop,
                    onGroupReorder: $.noop,
                    groupsPlaceHolder: null,
                    groupBy: null
                }, options);

                var $groupsMainContainer;
                var currentGroupColumnIds;

                function renderGroups(columns, groupedColumnIds) {
                    var groupedColumnIdsLength = groupedColumnIds.length;
                    if (groupedColumnIdsLength) {
                        $groupsMainContainer.find(".empty-message").hide();
                        var $groupContainer = $groupsMainContainer.find(".groups").show();
                        $groupContainer.empty();
                        var $groups = $j();
                        $j.each(groupedColumnIds, function(i, columnId) {
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
                    var newGroupColumnIds = $j.grep(currentGroupColumnIds, function(id, i) {
                        return id != columnId;
                    });
                    options.onGroupChange(newGroupColumnIds);
                }

                function onColumnGroupingDrop(event, ui) {
                    var columnId = ui.draggable.attr("id").split("_")[1];
                    if (currentGroupColumnIds && currentGroupColumnIds.indexOf(columnId)>-1) {
                        return false;
                    }
                    currentGroupColumnIds.push(columnId);
                    setTimeout(function() {
                        options.onGroupChange(currentGroupColumnIds);
                    },10);
                    return true;
                }

                function onGroupExpandCollapse() {
                    var $ele = $(this);
                    var currentState = !$ele.data("state");
                    $ele.data("state", currentState);
                    $ele.find(".open-close-indicator").html(currentState?"+":"-");
                    $ele.removeClass("open close").addClass(currentState?"close":"open");
                    $ele.parents(".group").eq(0).children(":not('.group-header:eq(0)')")[currentState?"hide":"show"]();
                }

                function onGroupReorderDrop(event, ui) {
                    $(this).removeClass("reorder");
                    var groupIdToMove = ui.draggable.attr("id").split("_")[1];
                    var groupIdToMoveAfter = $(this).attr("id").split("_")[1];
                    var newGroupOrder = [];
                    $.each(options.groupBy, function(i, columnId) {
                        if (columnId !== groupIdToMove) {
                            newGroupOrder.push(columnId);
                        }
                        if (columnId === groupIdToMoveAfter) {
                            newGroupOrder.push(groupIdToMove);
                        }
                    });
                    options.onGroupReorder(newGroupOrder);
                }

                function load() {
                    if (!options.canGroup) {
                        return;
                    }

                    $afGrid.undelegate(".group .group-header", "click").delegate(".group .group-header", "click", onGroupExpandCollapse);
                    $groupsMainContainer = $(options.groupsPlaceHolder).undelegate("a.remove", "click.groups").delegate("a.remove", "click.groups", function() {
                        removeColumnFromGroup($j(this).parents(".cell").eq(0).attr("id").split("_")[1]);
                        return false;
                    });
                    renderGroups(options.columns, options.groupBy);

                    $groupsMainContainer.droppable({
                        drop: onColumnGroupingDrop,
                        accept: "#" + options.id + " .groupBy",
                        activeClass: "ui-state-highlight"
                    });

                    $groupsMainContainer.find(".cell").draggable({
                        drop: onColumnGroupingDrop,
                        helper: getGroupHelper,
                        accept: "#" + options.id + " .groupBy",
                        containment: $groupsMainContainer
                    });

                    $groupsMainContainer.find(".cell").droppable({
                        accept: ".groups .cell",
                        drop: onGroupReorderDrop,
                        over: onGroupReorderOver,
                        out: onGroupReorderOut
                    });

                    options.makeColumnDraggable($afGrid);
                }

                function destroy() {
                    $groupsMainContainer.droppable("destroy");
                    $groupsMainContainer.find(".cell").droppable("destroy").draggable("destroy");
                    $groupsMainContainer.undelegate("a.remove", "click.groups");
                    $groupsMainContainer.find(".groups").empty();
                    $groupsMainContainer = null;
                    currentGroupColumnIds = null;
                    options = null;
                }

                return {
                    load: load,
                    destroy: destroy
                }
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

    function onGroupReorder(x,y,z) {
        console.log(x,y,z)
    }
})(jQuery);/**
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

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            sortable: function($afGrid, options) {

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
                    var $cell = $(this);
                    var columnId = this.id.split("_")[1];
                    $afGrid.find(".afGrid-heading .cell.sortable-column").not($cell)
                        .removeClass("asc desc")
                        .removeData("direction");
                    var direction = $cell.data("direction");
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
                    if (!options.canSort) {
                        return;
                    }

                    if (options.sortBy) {
                        var $column = $afGrid.find("#"+options.id+"Col_"+options.sortBy.column);
                        $column.addClass(options.sortBy.direction);
                        $column.data("direction", options.sortBy.direction);
                    }
					
					$.each(options.columns, function(index, column) {
						if (column.sortable!==false) {
							$afGrid.find("#"+options.id+"Col_"+column.id).addClass("sortable-column");
						}
					});
					
                    $afGrid.undelegate(".afGrid-heading .cell.sortable-column", "click").delegate(".afGrid-heading .cell.sortable-column", "click", onColumnSort);
					$afGrid.undelegate(".afGrid-heading .cell.sortable-column", "mouseenter").delegate(".afGrid-heading .cell.sortable-column", "mouseenter", function() {
						$(this).addClass("sort-hover");
					});
					$afGrid.undelegate(".afGrid-heading .cell.sortable-column", "mouseleave").delegate(".afGrid-heading .cell", "mouseleave", function() {
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
                }
            }
        }
    });

})(jQuery);

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
    $.server = $.server || {};
    $.server = $.extend($.server, {
        getData: function(url, data, callback) {
			if (url.indexOf('fakeStore')>-1) {
				$.server.fakeStore(url.split(".")[1], data, callback);
			} else {
				$.post(url, data, callback);
			}
        }
    });
})(jQuery);

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
    $.statePersistToCookie = {
		load: function(key, callback) {
			callback($.cookie(key));
		},
		save: function(key, value, callback) {
			$.cookie(key, value, {
				expires: 100, path: '/'			
			});
			if (callback) {
				callback();
			}
		}	
	}
})(jQuery);
