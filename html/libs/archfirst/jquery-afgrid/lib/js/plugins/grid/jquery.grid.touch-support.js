(function ($) {
    var timer;
    var touchStartDelay=0;
    function touchHandler(event) {
        var touches = event.changedTouches,
            first = touches[0],
            type = "";
        switch (event.type) {
        case "touchstart":
            type = "mousedown";
            timer=setInterval(function(){
                touchStartDelay+=1;
            },1);
            break;
        case "touchmove":
            clearInterval(timer);
            touchStartDelay=0;
            if (delay<250) {
                return true;
            }
            type = "mousemove";
            break;
        case "touchend":
            clearInterval(timer);
            touchStartDelay=0;
            if (delay<250) {
                return true;
            }
            type = "mouseup";
            break;
        default:
            return true;
        }
        
        var simulatedEvent = document.createEvent("MouseEvent");
        simulatedEvent.initMouseEvent(type, true, true, window, 1, first.screenX, first.screenY, first.clientX, first.clientY, false, false, false, false, 0 /*left*/ , null);

        first.target.dispatchEvent(simulatedEvent);
        event.preventDefault();
        return false;
    }

    function init() {
        document.addEventListener("touchstart", touchHandler, true);
        document.addEventListener("touchmove", touchHandler, true);
        document.addEventListener("touchend", touchHandler, true);
        document.addEventListener("touchcancel", touchHandler, true);
    }
    $(init);
}(jQuery))