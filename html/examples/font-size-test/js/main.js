$(document).ready(function() {
    $('#device-info').html(
        "Screen size: " + screen.width + " x " + screen.height +
        " (devicePixelRatio = " + window.devicePixelRatio + ")");
});