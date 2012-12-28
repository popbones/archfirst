(function ($) {
    "use strict";

    $.afGrid.renderer.LABEL_BUTTON = {
        cell: function (columnData) {
            return "<input type='button' class='button' value='{value}'><input type='hidden' value='{actualValue}' class='dataValue'>".supplant({
                value: "Show",
                actualValue: columnData
            });
        }
    };

}(jQuery));