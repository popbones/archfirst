function transitionPage() {
    // Hide to left / show from left
    $("#page1").toggle("slide", {direction: "left"}, 500);

    // Show from right / hide to right
    $("#page2").toggle("slide", {direction: "right"}, 500);
}

$(document).ready(function() {
    $('#page1').click(transitionPage);
    $('#page2').click(transitionPage);
});