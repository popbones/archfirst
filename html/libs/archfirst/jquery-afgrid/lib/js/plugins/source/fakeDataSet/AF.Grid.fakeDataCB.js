(function () {

    AF.Grid.fakeData.CommerzBank = (function () {
        function getColumns() {
            return [
                {
                    label: "Status",
                    id: "colStatus",
                    width: 100,
                    isGroupable: true
                },
                {
                    label: "CCP",
                    id: "colCCP",
                    width: 80,
                    isGroupable: true
                },
                {
                    label: "Trade ID",
                    id: "colTradeId",
                    width: 100,
                    isGroupable: false
                },
                {
                    label: "Trade Date",
                    id: "colTradeDate",
                    type: "DATE",
                    width: 100,
                    isGroupable: true
                },
                {
                    label: "Maturity Date",
                    id: "colMaturityDate",
                    type: "DATE",
                    width: 100,
                    isGroupable: true
                },
                {
                    label: "Notional",
                    id: "colNotional",
                    width: 100,
                    isGroupable: false,
                    type: "NUMERIC"
                },
                {
                    label: "MTM",
                    id: "colMTM",
                    width: 100,
                    isGroupable: true,
                    type: "NUMERIC"
                },
                {
                    label: "Currency",
                    id: "colCurrency",
                    width: 100,
                    isGroupable: true
                },
                {
                    label: "Buy/Sell",
                    id: "colBuySell",
                    width: 100,
                    isGroupable: true
                },
                {
                    label: "Rate",
                    id: "colRate",
                    width: 80,
                    isGroupable: true
                }
            ];
        }

        function getFilters() {
            return [
                {
                    id: "colStatus",
                    type: "MULTI_SELECT",
                    value: AF.Grid.FakeLocalSource.getFilterData("colStatus", rows)
                },
                {
                    id: "colCCP",
                    type: "MULTI_SELECT",
                    value: AF.Grid.FakeLocalSource.getFilterData("colCCP", rows)
                },
                {
                    id: "colTradeId",
                    type: "FREE_TEXT",
                    value: ""
                },
                {
                    id: "colTradeDate",
                    type: "DATE",
                    value: ""
                },
                {
                    id: "colMaturityDate",
                    type: "DATE",
                    value: ""
                },
                {
                    id: "colNotional",
                    filterType: "FREE_TEXT",
                    filterData: ""
                },
                {
                    id: "colMTM",
                    type: "FREE_TEXT",
                    value: ""
                },
                {
                    id: "colCurrency",
                    type: "MULTI_SELECT",
                    value: AF.Grid.FakeLocalSource.getFilterData("colCurrency", rows)
                },
                {
                    id: "colBuySell",
                    type: "MULTI_SELECT",
                    value: AF.Grid.FakeLocalSource.getFilterData("colBuySell", rows)
                }
            ];
        }

        var rows = (function () {
            var rows = [], n;

            for (n = 0; n < 250; n++) {
                rows[rows.length] = {
                    "id": n + 1,
                    "colStatus": ["Cleared", "Pending"][Math.round(Math.random())],
                    "colCCP": ["LCH", "CME"][Math.round(Math.random())],
                    "colTradeId": 78967 + Math.floor(Math.random() * 20000),
                    "colTradeDate": (9 + Math.floor(Math.random() * 12)) + "/" + (10 + Math.floor(Math.random() * 2)) + "/" + 2012,
                    "colMaturityDate": (9 + Math.floor(Math.random() * 12)) + "/" + (10 + Math.floor(Math.random() * 2)) + "/" + 2013,
                    "colNotional": 5000000 + Math.floor(Math.random() * 20000000),
                    "colMTM": 5000000 + Math.floor(Math.random() * 20000000),
                    "colCurrency": ["USD", "GBP", "EUR"][Math.floor(Math.random() * 3)],
                    "colBuySell": ["Buy", "Sell"][Math.round(Math.random())],
                    "colRate": (1 + (Math.floor(Math.random() * 3))) + "%"
                };
            }
            return rows;
        }());

        return {
//            isGridFilterable: false,
//            isGridGroupable: false,
//            isGridSortable: false,
//            state: {
//                filterBy: [],
//                sortBy: [],
//                columnOrder: [],
//                columnWidthOverride: [],
//                groupBy: []
//            },
            columns: getColumns(),
            filters: getFilters(),
            rows: rows,
	        detailsInFirstColumnOnly: false,
	        groupDetails: [
		        {
			        "refLabel": "Cleared",
			        "colNotional": 3000000,
			        "colMTM": 20000000,
			        "groupDetails": [
				        {
					        "refLabel": "CME",
					        "colNotional": 200000,
					        "colMTM": 300000,
					        "groupDetails": [
						        {
							        "refLabel": "Buy",
							        "colNotional": 200000,
							        "colMTM": 300000
						        },
						        {
							        "refLabel": "Sell",
							        "colNotional": 100000,
							        "colMTM": 100000
						        }
					        ]
				        },
				        {
					        "refLabel": "LCH",
					        "colNotional": 100000,
					        "colMTM": 100000,
					        "groupDetails": [
						        {
							        "refLabel": "Buy",
							        "colNotional": 200000,
							        "colMTM": 300000
						        },
						        {
							        "refLabel": "Sell",
							        "colNotional": 100000,
							        "colMTM": 100000
						        }
					        ]
				        }
			        ]
		        },
		        {
			        "refLabel": "Pending",
			        "colNotional": 3000000,
			        "colMTM": 20000000,
			        "groupDetails": [
				        {
					        "refLabel": "CME",
					        "colNotional": 200000,
					        "colMTM": 300000,
					        "groupDetails": [
						        {
							        "refLabel": "Buy",
							        "colNotional": 200000,
							        "colMTM": 300000
						        },
						        {
							        "refLabel": "Sell",
							        "colNotional": 100000,
							        "colMTM": 100000
						        }
					        ]
				        },
				        {
					        "refLabel": "LCH",
					        "colNotional": 100000,
					        "colMTM": 100000,
					        "groupDetails": [
						        {
							        "refLabel": "Buy",
							        "colNotional": 200000,
							        "colMTM": 300000
						        },
						        {
							        "refLabel": "Sell",
							        "colNotional": 100000,
							        "colMTM": 100000
						        }
					        ]
				        }
			        ]
		        }
	        ]
        };

    }());

}());