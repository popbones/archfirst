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