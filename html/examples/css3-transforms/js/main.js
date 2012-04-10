$(document).ready(function() {

    $('#panel1').on('click', function(e) {
        $(this).addClass("rotate");
    });

    $('#panel2').rotate({ 
        bind: { 
            click: function() {
                $(this).rotate({ angle:0, animateTo:180 })
            }
        } 
    });

    $('#panel3').on('click', function(e) {
        $(this).flip({
            direction:'rl',
            onBefore: function() {
                // Switch to flipped image before animation starts
                $('#panel3').attr("src", "img/turbine_rotated.jpg");
            }
        })
    });
});