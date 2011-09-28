(function ($) {

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            LABEL_BUTTON: function ($afGrid, options, cachedafGridData) {

                options = $.extend({
                    labelButtonIdentifier: ".button"
                }, options);

                function load() {
                    $afGrid.delegate(options.labelButtonIdentifier, "click", function () {
                        var rowId = $(this).closest(".row").attr("id").split("_")[1];
                        alert("Cell data: " + $(this).next().val() + ", Row data: " + JSON.stringify(cachedafGridData[rowId]));
                        return false;
                    });
                }

                function destroy() {
                    $afGrid.undelegate(options.labelButtonIdentifier, "click");
                    options = null;
                }

                return {
                    load: load,
                    destroy: destroy
                };
            }
        }
    });

}(jQuery));