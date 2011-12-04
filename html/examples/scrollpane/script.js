$(document).ready(function() {
    createSlider();
    sizeComponents();
    $(window).resize(function() {
        sizeComponents();
    });
    generateTable(40, 20);
});

function createSlider() {
    $('#vert-slider')
        .slider({
            orientation: 'vertical',
            value: 100,
            slide: function(event, ui) { scrollVertical(100 - ui.value); },
            change: function(event, ui) { scrollVertical(100 - ui.value); }
        });
}

function sizeComponents() {
    sizeElementHeight($('#scrollpane-content'), $('#footer'));
    sizeVerticalScrollBar();
}

function sizeElementHeight(element, elementBelow) {
    var windowHeight = $(window).height();
    var elementAboveHeight = element.offset().top;
    var elementBelowHeight = windowHeight - elementBelow.offset().top;
    var fudgeFactor = 20;
    element.height(windowHeight - elementAboveHeight - elementBelowHeight - fudgeFactor);
}

function sizeVerticalScrollBar() {
    var scrollbarWidth = 12;
    var arrowHeight = 20;
    var scrollpaneHeight = $('#scrollpane-content').height();

    $('#vert-slider')
        .width(scrollbarWidth)
        .height(scrollpaneHeight-2*arrowHeight);
}

function scrollVertical(value) {
    var maxScroll = $('#scrollpane-content')[0].scrollHeight - $('#scrollpane-content').height();
    $('#scrollpane-content').scrollTop(value*(maxScroll/100));
}

function generateTable(numRows, numColumns) {
    var table = '<table>';
    for (i=0; i<numRows; i++) {
        table = table + '<tr>';
        for (j=0; j<numColumns; j++) {
            table = table + '<td>' + i + ', ' + j + '</td>';
        }
        table = table + '</tr>';
    }
    table = table + '</table>';
    $('#scrollpane-content').html(table);
}