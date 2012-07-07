(function ($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.filter = $.afGrid.filter || {};

    $.afGrid.filter.DATE = {
        render: function (id) {
            var text = "<input id='{id}' type='text' class='DATE-filter' value=''/>";
            return text.supplant({
                id: id
            });
        },
        init: function ($filter, onFilter) {
            $filter.datepicker({
                onClose: onFilter,
                dateFormat: "dd-M-yy"
            });
        },
        filterBy: function ($filter, filterData) {
            $filter.datepicker("setDate", filterData.value);
        },
        getValue: function ($filter) {
            return $filter.val();
        },
        destroy: function ($filter) {
            $filter.datepicker("destroy");
        }
    };

}(jQuery));(function ($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.filter = $.afGrid.filter || {};

    $.afGrid.filter.DATERANGE = {
        render: function (id) {
            var text = "<input id='{id}' type='text' class='DATERANGE-filter' value=''/>";
            return text.supplant({
                id: id
            });
        },
        init: function ($filter, onFilter) {
            $filter.daterangepicker({
                onClose: function () {
                    $filter.attr("title", $filter.val());
                    onFilter();
                },
                dateFormat: "dd-M-yy"
            });
        },
        filterBy: function ($filter, filterData) {
            $filter.val(filterData.value);
            $filter.attr("title", $filter.val());
        },
        getValue: function ($filter) {
            return $filter.val();
        },
        destroy: function ($filter) {
            $filter.daterangepicker("destroy");
        }
    };

}(jQuery));(function ($) {

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

}(jQuery));(function ($) {

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

}(jQuery));(function ($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.renderer = $.afGrid.renderer || {};

    $.afGrid.renderer.DATE = function (data) {
        return "<span class='date'>{date}</span>".supplant({
            date: data
        });
    };

}(jQuery));(function ($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.renderer = $.afGrid.renderer || {};

    $.afGrid.renderer.LABEL_BUTTON = function (columnData, column, columnIndex, row) {
        var formattedLabel = columnData.split(", ")[1].substring(0, 1) + ". " + columnData.split(", ")[0];
        return "<input type='button' class='button' value='{value}'><input type='hidden' value='{actualValue}' class='dataValue'>".supplant({
            value: "Show",
            actualValue: columnData
        });
    };

}(jQuery));(function ($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.renderer = $.afGrid.renderer || {};

    $.afGrid.renderer.NUMBER = function (data) {
        return data;
    };

}(jQuery));(function ($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.renderer = $.afGrid.renderer || {};

    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    
    $.afGrid.renderer.SYSTEM_DATE = function (data) {
        var dateParts = data.split("-");
        var stringDate = data !== "-" ? [dateParts[2],"-",monthNames[(+dateParts[1])-1],"-",dateParts[0]].join("") : "-";
        return "<span class='date'>{date}</span>".supplant({
            date: stringDate 
        });
    };

}(jQuery));