(function($){

    $.server = $.server || {};
    $.server.fakeStore = $.server.fakeStore || {};
	var getFilterData = $.server.fakeStore.getFilterData;		
	$.server.fakeStore.GRID2 = (function() {
		function getColumns() {
			return [
				{
					label: "Col 1",
					id: "colAN",
					width: 240,
					filterData: getFilterData(0, rows),
					groupBy: true
				},
				{
					label: "Col 2",
					id: "colAS",
					width: 150,
					filterData: "",
					groupBy: true
				},
				{
					label: "Col 3",
					id: "colAT",
					width: 150,
					groupBy: true,
					filterData: getFilterData(2, rows)
				},
				{
					label: "Col 4",
					id: "colDate",
					width: 100,
					renderer: "DATE",
					filterData: "DATE"
				},
				{
					label: "Col 5",
					id: "colComment",
					width: 100,
					renderer: "LABEL_BUTTON"
				}
			];
		}
		
		var rows = [
			{id:1, data:["Sample Data 1 2","Broadly Marketed","Sample Data 2","25-May-2011","Last Name, First Name"]},
			{id:2, data:["Sample Data 1 2","Broadly Marketed","Sample Data 2","25-May-2011","Last Name, First Name1"]},
			{id:3, data:["Sample Data 3 2","True","Value","25-May-2011","Last Name, First Name"]},
			{id:4, data:["Sample Data 4 2","Large","Small","25-May-2011","Last Name, First Name"]},
			{id:5, data:["Sample Data 4 2","Large","Small","25-May-2011","Last Name, First Name1"]},
			{id:6, data:["Sample Data 4 2","Large","Small","25-May-2011","Last Name, First Name2"]},
			{id:7, data:["Sample Data 5 2","True","False","25-May-2011","Last Name, First Name"]},
			{id:8, data:["Sample Data 5 2","True","False","25-May-2011","Last Name, First Name1"]},
			{id:9, data:["Sample Data 5 2","True","False","25-May-2011","Last Name, First Name3"]},
			{id:10, data:["Sample Data 5 2","True","False","25-May-2011","Last Name, First Name121"]},
			{id:11, data:["Sample Data 5 2","True","False","25-May-2011","Last Name, First Name111"]},
			{id:12, data:["Region 2","Global","US","25-May-2011","Last Name, First Name"]},
			{id:13, data:["Region 2","Global","US","25-May-2011","Last Name, First Name1"]},
			{id:14, data:["Region 2","Global","US","25-May-2011","Last Name, First Name21"]},
			{id:15, data:["Region 2","Global","US","25-May-2011","Last Name, First Name11"]},
			{id:16, data:["Region 2","Global","US","25-May-2011","Last Name, First Name221"]},
			{id:17, data:["Region 2","Global","US","25-May-2011","Last Name, First Name211"]},
			{id:18, data:["Region 2","Global","US","25-May-2011","Last Name, First Name321"]},
			{id:19, data:["Region 2","Global","US","25-May-2011","Last Name, First Name31"]},
			{id:20, data:["Region 2","Global","US","25-May-2011","Last Name, First Name321"]},
			{id:21, data:["Region 2","Global","UK","25-May-2011","Last Name, First Name3"]},
			{id:22, data:["Region 2","Global","UK","25-May-2011","Last Name, First Name4"]},
			{id:23, data:["Style 2","Sector","False","25-May-2011","Last Name, First Name"]},
			{id:24, data:["Style 2","Sector","Value","25-May-2011","Last Name, First Name1"]},
			{id:25, data:["New Sample Data 1 2","Broadly Marketed","Sample Data 2","25-May-2011","Last Name, First Name"]},
			{id:26, data:["New Sample Data 1 2","Broadly Marketed","Sample Data 2","25-May-2011","Last Name, First Name1"]},
			{id:27, data:["New Sample Data 3 2","True","Value","25-May-2011","Last Name, First Name"]},
			{id:28, data:["New Sample Data 4 2","Large","Small","25-May-2011","Last Name, First Name"]}
		];
		
		return {
			columns: getColumns(),
			rows: rows
		}
		
	})();

})(jQuery);
