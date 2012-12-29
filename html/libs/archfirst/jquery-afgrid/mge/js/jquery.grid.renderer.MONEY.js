(function ($) {
    "use strict";

    $.afGrid.renderer.MONEY = {
        cell: function (amount) {
            return (amount >= 0) ?
                '$ ' + $.format.number(amount, '#,##0.00') :
                '($ ' + $.format.number(-amount, '#,##0.00') + ')';
        }
    };

}(jQuery));