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

