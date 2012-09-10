 (function ($) {

    AF.Grid.fakeDataCB = (function () {
        function getColumns() {
            return [{
                label:"Status",
                id:"colStatus",
                width: 100,
                filterData:"",
                groupBy: true
            }, {
                label:"CCP",
                id:"colCCP",
                width: 80,
                filterData: AF.Grid.FakeLocalStore.getFilterData("colCCP", rows),
                groupBy: true           
            }, {
                label:"Product Type",
                id:"colProdType",
                width: 80,
                filterData: AF.Grid.FakeLocalStore.getFilterData("colProdType", rows),
                groupBy: true
            }, {
                label:"Trade ID",
                id:"colTradeId",
                width: 100,
                filterData:"",
                groupBy: true
            }, {
                label:"Trade Date",
                id:"colTradeDate",
                renderer:"DATE",
                width: 100,
                filterData:"DATERANGE",
                groupBy: true
            }, {
                label:"Maturity Date",
                id:"colMaturityDate",
                renderer:"DATE",
                width: 100,
                filterData:"DATERANGE",
                groupBy: true
            }, {
                label:"Notional",
                id:"colNotional",
                width: 100,
                filterData:"",
                groupBy: true,
                renderer: "NUMBER"
            }, {
                label:"MTM",
                id:"colMTM",
                width: 100,
                filterData:"",
                groupBy: true,
                renderer: "NUMBER"
            }, {
                label:"Currency",
                id:"colCurrency",
                width: 100,
                filterData: AF.Grid.FakeLocalStore.getFilterData("colCurrency", rows),
                groupBy: true
            }, {
                label:"Buy/Sell",
                id:"colBuySell",
                width: 100,
                filterData: AF.Grid.FakeLocalStore.getFilterData("colBuySell", rows),
                groupBy: true
            }, {
                label:"Rate",
                id:"colRate",
                width: 80,
                filterData:"",
                groupBy: true
            }];
        }
                
        var rows = (function() {
            var rows = [], n, l;

            for (n=0; n<2000; n++) {
                rows[rows.length] = {
                    "colStatus": ["Cleared", "Pending"][Math.round(Math.random())],
                    "colCCP": ["LCH", "CME"][Math.round(Math.random())],
                    "colProdType": "IRS",
                    "colTradeId": 78967+Math.floor(Math.random()*20000),
                    "colTradeDate": (9+Math.floor(Math.random()*12)) + "/" + (10+Math.floor(Math.random()*2)) + "/" + 2012,
                    "colMaturityDate": (9+Math.floor(Math.random()*12)) + "/" + (10+Math.floor(Math.random()*2)) + "/" + 2013,
                    "colNotional": 5000000 + Math.floor(Math.random()*20000000),
                    "colMTM": 5000000 + Math.floor(Math.random()*20000000),
                    "colCurrency": ["USD", "GBP", "EUR"][Math.floor(Math.random()*3)],
                    "colBuySell": ["Buy", "Sell"][Math.round(Math.random())],
                    "colRate": (1+(Math.floor(Math.random()*3)))+"%"
                }
            }
            return rows;
        }());

        return {
            columns: getColumns(),
            rows: rows
        };

    }());

}(jQuery));