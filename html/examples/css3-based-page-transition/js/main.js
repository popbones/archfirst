var animationEndEventNames = {
    'WebkitAnimation' : 'webkitAnimationEnd',
    'MozAnimation'    : 'animationend',
    'OAnimation'      : 'oAnimationEnd',
    'msAnimation'     : 'MSAnimationEnd',
    'animation'       : 'animationend'
};

var animationEndEventName = animationEndEventNames[ Modernizr.prefixed('animation') ];

function transitionPage(fromPage, toPage, direction) {
    var $fromPage = $('#' + fromPage),
        $toPage = $('#' + toPage);

    var fromPageAnimation;
    var toPageAnimation;

    // Determine animations for each page
    if (direction === 'left') {
        fromPageAnimation = 'slide-out-to-left';
        toPageAnimation = 'slide-in-from-right';
    }
    else {
        fromPageAnimation = 'slide-out-to-right';
        toPageAnimation = 'slide-in-from-left';
    }

    // Execute the animations
    $toPage.show();
    $fromPage.addClass(fromPageAnimation);
    $toPage.addClass(toPageAnimation);

    // Wait for animations to finish and remove them
    $toPage.on(animationEndEventName, function(e) {
        $toPage.off(animationEndEventName);
        $fromPage.hide();
        // give it a little time to settle (needed for webkit)
        setTimeout(function() {
            $fromPage.removeClass(fromPageAnimation);
            $toPage.removeClass(toPageAnimation);
        }, 100);
    });
}

$(document).ready(function() {
    $('#page1').click(function() {
        transitionPage('page1', 'page2', 'left')
    });

    $('#page2').click(function() {
        transitionPage('page2', 'page1', 'right')
    });
});