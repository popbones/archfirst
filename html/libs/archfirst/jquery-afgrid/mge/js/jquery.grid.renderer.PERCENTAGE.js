(function ($) {
    "use strict";

    $.afGrid.renderer.PERCENTAGE = {
        cell: function (percent) {
            if (percent >= 0) {
                return "<span>" + $.format.number(percent, "#,##0.00") + "%</span>";
            } else {
                return "<span class='negative'>(" + $.format.number(-percent, "#,##0.00") + "%)</span>";
            }
        }
    };

}(jQuery));