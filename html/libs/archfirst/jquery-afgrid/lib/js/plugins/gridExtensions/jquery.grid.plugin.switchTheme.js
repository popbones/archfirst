(function ($) {

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            THEME_SWITCHER: function ($afGrid, options, cachedafGridData) {

                function load() {
                    var currentTheme = {};
                    $(".afGrid-switch-theme").delegate(".theme", "click", function () {
                        var theme = $(this).attr("href").replace("#", ""),
			    gridId;
                        $.each($(this).closest(".afGrid-switch-theme").attr("class").split(" "), function (i, value) {
                            if (value.indexOf("-afGrid-switch-theme") > -1) {
                                gridId = value.split("-")[0];
                            }
                        });
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
                    $(".afGrid-switch-theme").undelegate(".theme", "click");
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