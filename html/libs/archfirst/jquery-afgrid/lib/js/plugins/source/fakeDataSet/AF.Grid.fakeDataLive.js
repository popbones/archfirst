(function () {

    AF.Grid.fakeData.liveDataSample = (function () {
        function getColumns() {
            return [
                {
                    label: "Client Name",
                    id: "colClientName",
                    width: 100,
                    isGroupable: true
                },
                {
                    label: "Name",
                    id: "colName",
                    width: 100,
                    isGroupable: false
                },
                {
                    label: "Time",
                    id: "colTime",
                    type: "DATE",
                    width: 70,
                    isGroupable: false,
                    isSortable: false
                },
                {
                    label: "Bid Size",
                    id: "colBidSize",
                    width: 50,
                    isGroupable: false,
                    isSortable: false,
                    type: "NUMERIC"
                },
                {
                    label: "Bid",
                    id: "colBid",
                    width: 50,
                    isGroupable: false,
                    isSortable: false,
                    type: "NUMERIC"
                },
                {
                    label: "Ask",
                    id: "colAsk",
                    width: 50,
                    isGroupable: false,
                    isSortable: false,
                    type: "NUMERIC"
                },
                {
                    label: "Ask Size",
                    id: "colAskSize",
                    width: 50,
                    isGroupable: false,
                    isSortable: false,
                    type: "NUMERIC"
                },
                {
                    label: "Min",
                    id: "colMin",
                    width: 50,
                    isGroupable: false,
                    isSortable: false,
                    type: "NUMERIC"
                },
                {
                    label: "Max",
                    id: "colMax",
                    width: 50,
                    isGroupable: false,
                    isSortable: false,
                    type: "NUMERIC"
                }
            ];
        }

        function getFilters() {
            return [
                {
                    id: "colStatus",
                    type: "FREE_TEXT"
                }
            ];
        }

        var rows = (function () {
            var rows = [], n;

            for (n = 0; n < 50; n++) {
                rows[rows.length] = {
                    "id": n + 1,
                    "colClientName": "Client_" + Math.floor(Math.random()*5),
                    "colName": "Product_" + n,
                    "colTime": new Date().toLocaleTimeString(),
                    "colBidSize": Math.floor(Math.random() * 40000),
                    "colBid": (1 + (Math.random() * 30)),
                    "colAsk": (1 + (Math.random() * 30)),
                    "colAskSize": Math.floor(Math.random() * 40000),
                    "colMin": (1 + (Math.random() * 30)),
                    "colMax": (30 + (Math.random() * 30))
                };
            }
            return rows;
        }());

        var data = null;
        if (window.localStorage) {
            data = (localStorage.gridData && JSON.parse(localStorage.gridData)) || null;
        }
        if (location.hash.indexOf("child")<0) {
            data = {
                isGridFilterable: false,
//            isGridGroupable: false,
//            isGridSortable: false,
//            state: {
//                filterBy: [],
//                sortBy: [],
//                columnOrder: [],
//                columnWidthOverride: [],
//                groupBy: []
//            },
                groupDetailsInFirstColumnOnly: true,
                pageSize: 50,
                columns: getColumns(),
                filters: getFilters(),
                rows: rows
            };
            if (window.localStorage) {
                localStorage.gridData = JSON.stringify(data);
            }
        }
        return data;

    }());

}());