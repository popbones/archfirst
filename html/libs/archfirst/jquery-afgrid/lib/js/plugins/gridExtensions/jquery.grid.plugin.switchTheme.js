(function ($) {

	var currentTheme = {};

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            THEME_SWITCHER: function ($afGrid, options, cachedafGridData) {				
                function load() {
					var $themeSwitcher = $("." + options.id + "-afGrid-switch-theme");
					$themeSwitcher.delegate(".theme", "click", function () {
						var theme = $(this).attr("href").replace("#", ""), gridId = options.id;
                        if (currentTheme[gridId]) {
                            $("#" + gridId).removeClass("afGrid-" + currentTheme[gridId]);
                            $("." + gridId + "-afGrid-group-by").removeClass("afGrid-group-by-" + currentTheme[gridId]);
                        }
                        currentTheme[gridId] = theme;
                        $("#" + gridId).addClass("afGrid-" + currentTheme[gridId]);
                        $("." + gridId + "-afGrid-group-by").addClass("afGrid-group-by-" + currentTheme[gridId]);
                        return false;
                    });
                }

                function destroy() {
					$("." + options.id + "-afGrid-switch-theme").undelegate(".theme", "click");
					$themeSwitcher = null;
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