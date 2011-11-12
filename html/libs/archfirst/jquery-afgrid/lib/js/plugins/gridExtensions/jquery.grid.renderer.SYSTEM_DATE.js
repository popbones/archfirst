(function ($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.renderer = $.afGrid.renderer || {};

    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    
    $.afGrid.renderer.SYSTEM_DATE = function (data) {
        var date = new Date(data);
        var stringDate = data !== "-" ? date.getDate() + "-" + monthNames[date.getMonth()] + "-" + date.getFullYear() : "-";
        return "<span class='date'>{date}</span>".supplant({
            date: stringDate 
        });
    };

}(jQuery));