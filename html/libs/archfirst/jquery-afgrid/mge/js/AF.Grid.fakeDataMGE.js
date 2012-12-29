(function () {

    AF.Grid.fakeDataMGE = (function () {
        function getColumns() {
            return [
                {
                    label: "Security",
                    id: "security",
                    width: 100
                },
                {
                    label: "Symbol",
                    id: "symbol",
                    width: 50
                },
                {
                    label: "Quantity",
                    id: "quantity",
                    width: 50,
                    type: "NUMERIC"
                },
                {
                    label: "Last Trade",
                    id: "lastTrade",
                    width: 60,
                    type: "MONEY"
                },
                {
                    label: "Market Value",
                    id: "marketValue",
                    width: 80,
                    type: "MONEY"
                },
                {
                    label: "Price Paid",
                    id: "pricePaid",
                    width: 80,
                    isGroupable: false,
                    type: "MONEY"
                },
                {
                    label: "Total Cost",
                    id: "totalCost",
                    width: 80,
                    type: "MONEY"
                },
                {
                    label: "Gain",
                    id: "gain",
                    width: 80,
                    type: "MONEY"
                },
                {
                    label: "Gain %",
                    id: "gainPercent",
                    width: 80,
                    type: "PERCENTAGE"
                }
            ];
        }

        var rows = (function(data) {
            $.each(data, function(i, item) {
                item.marketValue = item.lastTrade * item.quantity;
                item.totalCost = item.pricePaid * item.quantity;
                item.gain = item.marketValue - item.totalCost;
                item.gainPercent = (item.gain/item.totalCost) * 100;
            });
            return data;
        }([
            {
                "security": "Apple",
                "symbol": "AAPL",
                "quantity": 100,
                "lastTrade": 700,
                "pricePaid": 350
            },
            {
                "security": "Goldman Sachs Group Inc.",
                "symbol": "GS",
                "quantity": 500,
                "lastTrade": 116.32,
                "pricePaid": 60.11
            },
            {
                "security": "Chevron Corporation",
                "symbol": "CVX",
                "quantity": 300,
                "lastTrade": 118.01,
                "pricePaid": 62.70
            },
            {
                "security": "Google",
                "symbol": "GOOG",
                "quantity": 200,
                "lastTrade": 55,
                "pricePaid": 30
            },
            {
                "security": "Amazon.com Inc.",
                "symbol": "AMZN",
                "quantity": 100,
                "lastTrade": 255.12,
                "pricePaid": 141
            },
            {
                "security": "Microsoft, Inc.",
                "symbol": "MSFT",
                "quantity": 200,
                "lastTrade": 71.55,
                "pricePaid": 40.23
            },
            {
                "security": "Coca-Cola Enterprises Inc.",
                "symbol": "CCE",
                "quantity": 500,
                "lastTrade": 31.22,
                "pricePaid": 18.15
            },
            {
                "security": "Adobe Systems Inc.",
                "symbol": "ADBE",
                "quantity": 300,
                "lastTrade": 33.49,
                "pricePaid": 20.22
            },
            {
                "security": "Colgate-Palmolive Company",
                "symbol": "CL",
                "quantity": 300,
                "lastTrade": 106.79,
                "pricePaid": 67.16
            },
            {
                "security": "Dell Inc.",
                "symbol": "DELL",
                "quantity": 300,
                "lastTrade": 10.14,
                "pricePaid": 6.54
            },
            {
                "security": "Cisco",
                "symbol": "CSCO",
                "quantity": 600,
                "lastTrade": 60,
                "pricePaid": 40
            },
            {
                "security": "The Walt Disney Company",
                "symbol": "DIS",
                "quantity": 300,
                "lastTrade": 52.81,
                "pricePaid": 36.67
            },
            {
                "security": "The Dow Chemical Company",
                "symbol": "DOW",
                "quantity": 300,
                "lastTrade": 30.20,
                "pricePaid": 21.88
            },
            {
                "security": "eBay Inc.",
                "symbol": "EBAY",
                "quantity": 300,
                "lastTrade": 49.27,
                "pricePaid": 37.90
            },
            {
                "security": "EMC Corporation",
                "symbol": "EMC",
                "quantity": 300,
                "lastTrade": 27.74,
                "pricePaid": 22.19
            },
            {
                "security": "The Boeing Company",
                "symbol": "BA",
                "quantity": 600,
                "lastTrade": 69.53,
                "pricePaid": 57
            },
            {
                "security": "Kellogg Company",
                "symbol": "K",
                "quantity": 500,
                "lastTrade": 70,
                "pricePaid": 60
            },
            {
                "security": "General Electric",
                "symbol": "GE",
                "quantity": 1000,
                "lastTrade": 22.53,
                "pricePaid": 22.53
            },
            {
                "security": "Akamai Technologies Inc.",
                "symbol": "AKAM",
                "quantity": 500,
                "lastTrade": 38.33,
                "pricePaid": 40.59
            },
            {
                "security": "Eastman Chemical Company",
                "symbol": "EMN",
                "quantity": 250,
                "lastTrade": 56.37,
                "pricePaid": 63.23
            },
            {
                "security": "Bank of America Corporation",
                "symbol": "BAC",
                "quantity": 2000,
                "lastTrade": 9.10,
                "pricePaid": 11.10
            },
            {
                "security": "Raytheon Company",
                "symbol": "RTN",
                "quantity": 200,
                "lastTrade": 57.93,
                "pricePaid": 76.22
            },
            {
                "security": "Advanced Micro Devices Inc.",
                "symbol": "AMD",
                "quantity": 2000,
                "lastTrade": 3.49,
                "pricePaid": 5.00
            },
            {
                "security": "Electronic Arts Inc.",
                "symbol": "EA",
                "quantity": 1000,
                "lastTrade": 13.27,
                "pricePaid": 22.11
            },
            {
                "security": "Northeast Utilities",
                "symbol": "NU",
                "quantity": 100,
                "lastTrade": 38.02,
                "pricePaid": 76.04
            },
            {
                "security": "Radioshack Corporation",
                "symbol": "RSH",
                "quantity": 500,
                "lastTrade": 3.08,
                "pricePaid": 6.84
            },
            {
                "security": "Yahoo! Inc.",
                "symbol": "YHOO",
                "quantity": 200,
                "lastTrade": 20,
                "pricePaid": 50
            },
            {
                "security": "Urban Outfitters",
                "symbol": "URBN",
                "quantity": 500,
                "lastTrade": 10,
                "pricePaid": 40
            },
            {
                "security": "The Loosers 1",
                "symbol": "LSR1",
                "quantity": 2500,
                "lastTrade": 1.28,
                "pricePaid": 6.4
            },
            {
                "security": "The Loosers 2",
                "symbol": "LSR2",
                "quantity": 500,
                "lastTrade": 0,
                "pricePaid": 40
            },
            {
                "security": "Cash",
                "symbol": "CASH",
                "quantity": 10000,
                "lastTrade": 1,
                "pricePaid": 1
            }
        ]));

        return {
            isGridFilterable: false,
            isGridGroupable: false,
            isGridSortable: false,
            showTotalRows: false,
//            isGridColumnResizable: false,
            showToolbar: false,
            columns: getColumns(),
            rows: rows
        };

    }());

}());