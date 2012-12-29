(function ($) {
    "use strict";

    $.afGrid.renderer.PERCENTAGE = {
        cell: function (percent) {
            return (percent >= 0) ?
                $.format.number(percent, '#,##0.00') + '%' :
                '(' + $.format.number(-percent, '#,##0.00') + '%)';
        }
    };

}(jQuery));