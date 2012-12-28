(function ($) {
    "use strict";

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            LABEL_BUTTON: function ($afGrid, options, cachedData) {

                options = $.extend({
                    labelButtonIdentifier: ".button"
                }, options);

                function load() {
                    $afGrid.delegate(options.labelButtonIdentifier, "click", function () {
                        var rowId = $.afGrid.getElementId($(this).closest(".row").attr("id"));
                        alert("Cell data: " + $(this).next().val() + ", Row data: " + JSON.stringify(cachedData[rowId]));
                        return false;
                    });
                }

                function update(_cachedData) {
                    cachedData = _cachedData;
                }

                function destroy() {
                    $afGrid.undelegate(options.labelButtonIdentifier, "click");
                    options = null;
                }

                return {
                    load: load,
                    update: update,
                    destroy: destroy
                };
            }
        }
    });

}(jQuery));