(function ($) {
    "use strict";

    var currentTheme = {};

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            THEME_SWITCHER: function ($afGrid, options) {
                function load() {
                    var $themeSwitcher = $("." + options.id + "-afGrid-switch-theme");
                    $themeSwitcher.delegate(".theme", "click", function () {
                        var theme = $(this).attr("href").replace("#", ""), gridId = options.id;
                        var $grid = $("#" + gridId);
                        var $gridGroupBy = $("." + gridId + "-afGrid-group-by");
                        if (currentTheme[gridId]) {
                            $grid.removeClass("afGrid-" + currentTheme[gridId]);
                            $gridGroupBy.removeClass("afGrid-group-by-" + currentTheme[gridId]);
                        }
                        currentTheme[gridId] = theme;
                        $grid.addClass("afGrid-" + currentTheme[gridId]);
                        $gridGroupBy.addClass("afGrid-group-by-" + currentTheme[gridId]);
                        return false;
                    });
                }

                function destroy() {
                    $("." + options.id + "-afGrid-switch-theme").undelegate(".theme", "click");
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