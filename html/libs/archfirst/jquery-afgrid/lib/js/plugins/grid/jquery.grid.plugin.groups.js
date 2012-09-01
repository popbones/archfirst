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

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            groups: function ($afGrid, options) {
                options = $.extend({
                    id: options.id,
                    canGroup: true,
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
                        $groups = $j();
                        $j.each(groupedColumnIds, function (i, columnId) {
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
                    var newGroupColumnIds = $j.grep(currentGroupColumnIds, function (id, i) {
                        return id !== columnId;
                    });
		    $afGrid.removeClass("afGrid-initialized");			
                    options.onGroupChange(newGroupColumnIds);
                }

                function onColumnGroupingDrop(event, ui) {
                    var columnId = ui.draggable.attr("id").split("_")[1];
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

                function onGroupExpandCollapse() {
                    var $ele = $(this),
                        currentState = !$ele.data("state");
                    $ele.data("state", currentState);
                    $ele.find(".open-close-indicator").html(currentState ? "+" : "-");
                    $ele.removeClass("open close").addClass(currentState ? "close" : "open");
                    $ele.parents(".group").eq(0).children(":not('.group-header:eq(0)')")[currentState ? "hide" : "show"]();
                }

                function onGroupReorderDrop(event, ui) {
                    $(this).removeClass("reorder");
                    var groupIdToMove = ui.draggable.attr("id").split("_")[1],
                        groupIdToMoveAfter = $(this).attr("id").split("_")[1],
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

                function load() {
                    if (!options.canGroup || $afGrid.hasClass("afGrid-initialized")) {
                        return;
                    }

                    $afGrid.undelegate(".group .group-header", "click").delegate(".group .group-header", "click", onGroupExpandCollapse);
                    $groupsMainContainer = $(options.groupsPlaceHolder).undelegate("a.remove", "click.groups").delegate("a.remove", "click.groups", function () {
                        removeColumnFromGroup($j(this).parents(".cell").eq(0).attr("id").split("_")[1]);
                        return false;
                    });

                    renderGroups(options.columns, options.groupBy);

                    $.fn.droppable && $groupsMainContainer.droppable({
                        drop: onColumnGroupingDrop,
                        accept: "#" + options.id + " .groupBy",
                        activeClass: "ui-state-highlight"
                    });

                    $.fn.draggable && $groupsMainContainer.find(".cell").draggable({
                        drop: onColumnGroupingDrop,
                        helper: getGroupHelper,
                        accept: "#" + options.id + " .groupBy",
                        containment: $groupsMainContainer
                    });

                    $.fn.droppable && $groupsMainContainer.find(".cell").droppable({
                        accept: ".groups .cell",
                        drop: onGroupReorderDrop,
                        over: onGroupReorderOver,
                        out: onGroupReorderOut
                    });

                    options.makeColumnDraggable($afGrid);
                }

                function destroy() {
		    $groupsMainContainer = $groupsMainContainer || $();
                    $.fn.droppable && $groupsMainContainer.droppable("destroy");
                    $.fn.droppable &&  $.fn.draggable && $groupsMainContainer.find(".cell").droppable("destroy").draggable("destroy");
                    $groupsMainContainer.undelegate("a.remove", "click.groups");
                    $groupsMainContainer.find(".groups").empty();
                    $groupsMainContainer = null;
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

    function onGroupReorderOver(event, ui) {
        $(this).addClass("reorder");
    }

    function onGroupReorderOut(event, ui) {
        $(this).removeClass("reorder");
    }

    function getGroupHelper(event) {
        return $(event.currentTarget).clone(false).addClass("group-helper");
    }

    function onGroupReorder(x, y, z) {
        console.log(x, y, z);
    }
}(jQuery));