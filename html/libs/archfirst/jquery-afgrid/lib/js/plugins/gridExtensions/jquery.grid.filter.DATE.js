(function ($) {
    "use strict";

    $.afGrid.filter.DATE = {
        render: function (id) {
            var text = "<input id='{id}' type='text' class='{filterIdentifier}' value=''/>";
            return text.supplant({
                id: id
            });
        },
        init: function ($filter, onFilter, gridId, $afGrid) {
            $filter.daterangepicker({
                onChange: function () {
                    $filter.attr("title", $filter.val());
                    onFilter();
                },
                dateFormat: "dd/mm/yy"
            });
            $afGrid.find(".afGrid-rows").bind("scroll.datefilter-" + $filter.attr("id"), function () {
                $(document).trigger("click.daterangeinput");
            });
        },
        filterBy: function ($filter, filterData) {
            if (filterData.valueType === "SPECIFIC_DATE") {
                $filter.val(filterData.value);
            } else {
                $filter.val(filterData.from + " - " + filterData.to);
            }
            $filter.attr("title", $filter.val());
        },
        getValue: function ($filter) {
            var value = $filter.val();
            if (value.indexOf(" - ") > 0) {
                var dateRangePart = value.split(" - ");
                return dateRangePart && {
                    valueType: "DATE_RANGE",
                    from: dateRangePart[0],
                    to: dateRangePart[1]
                };
            }
            return value && {
                valueType: "SPECIFIC_DATE",
                value: $filter.val()
            };
        },
        filter: function (filterValue, columnValue) {
            var addRow = true;
            var datePartColumnValue = /(\d{1,2})\/(\d{2})\/(\d{4})/.exec(columnValue);
            var year, month, day;
            if (!datePartColumnValue) {
                datePartColumnValue = /(\d{4})\-(\d{2})\-(\d{1,2})/.exec(columnValue);
                year = datePartColumnValue[1];
                day = datePartColumnValue[3];
            } else {
                year = datePartColumnValue[3];
                day = datePartColumnValue[1];
            }
            month = datePartColumnValue[2];
            var columnDateValue = new Date(year, parseInt(month, 10) - 1, day);
            if (filterValue.valueType === "SPECIFIC_DATE") {
                if (columnDateValue.getTime() !== getDateObject(filterValue.value).getTime()) {
                    addRow = false;
                }
            } else {
                if (!(columnDateValue.getTime() >= getDateObject(filterValue.from).getTime() &&
                    columnDateValue.getTime() <= getDateObject(filterValue.to).getTime())) {
                    addRow = false;
                }
            }
            return addRow;
        },
        destroy: function ($filter, $afGrid) {
            $afGrid.find(".afGrid-rows").unbind("scroll.datefilter-" + $filter.attr("id"));
            $filter.daterangepicker("destroy");
        }
    };

    function getDateObject(dateString) {
        var datePart = /(\d{1,2})\/(\d{1,2})\/(\d{4})/.exec(dateString);
        return new Date(datePart[3], datePart[2] - 1, datePart[1]);

    }
}(jQuery));