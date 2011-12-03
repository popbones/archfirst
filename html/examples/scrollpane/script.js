$(document).ready(function() {
    new ScrollPane(600, 400);
});

function ScrollPane(width, height) {

    var scrollbarWidth = 12;

    $('#scrollpane').width(width).height(height);

    $('#arrow-up').width(scrollbarWidth).height(scrollbarWidth);
    $('#arrow-down').width(scrollbarWidth).height(scrollbarWidth);
    $('#arrow-left').width(scrollbarWidth).height(scrollbarWidth);
    $('#arrow-right').width(scrollbarWidth).height(scrollbarWidth);

    $('#scrollpane-content')
        .width(width-scrollbarWidth)
        .height(height-scrollbarWidth);

    $('#vert-scrollbar')
        .width(scrollbarWidth)
        .height(height-scrollbarWidth);

    $('#vert-slider')
        .width(scrollbarWidth)
        .height(height-4*scrollbarWidth)
        .slider({
            orientation: "vertical",
            slide: function(event, ui) { showSliderValues(); },
            change: function(event, ui) { showSliderValues(); }
        });

    $('#horz-scrollbar')
        .width(width-scrollbarWidth)
        .height(scrollbarWidth);

    $('#horz-slider')
        .width(width-4*scrollbarWidth)
        .height(scrollbarWidth)
        .slider({
            slide: function(event, ui) { showSliderValues(); },
            change: function(event, ui) { showSliderValues(); }
        });
}

function showSliderValues() {
    var x = $('#horz-slider').slider("value");
    var y = $('#vert-slider').slider("value");
    $('#scrollpane-content').html(x + ', ' + y);
}