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

	if (!$.browser) {
		var browserVersion = /MSIE(.*?);/.exec(navigator.appVersion);
		$.browser = {
			msie: navigator && navigator.appName.indexOf("Microsoft") > -1,
			version: browserVersion && browserVersion[1]
		}
	}

	if ($.browser.msie && parseInt($.browser.version, 10) <= 7 && document.documentMode !== 8) {
		$("html").addClass("ie7below");
	}

	$.afGrid = $.extend($.afGrid, {
		appendRows: "afGrid-append-rows",
		destroy: "afGrid-destroy",
		renderingComplete: "afGrid-rendering-complete",
		adjustRowWidth: "afGrid-adjust-row-width",
		showLoading: "afGrid-showLoading",
		hideLoading: "afGrid-hideLoading",
		getElementId: function (id) {
			var ids = id.split("_");
			ids.splice(0, 1);
			return ids.join("_");
		}
	});

	$.afGrid.renderer = {};
	$.afGrid.filter = {};

	$.afGrid.plugin = $.afGrid.plugin || {};

	var gridPluginMap = {};

	var scrollBottomTimer;

	var TOTAL_ROW_LABEL_TEMPLATE = "<div class='total-row-count'>Showing {loadedRows} of {totalRows}</div>",
		GROUP_CONTAINER_WRAPPER_TEMPLATE = "<div class='group-data'></div>",
		HEADING_ROW_TEMPLATE = "<div class='afGrid-heading'></div>",
		HEADING_ROW_COLUMN_HELPER_TEMPLATE = "<div class='{cssClass} column-helper'></div>",
		HEADING_ROW_CONTAINER_TEMPLATE = "<div class='afGrid-head'></div>",
		HEADING_ROW_CELL_TEMPLATE = "<div class='cell {columnId} {cssClass}' id='{id}'><span class='label'>{value}</span></div>",
		GROUP_HEADING_TEMPLATE = "<div class='group level{level}'><div class='group-header group-header-row'><span class='open-close-indicator'>-</span></div></div>",
		ROW_TEMPLATE = "<div class='row level{level}' id='{id}'></div>",
		CELL_TEMPLATE = "<div class='cell {columnId} {cssClass} {spacerClass}'>{value}</div>",
		ROWS_CONTAINER_TEMPLATE = "<div class='afGrid-rows'><div class='afGrid-rows-content'></div></div>",
		LOADING_MESSAGE = "<div class='loading-message'>Loading...</div>";

//    var TOTAL_ROW_LABEL_TEMPLATE = "<div class='total-row-count'>Showing {loadedRows} of {totalRows}</div>",GROUP_CONTAINER_WRAPPER_TEMPLATE = "<table class='group-data'></table>",HEADING_ROW_TEMPLATE = "<tr class='afGrid-heading'></tr>",HEADING_ROW_COLUMN_HELPER_TEMPLATE = "<div class='{cssClass} column-helper'></div>",HEADING_ROW_CONTAINER_TEMPLATE = "<thead class='afGrid-head'></thead>",HEADING_ROW_CELL_TEMPLATE = "<td class='cell {cssClass}' id='{id}'>{value}<span class='sort-arrow'></span></td>",GROUP_HEADING_TEMPLATE = "<tr class='group level{level}'><tboby><tr class='group-header'><table><tr><td><span class='open-close-indicator'>-</span>{value}</td></tr></table></tbody></tr>",ROW_TEMPLATE = "<tr class='row level{level}' id='{id}'></tr>",CELL_TEMPLATE = "<td class='cell {columnId} {cssClass}'>{value}</td>",ROWS_CONTAINER_TEMPLATE = "<table class='afGrid-rows'><tbody class='afGrid-rows-content'></tbody></table>",LOADING_MESSAGE = "<div class='loading-message'>Loading...</div>";

    var DATA_ROW_KEY = "DataRow_";
    var HEADER_COL_KEY = "Col_";

	$.fn.afGrid = function (options) {

		options = $.extend({
			id: null,
			rows: [],
			columns: [],
			rowHover: true,
			onRowClick: null,
			onScrollToBottom: $.noop,
			columnWidthOverride: null,
			makeColumnDraggable: makeColumnDraggable,
			showTotalRows: true,
			groupDetails: null,
			groupDetailsInFirstColumnOnly: true,
			totalRowLabelTemplate: TOTAL_ROW_LABEL_TEMPLATE,
			loadingMessage: LOADING_MESSAGE
		}, options);

		var plugins = {};

		if (!(options.id && /^[a-zA-Z0-9]*$/.test(options.id))) {
			throw "You need to provide id for the afGrid and ensure that the id don't have any special characters in it.";
		}

		return this.each(function () {
			var $afGrid = $(this);
			var groupDetails = options.groupDetails;

			updateColumnHashMap(options);
			updateColumnWidth(options);

			//if (this.tagName !== "TABLE") {var prop = {id:$afGrid.attr("id"),class:$afGrid.attr("class"),cellSpacing:0,cellPadding:0};var $table = $("<table></table>").attr(prop);$afGrid.replaceWith($table);$afGrid = $table;}

			var cachedGridData = {},
				$head,
				rowsAndGroup = renderRowsAndGroups(options, cachedGridData, groupDetails),
				$rows = rowsAndGroup.$rowsMainContainer,
				countOfLoadedRows = options.rows.length,
				rowWidth;

			if ($afGrid.hasClass("afGrid-initialized")) {
				$rows = $afGrid.find(".afGrid-rows").empty().append($rows.children());
				rowsAndGroup.$rowsMainContainer = $rows;
				$head = $afGrid.find(".afGrid-head");
			} else {
				$afGrid.trigger($.afGrid.destroy);
				$head = renderHeading($afGrid, options).wrap(HEADING_ROW_CONTAINER_TEMPLATE).parent();
				$afGrid.addClass("afGrid").empty().append($head.add($rows));
				if (options.showTotalRows) {
					$afGrid.append(options.totalRowLabelTemplate.supplant({
						totalRows: "",
						loadedRows: ""
					}));
				}
				$afGrid.append(options.loadingMessage);
				$rows.bind("scroll.afGrid", function () {
					onafGridScroll($head, $rows, options);
					$afGrid.data("lastScrollPos", $rows[0].scrollLeft);
				});
				$afGrid.unbind($.afGrid.hideLoading).bind($.afGrid.hideLoading, function () {
					$afGrid.find(".loading-message").hide();
				});
				$afGrid.unbind($.afGrid.showLoading).bind($.afGrid.showLoading, function () {
					$afGrid.find(".loading-message").show();
				});
			}

			//Fix for the grid width issue
			adjustRowWidth();

			if ($rows && $rows.length) {
				$rows[0].scrollLeft = $afGrid.data("lastScrollPos");
			}

			function destroy() {
				destroyPlugins(plugins, options);
				unbindGridEvents($afGrid, $head, $rows);
				$head = null;
				rowsAndGroup = null;
				$rows = null;
				options = null;
				$afGrid = null;
				cachedGridData = null;
			}

			$afGrid.unbind($.afGrid.destroy).bind($.afGrid.destroy, destroy);

			//noinspection JSUnusedLocalSymbols
			function onRowAppend(event, newRows, columnWidthOverride) {
				countOfLoadedRows = addFetchedRow(newRows, countOfLoadedRows, $afGrid, options, columnWidthOverride, rowsAndGroup, cachedGridData, rowWidth, groupDetails);
			}

			$afGrid.unbind($.afGrid.appendRows).bind($.afGrid.appendRows, onRowAppend);

			function adjustRowWidth() {
				var gridRowWidth = 0;
				$head.find(".afGrid-heading .cell:visible").each(function () {
					gridRowWidth += $(this).outerWidth(true);
				});
				$afGrid.find(".afGrid-rows-content").css({minHeight: 1, overflow: "hidden", width: gridRowWidth});
			}

			$afGrid.unbind($.afGrid.adjustRowWidth).bind($.afGrid.adjustRowWidth, adjustRowWidth);

			if (options.rowHover) {
				$afGrid.undelegate(".afGrid-rows .row", "mouseenter").undelegate(".afGrid-rows .row", "mouseleave").delegate(".afGrid-rows .row", "mouseenter",function () {
					$(this).addClass("row-hover");
				}).delegate(".afGrid-rows .row", "mouseleave", function () {
						$(this).removeClass("row-hover");
					});
			}

			if (options.onRowClick) {
				$afGrid.undelegate(".afGrid-rows .row", "click").delegate(".afGrid-rows .row", "click", function () {
					var rowId = $.afGrid.getElementId($(this).attr("id"));
					options.onRowClick(cachedGridData[rowId].orig || cachedGridData[rowId], $(this));
				});
			}

			updateCountLabel($afGrid, options, countOfLoadedRows);

			var helper = {
				getColumnElementById: getColumnElementById,
                getRowElementById: getRowElementById,
                getColumnById: getColumnById,
                getCellContent: getCellContent
			};

			$.each($.afGrid.plugin, function (key, plugin) {
				if ($afGrid.hasClass("afGrid-initialized")) {
					plugins[key] = gridPluginMap[options.id][key];
					if (plugins[key].update) {
						plugins[key].update(cachedGridData);
					}
				} else {
					gridPluginMap[options.id] = gridPluginMap[options.id] || {};
					gridPluginMap[options.id][key] = plugins[key] = plugin($afGrid, options, cachedGridData);
					plugins[key].load(helper);
				}
			});

			$afGrid.addClass("afGrid-initialized");
			$afGrid.trigger($.afGrid.renderingComplete);

		});

	};

	function unbindGridEvents($afGrid, $head, $rows) {
		if ($.draggable) {
			$afGrid.find(".afGrid-heading .cell").draggable("destroy");
		}
		$head.undelegate().unbind().empty().remove();
		$rows.undelegate().unbind().remove();
		removeColumnDraggable($afGrid);
		$afGrid
			.unbind($.afGrid.hideLoading)
			.unbind($.afGrid.showLoading)
			.unbind($.afGrid.adjustRowWidth)
			.unbind($.afGrid.destroy)
			.unbind($.afGrid.appendRows)
			.undelegate(".group .group-header", "click")
			.undelegate(".afGrid-rows .row", "click")
			.undelegate(".afGrid-rows .row", "mouseenter")
			.undelegate(".afGrid-rows .row", "mouseleave")
			.empty();
		$afGrid.data("afGridColumnDraggable", false);
	}

	function addFetchedRow(newRows, countOfLoadedRows, $afGrid, options, columnWidthOverride, rowsAndGroup, cachedGridData, rowWidth, groupDetails) {
		countOfLoadedRows += newRows.length;
		updateCountLabel($afGrid, options, countOfLoadedRows);
		options.columnWidthOverride = columnWidthOverride;
		updateColumnWidth(options);
		var $groupContainers = rowsAndGroup.lastGroupInformation.$groupContainers,
			currentGroupValues = rowsAndGroup.lastGroupInformation.currentGroupValues,
			$rowsMainContainer = rowsAndGroup.$rowsMainContainer,
			isStartRowEven = $rowsMainContainer.find(".row:last").hasClass("even");
		rowsAndGroup.lastGroupInformation = addRows({
			tableId: options.id,
			rows: newRows,
			columns: options.columns,
			groups: options.groupBy,
			$rowMainContainer: $rowsMainContainer.find(".afGrid-rows-content"),
			$groupContainers: $groupContainers,
			currentGroupValues: currentGroupValues,
			isStartEven: isStartRowEven,
			cachedGridData: cachedGridData,
			rowWidth: rowWidth,
			groupDetails: groupDetails,
			areFetchedRows: true,
			groupDetailsInFirstColumnOnly: options.groupDetailsInFirstColumnOnly
		});
		if ($afGrid.find(".afGrid-rows")[0].scrollHeight <= $afGrid.find(".afGrid-rows").height()) {
			options.onScrollToBottom();
		}
		return countOfLoadedRows;
	}

	function destroyPlugins(plugins, options) {
		$.each(plugins, function (key, plugin) {
			if (plugin.destroy) {
				plugin.destroy();
			}
		});
		delete gridPluginMap[options.id];
	}

	function onafGridScroll($head, $rows, options) {
		var eleRow = $rows[0];
		$head.css({
			marginLeft: -1 * eleRow.scrollLeft
		});
		clearTimeout(scrollBottomTimer);
		scrollBottomTimer = setTimeout(function () {
			var scrolled = (eleRow.scrollHeight - $rows.scrollTop()),
				containerHeight = $rows.height();
			if ((scrolled <= (containerHeight - 17)) || (scrolled <= (containerHeight))) {
				options.onScrollToBottom();
			}
		}, 100);
	}

	function updateCountLabel($afGrid, options, countOfLoadedRows) {
		if (options.showTotalRows) {
			$afGrid.find(".total-row-count").replaceWith(options.totalRowLabelTemplate.supplant({
				totalRows: options.totalRows,
				loadedRows: countOfLoadedRows
			}));
		}
	}

	function updateColumnWidth(options) {
		if (options.columnWidthOverride) {
			$.each(options.columnWidthOverride, function (columnId, width) {
				if (options.columnsHashMap[columnId]) {
					options.columns[options.columnsHashMap[columnId]].width = width;
				}
			});
		}
	}

	function updateColumnHashMap(options) {
		options.columnsHashMap = {};
		$.each(options.columns, function (i, column) {
			options.columnsHashMap[column.id] = i;
		});
	}

	function getRowElementById(rowId, options) {
		return $("#" + options.id + DATA_ROW_KEY + rowId);
	}

	function getColumnElementById(columnId, options) {
		return $("#" + options.id + HEADER_COL_KEY + columnId);
	}

	function makeColumnDraggable($afGrid) {
		if (!$afGrid.data("afGridColumnDraggable")) {
			if ($.fn.draggable) {
				$afGrid.find(".afGrid-heading .cell").draggable({
					helper: function (event) {
						return getHelper(event, $afGrid.attr("class"));
					},
					revert: false,
					cancel: ".resize-handle",
					appendTo: "body",
					refreshPositions: true,
					cursorAt: { top: 0, left: 0 }
				});
			}
			$afGrid.data("afGridColumnDraggable", true);
		}
	}

	function removeColumnDraggable($afGrid) {
		if ($.fn.draggable) {
			$afGrid.find(".afGrid-heading .cell").draggable("destroy");
		}
		$afGrid.removeData("afGridColumnDraggable");
	}

	function getHelper(event, cssClass) {
		return $(event.currentTarget).clone(false).wrap(HEADING_ROW_TEMPLATE).parent().wrap(HEADING_ROW_COLUMN_HELPER_TEMPLATE.supplant({
			cssClass: cssClass
		})).parent().css("width", "auto");
	}

	function renderHeading($afGrid, options) {
		return headingRowElementsRenderer($afGrid, options.columns, {
			container: HEADING_ROW_TEMPLATE,
			cell: HEADING_ROW_CELL_TEMPLATE,
			cellContent: function (column) {
                return {
					value: column.label,
					id: options.id + HEADER_COL_KEY + column.id,
					cssClass: column.type || column.renderer || "",
					columnId: column.id
				};
			}
		}, options.id);
	}

	function headingRowElementsRenderer($afGrid, columns, template, gridId) {
		var $row = $(template.container),
			colCount = columns.length;
		$.each(columns, function (i, column) {
			if (column.render !== false) {
				var templateData = template.cellContent(column),
					$cell;
				templateData.cssClass = templateData.cssClass + (i === colCount - 1 ? " last" : "") + (i === 0 ? " first" : "");
				if ($.afGrid.renderer[column.type] && $.afGrid.renderer[column.type]["headerCell"]) {
					templateData.value = $.afGrid.renderer[column.type].headerCell($afGrid, column, columns, gridId);
				}
				$cell = $(template.cell.supplant(templateData));
				$cell.css({
					width: column.width,
					display: column.isHidden ? "none" : ""
				});
				$row.append($cell);
			}
		});
		return $row;
	}

	function renderRowsAndGroups(options, cachedGridData, groupDetails) {
		var $rowsMainContainer = $(ROWS_CONTAINER_TEMPLATE),
			lastGroupInformation = addRows({
				tableId: options.id,
				rows: options.rows,
				columns: options.columns,
				groups: options.groupBy,
				$rowMainContainer: $rowsMainContainer.find(".afGrid-rows-content"),
				$groupContainers: null,
				currentGroupValues: [],
				isStartEven: false,
				cachedGridData: cachedGridData,
				rowWidth: null,
				groupDetails: groupDetails,
				areFetchedRows: false,
				groupDetailsInFirstColumnOnly: options.groupDetailsInFirstColumnOnly
			});
		return {
			$rowsMainContainer: $rowsMainContainer,
			lastGroupInformation: lastGroupInformation
		};
	}

	function getColumnById(id, columns) {
		return $.grep(columns, function (col) {
			return col["id"] === id;
		})[0];
	}

	function getGroupDetailByRefLabel(refLabel, groupDetails) {
		if (groupDetails) {
			return $.grep(groupDetails, function (groupDetail) {
				return groupDetail && (groupDetail.refLabel === refLabel);
			})[0];
		}
		return null;
	}

	function getCurrentGroupDetail(currentValues, groupDetails, n) {
		var groupDetail = getGroupDetailByRefLabel(currentValues[0], groupDetails);
		for (var n1 = 1; n1 <= n; n1++) {
			groupDetail = groupDetail && getGroupDetailByRefLabel(currentValues[n1], groupDetail.groupDetails);
		}
		return groupDetail;
	}

	function getGroupDetailText(currentValues, groupDetails, n, columns) {
		var groupDetail = getCurrentGroupDetail(currentValues, groupDetails, n);
		var groupDetailText = [];
		if (groupDetail) {
			$.each(groupDetail, function (key, value) {
				var column = getColumnById(key, columns);
				if (column) {
					groupDetailText[groupDetailText.length] = column.label + ": " + getCellContent(value, column);
				}
			});
			return "[" + groupDetailText.join(", ") + "]";
		}
		return "";
	}

	function renderGroupDetail(parameters) {
		var n = parameters.n,
			columns = parameters.columns,
			$groupContainers = parameters.$groupContainers,
			groupDetails = parameters.groupDetails,
			currentGroupValues = parameters.currentGroupValues,
			cellContent, $row = $(),
			groupDetailInFirstColumnOnly = parameters.groupDetailsInFirstColumnOnly,
			groupDetail;
		if (groupDetails && groupDetails.length) {
			groupDetail = getCurrentGroupDetail(currentGroupValues, groupDetails, n);
		}
		for (var n1 = n; n1 < columns.length; n1++) {
			cellContent = "";
			var column = columns[n1];
			if (n1 === n) {
				if (groupDetailInFirstColumnOnly) {
					var groupDetailText = "";
					if (groupDetails && groupDetails.length) {
                        if (groupDetail.label) {
                            cellContent = groupDetail.label;
                        } else {
                            groupDetailText = getGroupDetailText(currentGroupValues, groupDetails, n, columns);
                            cellContent = getCellContent(currentGroupValues[n], columns[n]) + " " + groupDetailText;
                        }
					} else {
                        cellContent = getCellContent(currentGroupValues[n], columns[n]);
                    }
				} else {
					cellContent = (groupDetail && groupDetail.label) || getCellContent(currentGroupValues[n], column);
				}
			} else if (!groupDetailInFirstColumnOnly && groupDetail && groupDetail[column.id]) {
				cellContent = groupDetail && getCellContent(groupDetail[column.id], column);
			}
			var $cell = getCell(column, cellContent, "");
			if (n1 === n) {
				$cell.addClass("first-cell-in-group")
			}
			$row = $row.add($cell)
		}
		$groupContainers[n].find(".group-header").append($row).addClass(groupDetailInFirstColumnOnly ? "details-in-first-column" : "");
	}

	function renderAndGetContainerForFirstLoad($groupContainers, n, columns, $placeHolder) {
		$groupContainers[n] = $(GROUP_HEADING_TEMPLATE.supplant({ level: n }));
		var $wrapper = $(GROUP_CONTAINER_WRAPPER_TEMPLATE);
		if (n !== 0) {
			$wrapper.append(getCell(columns[n - 1], "", "spacer"));
		}
		$wrapper.append($groupContainers[n]);
		$placeHolder.append($wrapper);
		$placeHolder = $groupContainers[n];
		return {$wrapper: $wrapper, $placeHolder: $placeHolder};
	}

	function renderAndGetContainerForFetchedRows($groupContainers, n, columns, $placeHolder) {
		$groupContainers[n] = $(GROUP_HEADING_TEMPLATE.supplant({ level: n }));
		var $wrapper = $(GROUP_CONTAINER_WRAPPER_TEMPLATE);
		if (n === 0) {
			$wrapper.append($groupContainers[n]);
			$placeHolder.append($wrapper);
		} else {
			$wrapper.append(getCell(columns[n - 1], "", "spacer"));
			$wrapper.append($groupContainers[n]);
			$groupContainers[n - 1].append($wrapper);
		}
		return {$wrapper: $wrapper, $placeHolder: $placeHolder};
	}

	function renderGroupHeading(parameters) {
		var $placeHolder = parameters.$placeHolder,
			groups = parameters.groups,
			level = parameters.level,
			currentGroupValues = parameters.currentGroupValues,
			columns = parameters.columns,
			groupDetails = parameters.groupDetails,
			n, l, $wrapper, $groupContainers, start, methodToCall;
		if (parameters.$groupContainers === null) {
			$groupContainers = [];
			start = 0;
			methodToCall = renderAndGetContainerForFirstLoad;
		} else {
			$groupContainers = parameters.$groupContainers;
			start = level;
			methodToCall = renderAndGetContainerForFetchedRows;
		}
		for (n = start, l = groups.length; n < l; n += 1) {
			var containers = methodToCall($groupContainers, n, columns, $placeHolder);
			$wrapper = containers.$wrapper;
			$placeHolder = containers.$placeHolder;
			renderGroupDetail({
				n: n,
				columns: columns,
				$groupContainers: $groupContainers,
				groupDetails: groupDetails,
				currentGroupValues: currentGroupValues,
				groupDetailsInFirstColumnOnly: parameters.groupDetailsInFirstColumnOnly
			});
		}
		return $groupContainers;
	}

	function addRows(parameters) {
		var tableId = parameters.tableId;
		var rows = parameters.rows;
		var columns = parameters.columns;
		var groups = parameters.groups;
		var $rowMainContainer = parameters.$rowMainContainer;
		var $groupContainers = parameters.$groupContainers;
		var areFetchedRows = parameters.areFetchedRows;
		var currentGroupValues = parameters.currentGroupValues;
		var isStartEven = parameters.isStartEven;
		var cachedGridData = parameters.cachedGridData;
		var rowWidth = parameters.rowWidth;
		var groupDetails = parameters.groupDetails;
		var groupsLength = groups && groups.length;
		var idPostFix = new Date().getTime() + Math.floor(Math.random() * 100);
		$.each(rows, function (i, row) {
			row.id = row.id || tableId + "Row" + (idPostFix + i);
			var rowId = row.id,
				rowData = rowId ? row.data : row,
				$rowContainer = $rowMainContainer,
				$row;
			if (rowId) {
				(cachedGridData[rowId] = row);
			}
			if (groupsLength) {
				if ($groupContainers === null) {
					$.each(groups, function (index) {
						currentGroupValues[index] = rowData[index];
					});
					$groupContainers = renderGroupHeading({
						$placeHolder: $rowMainContainer,
						groups: groups,
						level: null,
						currentGroupValues: currentGroupValues,
						$groupContainers: $groupContainers,
						columns: columns,
						groupDetails: groupDetails,
						groupDetailsInFirstColumnOnly: parameters.groupDetailsInFirstColumnOnly
					});
				} else {
					$.each(groups, function (index) {
						var x;
						if (rowData[index] !== currentGroupValues[index]) {
							for (x = index; x < groupsLength; x += 1) {
								currentGroupValues[x] = rowData[x];
							}
							$groupContainers = renderGroupHeading({
								$placeHolder: $rowMainContainer,
								groups: groups,
								level: index,
								currentGroupValues: currentGroupValues,
								$groupContainers: $groupContainers,
								columns: columns,
								groupDetails: groupDetails,
								groupDetailsInFirstColumnOnly: parameters.groupDetailsInFirstColumnOnly
							});
						}
					});
				}
				$rowContainer = $groupContainers[groupsLength - 1];
			}
			$row = getNewRow(tableId, row, groupsLength, columns);
			if ((i + (isStartEven ? 1 : 0)) % 2 === 0) {
				$row.addClass("even");
			}
			if (i === 0 && !areFetchedRows) {
				$row.addClass("row-first");
			}
			if (rowWidth) {
				$row.css("width", rowWidth);
			}
			$rowContainer.append($row);
		});

		return {
			$groupContainers: $groupContainers,
			currentGroupValues: currentGroupValues
		};
	}

    function getCellContent(cellContent, column, columnIndex, row) {
        var cellRenderer = (column.type || column.renderer);
        if (cellRenderer) {
            cellContent = $.afGrid.renderer[cellRenderer].cell(cellContent, column, columnIndex, row);
        }
        return cellContent;
    }

    function getNewRow(tableId, row, groupLength, columns) {
		var rowId = row.id;
        var rowData = rowId ? row.data : row,
			$row = $(ROW_TEMPLATE.supplant({
				level: groupLength,
				id: tableId + DATA_ROW_KEY + rowId
			})),
			previousColumn = columns[groupLength - 1];
		var n, l;
		if (previousColumn) {
			$row.append(getCell(previousColumn, ""));
		}
		for (n = groupLength, l = rowData.length; n < l; n += 1) {
            $row.append(getCell(columns[n], getCellContent(rowData[n], columns[n], n, row), null, n === (l - 1)));
		}
		return $row;
	}

	function getCell(column, value, spacerClass, isLastCell) {
		var $cell = $(CELL_TEMPLATE.supplant({
			value: value || "&nbsp;",
			columnId: column.id,
			cssClass: (column.type || column.renderer || "") + (isLastCell ? " last" : ""),
			spacerClass: spacerClass || ""
		}));
		$cell.css({
			"width": column.width,
			"display": column.isHidden ? "none" : ""
		});
		$cell.css("width", column.width);
		return $cell;
	}

}(jQuery));

if (!Array.indexOf) {
	Array.prototype.indexOf = function (obj, start) {
		"use strict";

		var i, l;
		for (i = (start || 0), l = this.length; i < l; i += 1) {
			if (this[i] === obj) {
				return i;
			}
		}
		return -1;
	};
}

if (!String.hasOwnProperty("supplant")) {
	String.prototype.supplant = function (jsonObject, keyPrefix) {
		"use strict";

		return this.replace(/\{([^{}]*)\}/g, function (matchedString, capturedString1) {
			var jsonPropertyKey = keyPrefix ? capturedString1.replace(keyPrefix + ".", "") : capturedString1,
				jsonPropertyValue = jsonObject[jsonPropertyKey];
			return jsonPropertyValue !== undefined ? jsonPropertyValue : matchedString;
		});
	};
}
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

    var START_SCROLL_PROXIMITY = 100;

    var DIRECTION = {
        LEFT: "LEFT",
        RIGHT: "RIGHT"
    };

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            columnReorder: function ($afGrid, options) {

                var gridWidth, gridLeftOffset, $rowsContainer, $headingContainer;
                var direction = DIRECTION.RIGHT;

                options = $.extend({
                    isGridColumnReorderable: true,
                    onColumnReorder: $.noop
                }, options);

                function onColumnReorderDrop(event, ui) {
                    onColumnReordered(event, ui, options, $afGrid, direction);
                }

                function onReorderOver(event) {
                    onColumnReorderOver($(event.target), direction);
                }

                function load() {
                    if (!options.isGridColumnReorderable) {
                        return;
                    }
                    gridLeftOffset = $afGrid.offset().left;
                    gridWidth = $afGrid.width();
                    $rowsContainer = $afGrid.find(".afGrid-rows");
                    $headingContainer = $afGrid.find(".afGrid-heading");
                    var cellSelector = ".afGrid-heading .cell";
                    var scrollInterval, scrollLeftBy;

                    $afGrid.delegate(cellSelector, "dragstop", function () {
                        $afGrid.undelegate(".afGrid-heading .cell", "mouseout.reorder");
                        $afGrid.undelegate(".afGrid-heading .cell", "mousemove.reorder");
                        window.clearInterval(scrollInterval);
                    });

                    $afGrid.delegate(cellSelector, "dragstart", function (e) {
                        window.clearInterval(scrollInterval);
                        var currentTarget = e.currentTarget;
                        $afGrid.delegate(".afGrid-heading .cell", "mousemove.reorder", function (e) {
                            if (e.currentTarget.id !== currentTarget.id) {
                                direction = (e.clientX < ($(this).offset().left + ($(this).width() / 2))) ? DIRECTION.LEFT : DIRECTION.RIGHT;
                                onColumnReorderOver($(this), direction);
                            }
                        });
                        $afGrid.delegate(".afGrid-heading .cell", "mouseout.reorder", function () {
                            $(this).removeClass("reorder-left reorder-right");
                        });
                    });


                    $afGrid.delegate(cellSelector, "drag", function (event) {
                        if (event.clientX > (gridLeftOffset - START_SCROLL_PROXIMITY) && event.clientX < (gridLeftOffset + START_SCROLL_PROXIMITY)) {
                            window.clearInterval(scrollInterval);
                            scrollLeftBy = $rowsContainer[0].scrollLeft;
                            scrollInterval = window.setInterval(function () {
                                if ($rowsContainer[0].scrollLeft > 0) {
                                    $rowsContainer[0].scrollLeft -= 10;
                                }
                            }, 50);
                        } else if (event.clientX > (gridLeftOffset + gridWidth - START_SCROLL_PROXIMITY) && event.clientX < (gridLeftOffset + gridWidth + START_SCROLL_PROXIMITY)) {
                            window.clearInterval(scrollInterval);
                            scrollLeftBy = $rowsContainer[0].scrollLeft + $headingContainer.width() + 100;
                            scrollInterval = window.setInterval(function () {
                                if ($rowsContainer[0].scrollLeft < scrollLeftBy) {
                                    $rowsContainer[0].scrollLeft += 10;
                                }
                            }, 50);
                        } else {
                            window.clearInterval(scrollInterval);
                        }
                    });

                    if ($.fn.droppable) {
                        $afGrid.find(cellSelector).droppable({
                            drop: onColumnReorderDrop,
                            over: onReorderOver,
                            out: onColumnReorderOut,
                            accept: cellSelector,
                            tolerance: "pointer"
                        });
                    }

                    options.makeColumnDraggable($afGrid);
                }

                function update() {
                    gridLeftOffset = $afGrid.offset().left;
                    gridWidth = $afGrid.width();
                    $rowsContainer = $afGrid.find(".afGrid-rows");
                    $headingContainer = $afGrid.find(".afGrid-heading");
                }

                function destroy() {
                    options = null;
                    if ($.fn.droppable) {
                        $afGrid.find(".afGrid-heading .cell").droppable("destroy");
                    }
                    $afGrid.undelegate(".afGrid-heading .cell", "drag");
                    $afGrid.undelegate(".afGrid-heading .cell", "dragstop");
                    $rowsContainer = null;
                    $headingContainer = null;
                }

                return {
                    load: load,
                    update: update,
                    destroy: destroy
                };
            }
        }
    });

    function onColumnReordered(event, ui, options, $afGrid, direction) {
        var $ele = $(event.target);
        $ele.removeClass("reorder-left reorder-right");
        var columnIdToMove = $.afGrid.getElementId(ui.draggable.attr("id")),
            columnIdToMoveAfter = $.afGrid.getElementId($ele.attr("id")),
            newColumnOrder = [];
        $.each(options.columns, function (i, column) {
            if (column.id !== columnIdToMove) {
                newColumnOrder.push(column.id);
            }
            if (column.id === columnIdToMoveAfter) {
                if (direction === DIRECTION.RIGHT) {
                    newColumnOrder.push(columnIdToMove);
                } else {
                    newColumnOrder.splice((newColumnOrder.length - 1), 0, columnIdToMove);
                }
            }
        });
        $afGrid.removeClass("afGrid-initialized");
        options.onColumnReorder(newColumnOrder);
    }

    function onColumnReorderOver($ele, direction) {
        $ele.removeClass("reorder-left reorder-right").addClass(direction === DIRECTION.LEFT ? "reorder-left" : "reorder-right");
    }

    function onColumnReorderOut(event) {
        $(event.target).removeClass("reorder-left reorder-right");
    }

}(jQuery));
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

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            columnResize: function ($afGrid, options) {
                options = $.extend({
                    isGridColumnResizable: true,
                    onColumnResize: $.noop,
                    minColumnWidth: 30,
                    maxColumnWidth: 700
                }, options);

                var columns = options.columns;

                function load(helper) {
                    if (!options.isGridColumnResizable) {
                        return;
                    }

                    $.each(options.columns, function (index, column) {
                        if (column.isResizable !== false) {
                            helper.getColumnElementById(column.id, options)
                                .append("<span class='resize-handle'></span>")
                                .addClass("resizable-column");
                        }
                    });


                    var $headingRow = $afGrid.find(".afGrid-heading");

                    undelegateEvents();

                    $headingRow.delegate(".resize-handle", "click", function () {
                        return false;
                    });

                    $headingRow.delegate(".resize-handle", "mousedown", function () {
                        var $cell = $(this).parents(".cell").eq(0);
                        var $resizeHandle = $(this);
                        var columnId = $.afGrid.getElementId($cell.attr("id")),
                            posX,
                            originalWidth,
                            $guide,
                            newWidth;
                        $guide = $("<div class='resize-guide'></div>");
                        $guide.css({
                            height: $afGrid.height(),
                            top: 0,
                            left: $resizeHandle.offset().left - $afGrid.offset().left + $resizeHandle.width()
                        });
                        $afGrid.append($guide);
                        originalWidth = $cell.width();
                        posX = event.screenX;

                        $(document).bind("mousemove.afGridResizeGuide", function (event) {
                            newWidth = originalWidth + (event.screenX - posX);
                            if (newWidth <= options.minColumnWidth) {
                                newWidth = options.minColumnWidth;
                            } else if (newWidth >= options.maxColumnWidth) {
                                newWidth = options.maxColumnWidth;
                            }
                            $guide.css({
                                left: $resizeHandle.offset().left - $afGrid.offset().left + $resizeHandle.width()
                            });
                            $cell.width(newWidth);
                            options.columns[options.columnsHashMap[columnId]].width = newWidth;
                            return false;
                        });

                        $(document).bind("mouseup.afGridResizeGuide", function () {
                            $(document).unbind("mousemove.afGridResizeGuide mouseup.afGridResizeGuide");
                            $guide.unbind();
                            $guide.remove();
                            posX = null;
                            $afGrid.find(".afGrid-rows ." + columnId).width(newWidth);
                            $afGrid.find(".afGrid-filter ." + columnId).width(newWidth);
                            options.onColumnResize(columnId, originalWidth, newWidth);
                            $afGrid.trigger($.afGrid.adjustRowWidth);
                            return false;
                        });
                        return false;
                    });

                }


                function undelegateEvents() {
                    var $headingRow = $afGrid.find(".afGrid-heading");
                    $headingRow.undelegate(".resize-handle", "mousedown");
                    $headingRow.undelegate(".resize-handle", "click");
                }

                function destroy() {
                    undelegateEvents();
                    columns = null;
                    options = null;
                }

                return {
                    load: load,
                    destroy: destroy
                };
            }
        }
    });

}(jQuery));
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

    var filtersContainer = {};

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            filters: function ($afGrid, options) {

                options = $.extend({
                    isGridFilterable: true,
                    filterBy: null,
                    onFilter: $.noop
                }, options);

                var $filters;

                function onFilterChange() {
                    if ($filters) {
                        var filter = [];

                        forEachFilter($filters, function ($filter, type) {
                            var fValue = $.afGrid.filter[type].getValue($filter);
                            if (fValue) {
                                fValue.id = $.afGrid.getElementId($filter.attr("id"));
                                fValue.valueType = fValue.valueType || type;
                                filter.push(fValue);
                            }
                        });
                        if (filter && filter.length) {
                            $filters.addClass("filtered");
                        } else {
                            $filters.removeClass("filtered");
                        }
                        $afGrid.find(".afGrid-rows")[0].scrollTop = 0;
                        options.onFilter(filter);
                    }
                }

                function getFilters() {
                    return $filters;
                }

                function load() {
                    if (!options.isGridFilterable || !(options.filters && options.filters.length)) {
                        return;
                    }

                    $filters = renderFilters(options);

                    filtersContainer[options.id] = $filters;

                    forEachFilter($filters, function ($filter, type) {
                        $filter.addClass("afGrid-filter-control");
                        $.afGrid.filter[type].init($filter, onFilterChange, options.id, $afGrid);
                    });

                    if (options.filterBy && options.filterBy.length) {
                        $.each(options.filterBy, function (i, filter) {
                            var $filter = $filters.find("#" + options.id + "Filter_" + filter.id);
                            if ($filter.length) {
                                $.afGrid.filter[getFilterType($filter)].filterBy($filter, filter);
                            }
                        });
                        $filters.addClass("filtered");
                    } else {
                        $filters.removeClass("filtered");
                    }

                    $afGrid.find(".afGrid-head").append(getFilters());
                }

                function destroy() {
                    delete filtersContainer[options.id];
                    if ($filters) {
                        forEachFilter($filters, function ($filter, type) {
                            $.afGrid.filter[type].destroy($filter, $afGrid);
                        });
                        $filters.empty();
                        $filters = null;
                    }
                    options = null;
                }

                return {
                    load: load,
                    destroy: destroy
                };
            }
        }
    });

    function renderFilters(options) {
        return headingRowElementsRenderer(options.columns, {
            container: "<div class='afGrid-filter'></div>",
            cell: "<span class='cell {columnId} {cssClass}' id='{id}'>{value}</span>",
            cellContent: function (column) {
                return {
                    value: getFilter(column.filterType, column.filterData, options.id + "Filter_" + column.id),
                    id: options.id + "ColFilter_" + column.id,
                    columnId: column.id,
                    cssClass: ""
                };
            }
        });
    }

    function headingRowElementsRenderer(columns, template) {
        var $row = $(template.container),
            colCount = columns.length;
        $.each(columns, function (i, column) {
            if (column.render !== false) {
                var templateData = template.cellContent(column),
                    $cell;
                templateData.cssClass = templateData.cssClass + (i === colCount - 1 ? " last" : "") + (i === 0 ? " first" : "");
                $cell = $(template.cell.supplant(templateData));
                $cell.css({
                    width: column.width,
                    display: column.isHidden ? "none" : ""
                });
                $row.append($cell);
            }
        });
        return $row;
    }

    function getFilter(filterType, filterData, id) {
        if (filterType === undefined) {
            return "";
        } else if ($.afGrid.filter[filterType]) {
            return $.afGrid.filter[filterType].render(id, filterData).supplant({
                filterIdentifier: filterType + "-filter"
            });
        }
        throw "Unknown filter type defined in column data.";
    }

    function forEachFilter($filters, callback) {
        if ($.afGrid.filter) {
            $.each($.afGrid.filter, function (key) {
                var $f = $filters.find("." + key + "-filter");
                $f.each(function () {
                    callback($(this), key);
                });
            });
        }
    }

    function getFilterType($filter) {
        var type = "";
        $.each($.afGrid.filter, function (key) {
            if ($filter.hasClass(key + "-filter")) {
                type = key;
                return false;
            }
            return true;
        });
        return type;
    }

}(jQuery));
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

    var groupContainers = {};

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            groups: function ($afGrid, options) {
                options = $.extend({
                    id: options.id,
                    isGridGroupable: true,
                    onGroupChange: $.noop,
                    onGroupReorder: $.noop,
                    groupsPlaceHolder: null,
                    groupBy: null
                }, options);

                var $groupsMainContainer,
                    currentGroupColumnIds;

                function renderGroups(columns, groupedColumnIds) {
                    var groupedColumnIdsLength = groupedColumnIds.length,
                        $groupContainer,
                        $groups;
                    if (groupedColumnIdsLength) {
                        $groupsMainContainer.find(".empty-message").hide();
                        $groupContainer = $groupsMainContainer.find(".groups").show();
                        $groupContainer.empty();
                        $groups = $();
                        $.each(groupedColumnIds, function (i, columnId) {
                            var $group = $("<span id='{id}' class='cell'><span class='arrow'><span class='label'><a class='remove' href='#'>x</a> {label}</span></span></span>".supplant({
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
                    var newGroupColumnIds = $.grep(currentGroupColumnIds, function (id) {
                        return id !== columnId;
                    });
                    $afGrid.removeClass("afGrid-initialized");
                    options.onGroupChange(newGroupColumnIds);
                }

                //noinspection JSUnusedLocalSymbols
                function onColumnGroupingDrop(event, ui) {
                    var columnId = $.afGrid.getElementId(ui.draggable.attr("id"));
                    if (currentGroupColumnIds && currentGroupColumnIds.indexOf(columnId) > -1) {
                        return false;
                    }
                    currentGroupColumnIds.push(columnId);
                    setTimeout(function () {
                        $afGrid.removeClass("afGrid-initialized");
                        options.onGroupChange(currentGroupColumnIds);
                    }, 10);
                    return true;
                }

                function onGroupExpandCollapse(event) {
                    var $ele = $(event.currentTarget),
                        isGroupOpen = !$ele.data("state");
                    $ele.data("state", isGroupOpen);
                    $ele.find(".open-close-indicator").html(isGroupOpen ? "+" : "-");
                    $ele.removeClass("open close").addClass(isGroupOpen ? "close" : "open");
	                var $group = $ele.parents(".group").eq(0);

	                if (isGroupOpen) {
		                $group.addClass("group-closed");
		                setTimeout(function() {
			                $group.addClass("group-closed-complete");
		                }, 300);
	                } else {
		                $group.removeClass("group-closed-complete");
		                setTimeout(function() {
			                $group.removeClass("group-closed");
		                }, 10);
	                }

                    setTimeout(function () {
                        //BEGIN: Fix for IE8 incremental load when group is collapsed and more data is needed
                        $afGrid.find(".group-data").css({
                            zoom: 1
                        }).css({
                            zoom: 0
                        });
                        //END

                        if ($afGrid.find(".afGrid-rows")[0].scrollHeight <= $afGrid.find(".afGrid-rows").height()) {
                            options.onScrollToBottom();
                        }
                    }, 450);
                }

                function onGroupReorderDrop(event, ui) {
                    var $ele = $(event.target);
                    $ele.removeClass("reorder");
                    var groupIdToMove = $.afGrid.getElementId(ui.draggable.attr("id")),
                        groupIdToMoveAfter = $.afGrid.getElementId($ele.attr("id")),
                        newGroupOrder = [];
                    $.each(options.groupBy, function (i, columnId) {
                        if (columnId !== groupIdToMove) {
                            newGroupOrder.push(columnId);
                        }
                        if (columnId === groupIdToMoveAfter) {
                            newGroupOrder.push(groupIdToMove);
                        }
                    });
                    $afGrid.removeClass("afGrid-initialized");
                    options.onGroupReorder(newGroupOrder);
                }

                function load(helper) {
                    if (!options.isGridGroupable) {
                        return;
                    }

                    $.each(options.columns, function (index, column) {
                        if (!($.afGrid.renderer[column.type] && $.afGrid.renderer[column.type].headerCell)) {
                            if (column.isGroupable !== false) {
                                helper.getColumnElementById(column.id, options)
                                    .append("<span class='groupable-indicator'></span>")
                                    .addClass("groupable-column");
                            }
                        }
                    });

                    $afGrid.undelegate(".group .group-header", "click").delegate(".group .group-header", "click", onGroupExpandCollapse);
                    $groupsMainContainer = $(options.groupsPlaceHolder).undelegate("a.remove", "click.groups").delegate("a.remove", "click.groups", function () {
                        removeColumnFromGroup($.afGrid.getElementId($(this).parents(".cell").eq(0).attr("id")));
                        return false;
                    });
                    groupContainers[options.id] = $groupsMainContainer;
                    renderGroups(options.columns, options.groupBy);

                    if ($.fn.droppable) {
                        $groupsMainContainer.droppable({
                            drop: onColumnGroupingDrop,
                            accept: "#" + options.id + " .groupable-column",
                            activeClass: "ui-state-highlight",
                            tolerance: "touch",
                            hoverClass: "ui-state-highlight-hover"
                        });
                        $groupsMainContainer.find(".cell").droppable({
                            accept: ".groups .cell",
                            drop: onGroupReorderDrop,
                            over: onGroupReorderOver,
                            out: onGroupReorderOut,
                            tolerance: "pointer"
                        });
                    }

                    if ($.fn.draggable) {
                        $groupsMainContainer.find(".cell").draggable({
                            drop: onColumnGroupingDrop,
                            helper: getGroupHelper,
                            accept: "#" + options.id + " .groupable-column",
                            containment: $groupsMainContainer
                        });
                    }

                    options.makeColumnDraggable($afGrid);
                }

                function destroy() {
                    if ($groupsMainContainer) {
                        if ($.fn.droppable) {
                            $groupsMainContainer.droppable("destroy");
                            $groupsMainContainer.find(".cell").droppable("destroy");
                        }
                        if ($.fn.draggable) {
                            $groupsMainContainer.find(".cell").draggable("destroy");
                        }
                        delete groupContainers[options.id];
                        $groupsMainContainer.undelegate("a.remove", "click.groups");
                        $groupsMainContainer.find(".groups").empty();
                        $groupsMainContainer = null;
                    }
                    currentGroupColumnIds = null;
                    options = null;
                }

                return {
                    load: load,
                    destroy: destroy
                };
            }
        }
    });

    function onGroupReorderOver(event) {
        $(event.target).addClass("reorder");
    }

    function onGroupReorderOut(event) {
        $(event.target).removeClass("reorder");
    }

    function getGroupHelper(event) {
        return $(event.currentTarget).clone(false).addClass("group-helper");
    }
}(jQuery));
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

    $.afGrid.updateRow = "afGrid-update-row";

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            realTimeData: function ($afGrid, options, cachedGridData) {

                options = $.extend({
                    isLive: true
                }, options);

                function load(helper) {
                    if (!options.isLive) {
                        return;
                    }

                    //noinspection JSUnusedLocalSymbols
                    function onRowUpdate(event, row) {
                        $.each(row, function(key, value) {
                            var column = helper.getColumnById(key, options.columns);
                            if (column) {
                                var $cell = helper.getRowElementById(row.id, options).find("."+key);
                                if (column.type === "NUMERIC") {
                                    var oldValue = cachedGridData[row.id].orig[key];
                                    if (value>oldValue) {
                                        $cell.removeClass("negative").addClass("updated-cell positive");
                                    } else if (value<oldValue) {
                                        $cell.removeClass("positive").addClass("updated-cell negative");
                                    }
                                    cachedGridData[row.id].orig[key] = value;
                                }
                                $cell.html(helper.getCellContent(value, column));
                                window.setTimeout(function() {
                                    $cell.removeClass("updated-cell");
                                    $cell = null;
                                }, 2000);
                            }
                        });
                    }

                    $afGrid.unbind($.afGrid.updateRow).bind($.afGrid.updateRow, onRowUpdate);

                }

                function destroy() {
                    $afGrid.unbind($.afGrid.updateRow);
                    options = null;
                }

                return {
                    load: load,
                    destroy: destroy
                };
            }
        }
    });

}(jQuery));
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

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            sortable: function ($afGrid, options) {

                options = $.extend({
                    isGridSortable: true,
                    sortBy: null,
                    onSort: $.noop
                }, options);

                var SortDirection = {
                    ASC: "asc",
                    DESC: "desc"
                };

                function onColumnSort(event) {
                    var $cell = $(event.currentTarget),
                        columnId = $.afGrid.getElementId(event.currentTarget.id),
                        direction;

                    $afGrid
                        .find(".afGrid-heading .sortable-column")
                        .not($cell)
                        .removeClass("asc desc")
                        .removeData("direction");

                    direction = $cell.data("direction");
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

                function load(helper) {
                    if (!options.isGridSortable) {
                        return;
                    }

                    if (options.sortBy) {
                        var $column = $afGrid.find("#" + options.id + "Col_" + options.sortBy.column);
                        $column.addClass(options.sortBy.direction);
                        $column.data("direction", options.sortBy.direction);
                    }

                    $.each(options.columns, function (index, column) {
                        if ($.afGrid.renderer[column.type] && $.afGrid.renderer[column.type].headerSortArrow) {
                            var headerSortArrow = $.afGrid.renderer[column.type].headerSortArrow;
                            if (headerSortArrow) {
                                headerSortArrow($afGrid, column, options.columns, helper.getColumnElementById(column.id, options));
                            }
                        } else {
                            if (column.isSortable !== false) {
                                helper.getColumnElementById(column.id, options)
                                    .append("<span class='sort-arrow'></span>")
                                    .addClass("sortable-column");
                            }
                        }
                    });

                    undelegate($afGrid);
                    $afGrid
                        .delegate(".afGrid-heading .sortable-column", "click", onColumnSort)
                        .delegate(".afGrid-heading .sortable-column", "mouseenter", function () {
                            $(this).addClass("sort-hover");
                        })
                        .delegate(".afGrid-heading .sortable-column", "mouseleave", function () {
                            $(this).removeClass("sort-hover");
                        });
                }

                function undelegate($afGrid) {
                    $afGrid.undelegate(".afGrid-heading .sortable-column", "click");
                    $afGrid.undelegate(".afGrid-heading .sortable-column", "mouseleave");
                    $afGrid.undelegate(".afGrid-heading .sortable-column", "mouseenter");
                }

                function destroy() {
                    undelegate($afGrid);
                    options = null;
                }

                return {
                    load: load,
                    destroy: destroy
                };
            }
        }
    });

}(jQuery));
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

    var toolbarContainer = {};

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            toolbar: function ($afGrid, options) {

                options = $.extend({
                    showToolbar: true,
                    toolbarTemplate: "<div class='afGrid-toolbar'><a href='#' class='afGrid-reset'>Reset</a><a href='#' class='afGrid-refresh'>Refresh</a></div>",
                    onReset: $.noop
                }, options);

                var $toolbar;

                function load() {
                    if (!options.showToolbar) {
                        return;
                    }
                    $toolbar = $(options.toolbarTemplate);
                    toolbarContainer[options.id] = $toolbar;
                    $afGrid.prepend($toolbar);
                    $afGrid.undelegate(".afGrid-reset", "click").delegate(".afGrid-reset", "click", function () {
                        options.onReset();
                        return false;
                    });
                    $afGrid.undelegate(".afGrid-refresh", "click").delegate(".afGrid-refresh", "click", function () {
                        options.onRefresh();
                        return false;
                    });
                }

                function destroy() {
                    delete toolbarContainer[options.id];
                    if ($toolbar) {
                        $afGrid.undelegate(".afGrid-reset", "click");
                        $afGrid.undelegate(".afGrid-refresh", "click");
                    }
                    options = null;
                }

                return {
                    load: load,
                    destroy: destroy
                };
            }
        }
    });

}(jQuery));
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

    $.statePersistToCookie = $.cookie && {
        load: function (key, callback) {
            callback($.cookie(key));
        },
        save: function (key, value, callback) {
            $.cookie(key, value, {
                expires: 100,
                path: '/'
            });
            if (callback) {
                callback();
            }
        }
    };
}(jQuery));
(function ($) {
    "use strict";

    $.afGrid.filter.DATE = {
        render: function (id) {
            var text = "<input id='{id}' type='text' class='{filterIdentifier}' value=''/>";
            return text.supplant({
                id: id
            });
        },
        init: function ($filter, onFilter, gridId, $afGrid) {
            $filter.daterangepicker({
                onChange: function () {
                    $filter.attr("title", $filter.val());
                    onFilter();
                },
                dateFormat: "dd/mm/yy"
            });
            $afGrid.find(".afGrid-rows").bind("scroll.datefilter-" + $filter.attr("id"), function () {
                $(document).trigger("click.daterangeinput");
            });
        },
        filterBy: function ($filter, filterData) {
            if (filterData.valueType === "SPECIFIC_DATE") {
                $filter.val(filterData.value);
            } else {
                $filter.val(filterData.from + " - " + filterData.to);
            }
            $filter.attr("title", $filter.val());
        },
        getValue: function ($filter) {
            var value = $filter.val();
            if (value.indexOf(" - ") > 0) {
                var dateRangePart = value.split(" - ");
                return dateRangePart && {
                    valueType: "DATE_RANGE",
                    from: dateRangePart[0],
                    to: dateRangePart[1]
                };
            }
            return value && {
                valueType: "SPECIFIC_DATE",
                value: $filter.val()
            };
        },
        filter: function (filterValue, columnValue) {
            var addRow = true;
            var datePartColumnValue = /(\d{1,2})\/(\d{2})\/(\d{4})/.exec(columnValue);
            var year, month, day;
            if (!datePartColumnValue) {
                datePartColumnValue = /(\d{4})\-(\d{2})\-(\d{1,2})/.exec(columnValue);
                year = datePartColumnValue[1];
                day = datePartColumnValue[3];
            } else {
                year = datePartColumnValue[3];
                day = datePartColumnValue[1];
            }
            month = datePartColumnValue[2];
            var columnDateValue = new Date(year, parseInt(month, 10) - 1, day);
            if (filterValue.valueType === "SPECIFIC_DATE") {
                if (columnDateValue.getTime() !== getDateObject(filterValue.value).getTime()) {
                    addRow = false;
                }
            } else {
                if (!(columnDateValue.getTime() >= getDateObject(filterValue.from).getTime() &&
                    columnDateValue.getTime() <= getDateObject(filterValue.to).getTime())) {
                    addRow = false;
                }
            }
            return addRow;
        },
        destroy: function ($filter, $afGrid) {
            $afGrid.find(".afGrid-rows").unbind("scroll.datefilter-" + $filter.attr("id"));
            $filter.daterangepicker("destroy");
        }
    };

    function getDateObject(dateString) {
        var datePart = /(\d{1,2})\/(\d{1,2})\/(\d{4})/.exec(dateString);
        return new Date(datePart[3], datePart[2] - 1, datePart[1]);

    }
}(jQuery));
(function ($) {
    "use strict";

    var filtersLastVal = {};
    var typeSearchDelay = 600;

    $.afGrid.filter.FREE_TEXT = {
        render: function (id) {
            var text = "<input id='{id}' type='text' class='{filterIdentifier}'/>";
            return text.supplant({
                id: id
            });
        },
        init: function ($filter, onFilter, gridId) {
            var typeSearchDelayTimer = null;
            $filter.bind("change.filter", onFilter).bind("keyup.filter", function (event) {
                var $ele = $(event.target);
                if (filtersLastVal[gridId] && filtersLastVal[gridId][$ele.attr("id")] !== $ele.val() && filtersLastVal[gridId][$ele.attr("id")] !== undefined) {
                    window.clearTimeout(typeSearchDelayTimer);
                    typeSearchDelayTimer = window.setTimeout(function () {
                        onFilter.call($ele[0]);
                        typeSearchDelayTimer = null;
                    }, typeSearchDelay);
                }
                filtersLastVal[gridId] = filtersLastVal[gridId] || {};
                filtersLastVal[gridId][$ele.attr("id")] = $ele.val();
            });
        },
        filterBy: function ($filter, filter) {
            $filter.val(filter.value);
        },
        getValue: function ($filter) {
            var value = $filter.val();
            return value && {
                value: value
            };
        },
        destroy: function ($filter) {
            $filter.unbind("change.filter").unbind("keyup.filter");
        }
    };

}(jQuery));
(function ($) {
    "use strict";

    $.afGrid.filter.MULTI_SELECT = {
        render: function (id, filterData) {
            var select, options;
            select = "<select id='{id}' multiple='true' class='{filterIdentifier}'>{options}</select>";
            options = [];
            $.each(filterData, function (i, value) {
                options[options.length] = "<option value='{value}'>{value}</option>".supplant({
                    value: value
                });
            });
            return select.supplant({
                id: id,
                options: options.join("")
            });
        },
        init: function ($filter, onFilter, gridId, $afGrid) {
            if ($.fn.multiselect) {
                $filter.multiselect({
                    overrideWidth: "100%",
                    overrideMenuWidth: "200px",
                    close: onFilterChange,
                    click: onMultiSelectChange,
                    checkAll: onMultiSelectChange,
                    uncheckAll: onMultiSelectChange,
                    noneSelectedText: "&nbsp;",
                    selectedText: "Filtered",
                    selectedList: 1
                });
            }

            function onFilterChange(event) {
                if ($(event.target).hasClass("multi-select-changed")) {
                    onFilter.apply(event.target, arguments);
                }
            }

            $afGrid.find(".afGrid-rows").bind("scroll.multiselect-" + $filter.attr("id"), function () {
                $(document).trigger("mousedown.multiselect");
            });

        },
        filterBy: function ($filter, filter) {
            var filterValues = filter.values;
            $filter.find("option").each(function () {
                if (filterValues.indexOf($(this).val()) > -1) {
                    $(this).attr("selected", "true");
                }
            });
            $filter.multiselect("refresh");
        },
        getValue: function ($filter) {
            var values = $filter.multiselect("getChecked").map(function () {
                return this.value;
            }).get();
            return values && values.length && {
                values: values
            };
        },
        filter: function (filterValue, columnValue) {
            var addRow = true;
            if (filterValue && filterValue.values) {
                if (filterValue.values.indexOf(columnValue) < 0) {
                    addRow = false;
                }
            }
            return addRow;
        },
        destroy: function ($filter, $afGrid) {
            if ($.fn.multiselect) {
                $filter.multiselect("destroy");
            }
            $afGrid.find(".afGrid-rows").unbind("scroll.multiselect-" + $filter.attr("id"));
        }
    };

    function onMultiSelectChange(event) {
        $(event.target).addClass("multi-select-changed");
    }

}(jQuery));
(function ($) {
    "use strict";

    $.afGrid.filter.SIMPLE_DATE = {
        render: function (id) {
            var text = "<input id='{id}' type='text' class='{filterIdentifier}' value=''/>";
            return text.supplant({
                id: id
            });
        },
        init: function ($filter, onFilter) {
            $filter.datepicker({
                onClose: onFilter,
                dateFormat: "dd-M-yy"
            });
        },
        filterBy: function ($filter, filterData) {
            $filter.datepicker("setDate", filterData.value);
        },
        getValue: function ($filter) {
            var value = $filter.val();
            return value && {
                value: value
            };
        },
        destroy: function ($filter) {
            $filter.datepicker("destroy");
        }
    };

}(jQuery));
(function ($) {
    "use strict";

    var currentTheme = {};

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            THEME_SWITCHER: function ($afGrid, options) {
                function load() {
                    var $themeSwitcher = $("." + options.id + "-afGrid-switch-theme");
                    $themeSwitcher.delegate(".theme", "click", function () {
                        var theme = $(this).attr("href").replace("#", ""), gridId = options.id;
                        var $grid = $("#" + gridId);
                        var $gridGroupBy = $("." + gridId + "-afGrid-group-by");
                        if (currentTheme[gridId]) {
                            $grid.removeClass("afGrid-" + currentTheme[gridId]);
                            $gridGroupBy.removeClass("afGrid-group-by-" + currentTheme[gridId]);
                        }
                        currentTheme[gridId] = theme;
                        $grid.addClass("afGrid-" + currentTheme[gridId]);
                        $gridGroupBy.addClass("afGrid-group-by-" + currentTheme[gridId]);
                        return false;
                    });
                }

                function destroy() {
                    $("." + options.id + "-afGrid-switch-theme").undelegate(".theme", "click");
                    options = null;
                }

                return {
                    load: load,
                    destroy: destroy
                };
            }
        }
    });

}(jQuery));
(function ($) {
    "use strict";

    $.afGrid.renderer.DATE = {
        cell: function (data) {
            return "<span class='date'>{date}</span>".supplant({
                date: data ? data : "&nbsp;"
            });
        },
        comparator: function (valA, valB) {
            return getDateTimeValue(valA) - getDateTimeValue(valB);
        }
    };

    function getDateTimeValue(dateString) {
        var datePartColumnValue = /(\d{1,2})\/(\d{2})\/(\d{4})/.exec(dateString);
        return datePartColumnValue ? new Date(datePartColumnValue[3], parseInt(datePartColumnValue[2], 10) - 1, datePartColumnValue[1]).getTime() : dateString;
    }

}(jQuery));
(function ($) {
    "use strict";

    $.afGrid.renderer.LABEL_BUTTON = {
        cell: function (columnData) {
            return "<input type='button' class='button' value='{value}'><input type='hidden' value='{actualValue}' class='dataValue'>".supplant({
                value: "Show",
                actualValue: columnData
            });
        }
    };

}(jQuery));
(function ($) {
    "use strict";

    $.afGrid.renderer.NUMERIC = {
        cell: function (data) {
            return data ? data.toFixed(2) : "";
        },
        comparator: function (valA, valB) {
            valA = Number(String(valA).replace(/,/g, ""));
            valB = Number(String(valB).replace(/,/g, ""));
            return valA - valB;
        }
    };

}(jQuery));
(function ($) {
    "use strict";

    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    $.afGrid.renderer.SYSTEM_DATE = {
        cell: function (data) {
            var dateParts = data.split("-");
            var stringDate = data !== "-" ? [dateParts[2], "-", monthNames[(+dateParts[1]) - 1], "-", dateParts[0]].join("") : "-";
            return "<span class='date'>{date}</span>".supplant({
                date: stringDate
            });
        }
    };

}(jQuery));
