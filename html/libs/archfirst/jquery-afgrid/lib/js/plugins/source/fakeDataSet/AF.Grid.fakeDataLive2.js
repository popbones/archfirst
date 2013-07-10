(function () {

    AF.Grid.fakeData.liveDataSample2 = (function () {
        function getColumns() {
            return [
                {
                    label: "Market",
                    id: "colName",
                    width: 100
                },
                {
                    label: "Time",
                    id: "colTime",
                    type: "DATE",
                    width: 70
                },
                {
                    label: "Bid Size",
                    id: "colBidSize",
                    width: 50,
                    type: "NUMERIC"
                },
                {
                    label: "Bid",
                    id: "colBid",
                    width: 50,
                    type: "NUMERIC"
                },
                {
                    label: "Ask",
                    id: "colAsk",
                    width: 50,
                    type: "NUMERIC"
                },
                {
                    label: "Ask Size",
                    id: "colAskSize",
                    width: 50,
                    type: "NUMERIC"
                },
                {
                    label: "Min",
                    id: "colMin",
                    width: 50,
                    type: "NUMERIC"
                },
                {
                    label: "Max",
                    id: "colMax",
                    width: 50,
                    type: "NUMERIC"
                }
            ];
        }

        var rows = (function () {
            var NAMES = ["FTSE 100", "Germany 30", "Wall Street", "Spot FX GBP/USD", "Spot FX EUR/USD", "BP Plc", "Barclays Plc", "Vodafone Group Plc", "Spot Gold"];
            var rows = [], n;
            for (n = 0; n < NAMES.length; n++) {
                rows[rows.length] = {
                    "id": n + 1,
                    "colName": NAMES[n],
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
                isGridGroupable: false,
                isGridSortable: false,
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
                rows: rows
            };
            if (window.localStorage) {
                localStorage.gridData = JSON.stringify(data);
            }
        }
        return data;

    }());

}());