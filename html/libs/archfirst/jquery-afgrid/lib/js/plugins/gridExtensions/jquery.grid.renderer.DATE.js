(function ($) {
    "use strict";

    $.afGrid.renderer.DATE = {
        cell: function (data) {
            return "<span class='date'>{date}</span>".supplant({
                date: data ? data : "&nbsp;"
            });
        },
        comparator: function (valA, valB) {
            return getDateTimeValue(valA) - getDateTimeValue(valB);
        }
    };

    function getDateTimeValue(dateString) {
        var datePartColumnValue = /(\d{1,2})\/(\d{2})\/(\d{4})/.exec(dateString);
        return datePartColumnValue ? new Date(datePartColumnValue[3], parseInt(datePartColumnValue[2], 10) - 1, datePartColumnValue[1]).getTime() : dateString;
    }

}(jQuery));