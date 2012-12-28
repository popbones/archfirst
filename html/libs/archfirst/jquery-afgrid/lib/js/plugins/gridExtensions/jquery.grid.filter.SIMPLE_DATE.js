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