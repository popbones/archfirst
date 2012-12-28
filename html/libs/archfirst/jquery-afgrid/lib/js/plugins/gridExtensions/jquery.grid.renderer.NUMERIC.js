(function ($) {
    "use strict";

    $.afGrid.renderer.NUMERIC = {
        cell: function (data) {
            return data;
        },
        comparator: function (valA, valB) {
            valA = Number(String(valA).replace(/,/g, ""));
            valB = Number(String(valB).replace(/,/g, ""));
            return valA - valB;
        }
    };

}(jQuery));