(function ($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.filter = $.afGrid.filter || {};

    $.afGrid.filter.DATERANGE = {
        render: function (id) {
            var text = "<input id='{id}' type='text' class='DATERANGE-filter' value=''/>";
            return text.supplant({
                id: id
            });
        },
        init: function ($filter, onFilter) {
            $filter.daterangepicker({
                onClose: function () {
                    $filter.attr("title", $filter.val());
                    onFilter();
                },
                dateFormat: "dd-M-yy"
            });
        },
        filterBy: function ($filter, filterData) {
            $filter.val(filterData.value);
            $filter.attr("title", $filter.val());
        },
        getValue: function ($filter) {
            return $filter.val();
        },
        destroy: function ($filter) {
            $filter.daterangepicker("destroy");
        }
    };

}(jQuery));