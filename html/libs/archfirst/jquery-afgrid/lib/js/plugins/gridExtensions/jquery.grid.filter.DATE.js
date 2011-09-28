(function ($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.filter = $.afGrid.filter || {};

    $.afGrid.filter.DATE = {
        render: function (id) {
            var text = "<input id='{id}' type='text' class='DATE-filter' value=''/>";
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
            return $filter.val();
        },
        destroy: function ($filter) {
            $filter.datepicker("destroy");
        }
    };

}(jQuery));