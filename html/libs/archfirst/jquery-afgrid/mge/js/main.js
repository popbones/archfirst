$(function () {
    "use strict";

    var windowSizeTemplate;
    var grid1 = new AF.Grid({
        dataSource: new AF.Grid.FakeLocalSource(AF.Grid.fakeDataMGE),
        id: "mgeGrid",
        onRowClick: onRowClick
    });
    grid1.load();
    $(window).bind("resize", function () {
        $("#mgeGrid").trigger($.afGrid.adjustRowWidth);
    });

    function onRowClick(item) {
        $("#lastSelectedPosition").html(item.security);
    }

    function windowSize() {
        var win = $(window);
        var $windowSize = $('.window-size');
        windowSizeTemplate = windowSizeTemplate || $windowSize.text();
        $windowSize.text(windowSizeTemplate.supplant({
            windowWidth: win.width(),
            windowHeight: win.height()
        }));
    }
    $(window).bind("resize", windowSize);
    windowSize();
});