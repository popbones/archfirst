(function ($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.renderer = $.afGrid.renderer || {};

    $.afGrid.renderer.DATE = function (data) {
        return "<span class='date'>{date}</span>".supplant({
            date: data
        });
    };

}(jQuery));