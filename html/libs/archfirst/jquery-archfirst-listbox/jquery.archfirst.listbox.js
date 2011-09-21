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
 * @fileoverview A subset of <select> tag that can be styled very easily.
 * It uses <ul> and <li> tags to create a list.
 *
 * @requires: ../utility/string.supplant.js
 *
 * @author Manish Shanker
 */

(function ($) {

    $.fn.archfirstListbox = function (options) {
        options = $.extend({
            data: null,
            onClickOfItem: $.noop,
            activeCssClass: "active"
        }, options);

        return this.each(function () {
            var $selectedItem = $();
            var $item = $(this);
            var $template = $item.find(".listboxItem").wrap("<div></div>").parent();
            var template = $template.html();
            $template.remove();
            var listItems = "";
            $.each(options.data, function (i, item) {
                listItems += template.supplant({ listboxItemLabel: item });
            });
            $item.html(listItems);
            $selectedItem = $item.find(".listboxItem:eq(0)").addClass(options.activeCssClass);
            $item.delegate(".listboxItem", "click", function () {
                $selectedItem.removeClass(options.activeCssClass);
                $selectedItem = $(this);
                options.onClickOfItem($selectedItem.addClass(options.activeCssClass).text());
                return false;
            });
        });
    }

})(jQuery)