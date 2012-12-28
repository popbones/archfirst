(function ($) {
    "use strict";

    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    $.afGrid.renderer.SYSTEM_DATE = {
        cell: function (data) {
            var dateParts = data.split("-");
            var stringDate = data !== "-" ? [dateParts[2], "-", monthNames[(+dateParts[1]) - 1], "-", dateParts[0]].join("") : "-";
            return "<span class='date'>{date}</span>".supplant({
                date: stringDate
            });
        }
    };

}(jQuery));