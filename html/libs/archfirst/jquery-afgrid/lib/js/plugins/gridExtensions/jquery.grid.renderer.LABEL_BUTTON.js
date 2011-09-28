(function ($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.renderer = $.afGrid.renderer || {};

    $.afGrid.renderer.LABEL_BUTTON = function (columnData, column, columnIndex, row) {
        var formattedLabel = columnData.split(", ")[1].substring(0, 1) + ". " + columnData.split(", ")[0];
        return "<input type='button' class='button' value='{value}'><input type='hidden' value='{actualValue}' class='dataValue'>".supplant({
            value: "Show",
            actualValue: columnData
        });
    };

}(jQuery));