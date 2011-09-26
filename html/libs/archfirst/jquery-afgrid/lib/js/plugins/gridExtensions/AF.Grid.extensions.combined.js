(function($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.filter = $.afGrid.filter || {};

	$.afGrid.filter.DATE = {
		render: function(id) {
			var text = "<input id='{id}' type='text' class='DATE-filter' value=''/>";
			return text.supplant({
				id: id
			});
		},
		init: function($filter, onFilter) {
			$filter.datepicker({
				onClose: onFilter,
				dateFormat: "dd-M-yy"
			});
		},
		filterBy: function($filter, filterData) {
			$filter.datepicker("setDate",filterData.value);
		},
		getValue: function($filter) {
			return $filter.val();
		},
		destroy: function($filter) {
			$filter.datepicker("destroy");
		}
	}
	
})(jQuery);(function($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.filter = $.afGrid.filter || {};

	$.afGrid.filter.DATERANGE = {
		render: function(id) {
			var text = "<input id='{id}' type='text' class='DATERANGE-filter' value=''/>";
			return text.supplant({
				id: id
			});
		},
		init: function($filter, onFilter) {
			$filter.daterangepicker({
				onClose: function() {
				    $filter.attr("title", $filter.val());
				    onFilter();
				},
				dateFormat: "dd-M-yy"
			});
		},
		filterBy: function($filter, filterData) {
			$filter.val(filterData.value);
			$filter.attr("title", $filter.val());
		},
		getValue: function($filter) {
			return $filter.val();
		},
		destroy: function($filter) {
			$filter.daterangepicker("destroy");
		}
	}
	
})(jQuery);(function($) {

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            LABEL_BUTTON: function($afGrid, options, cachedafGridData) {

				options = $.extend({
                    labelButtonIdentifier: ".button"
                }, options);
				
                function load() {
					$afGrid.delegate(options.labelButtonIdentifier, "click", function() {
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
                }
            }
        }
    });

})(jQuery);

(function($) {

    $.afGrid = $.extend(true, $.afGrid, {
        plugin: {
            THEME_SWITCHER: function($afGrid, options, cachedafGridData) {
				
                function load() {
					var currentTheme={};
					$(".afGrid-switch-theme").delegate(".theme", "click", function() {
						var theme = $(this).attr("href").replace("#","");
						var gridId;
						$.each($(this).closest(".afGrid-switch-theme").attr("class").split(" "), function(i, value) {
							if (value.indexOf("-afGrid-switch-theme")>-1) {
								gridId = value.split("-")[0];
							}
						})
						if (currentTheme[gridId]) {
							$("#" + gridId).removeClass("afGrid-"+currentTheme[gridId]);
							$("."+ gridId +"-afGrid-group-by").removeClass("afGrid-group-by-"+currentTheme[gridId]);
						}
						currentTheme[gridId] = theme;
							$("#" + gridId).addClass("afGrid-"+currentTheme[gridId]);
							$("." + gridId + "-afGrid-group-by").addClass("afGrid-group-by-"+currentTheme[gridId]);
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
                }
            }
        }
    });

})(jQuery);(function($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.renderer = $.afGrid.renderer || {};

    $.afGrid.renderer.DATE = function(data) {
        return "<span class='date'>{date}</span>".supplant({date:data});
    };

})(jQuery);(function($) {

    $.afGrid = $.afGrid || {};
    $.afGrid.renderer = $.afGrid.renderer || {};
	
    $.afGrid.renderer.LABEL_BUTTON = function(columnData, column, columnIndex, row) {
		var formattedLabel = columnData.split(", ")[1].substring(0,1) + ". " + columnData.split(", ")[0];  
        return "<input type='button' class='button' value='{value}'><input type='hidden' value='{actualValue}' class='dataValue'>".supplant({
			value: "Show",
			actualValue: columnData
		});
    };

})(jQuery);