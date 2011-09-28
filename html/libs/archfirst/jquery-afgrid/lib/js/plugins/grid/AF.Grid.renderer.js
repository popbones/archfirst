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

(function ($) {

    window.AF = window.AF || {};
    AF.renderer = AF.renderer || {};

    AF.renderer.Grid = function (options) {

        options = $.extend({
            id: null,
            afGridSelector: "#" + options.id,
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
        }());

        return {
            renderData: renderData,
            addNewRows: addNewRows
        };
    };

}(jQuery));