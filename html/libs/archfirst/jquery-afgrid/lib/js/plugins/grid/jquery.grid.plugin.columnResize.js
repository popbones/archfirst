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
            columnResize: function ($afGrid, options) {

                options = $.extend({
                    canResizeColumn: true,
                    onColumnResize: $.noop,
                    minColumnWidth: 30,
                    maxColumnWidth: 700
                }, options);

                var columns = options.columns;

                function load() {
                    if (!options.canResizeColumn || $afGrid.hasClass("afGrid-initialized")) {
                        return;
                    }
                    var $headingCells = $afGrid.find(".afGrid-heading .cell");
                    $headingCells.each(function () {
                        var $cell = $(this),
						$resizeHandle = $("<span class='resize-handle'></span>");
                        $resizeHandle.bind("click", function () {
                            return false;
                        });

                        $resizeHandle.bind("mousedown", function (event) {
                            var columnId = $(this).parents(".cell").eq(0).attr("id").split("_")[1],
								posX,
								originalWidth,
								$guide,
								newWidth;
                            $guide = $("<div class='resize-guide'></div>");
                            $guide.css({
                                height: $afGrid.height(),
                                top: $afGrid.position().top + parseInt($afGrid.css("margin-top"), 10),
                                left: $resizeHandle.offset().left + $resizeHandle.width()
                            });
                            $("body").append($guide);
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
					left: $resizeHandle.offset().left + $resizeHandle.width()
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
                };
            }
        }
    });

}(jQuery));