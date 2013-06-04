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
                        currentState = !$ele.data("state");
                    $ele.data("state", currentState);
                    $ele.find(".open-close-indicator").html(currentState ? "+" : "-");
                    $ele.removeClass("open close").addClass(currentState ? "close" : "open");
                    $ele.parents(".group").eq(0)[currentState ? "addClass" : "removeClass"]("group-closed");

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