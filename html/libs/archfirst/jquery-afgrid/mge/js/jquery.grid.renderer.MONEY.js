(function ($) {
    "use strict";

    $.afGrid.renderer.MONEY = {
        cell: function (amount) {
            if (amount >= 0) {
                return "<span>$ " + $.format.number(amount, "#,##0.00") + "</span>";
            } else {
                return "<span class='negative'>($ " + $.format.number(-amount, "#,##0.00") + ")</span>";
            }
        }
    };

}(jQuery));