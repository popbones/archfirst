/**
 * Copyright 2011 Archfirst
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @fileoverview Supports Daily P&L screen.
 *
 * @requires: ../../libs/highcharts/highstock-1.0-beta/js/highstock.js
 * @requires: ../../libs/archfirst/utility/string.supplant.js
 * @requires: ../../libs/archfirst/jquery-archfirst-listbox/jquery.archfirst.listbox.js
 *
 * @author Naresh Bhatia
 */

var PortfolioAnalyzer = window.PortfolioAnalyzer || {}; ;
PortfolioAnalyzer.DailyPnl = function () {

    var sectors = {};
    var sectorNames = [];
    var chart1;

    // Get P&L data from server and save it in sectors
    $.ajax({
        // have to use synchronous here, else the function
        // will return before the data is fetched
        async: false,
        url: "pnl-daily-by-sector.csv",
        dataType: "text",
        success: function (csv) {
            var header, comment = /^#/, x;
            $.each(csv.split('\n'), function (i, line) {
                if (!comment.test(line)) {
                    if (!header) {
                        header = line;
                    }
                    else {
                        var point = line.split(','),
								date = point[0].split('/');

                        if (point.length > 1) {
                            x = Date.UTC(date[2], date[0] - 1, date[1]);
                            var sector = getSector(point[1]);
                            sector.marketMoves.push([x, parseInt(point[2])]);
                            sector.newTrades.push([x, parseInt(point[3])]);
                            sector.fees.push([x, parseInt(point[4])]);
                            sector.total.push([x, parseInt(point[5])]);
                        }
                    }

                }
            });
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert(textStatus + ": " + errorThrown);
        }
    });


    // Populate sectorNames
    for (var sectorName in sectors) {
        sectorNames.push(sectorName);
    }


    // Create a chart using data for the first sector
    chart1 = new Highcharts.StockChart({
        chart: {
            renderTo: 'chart1',
            type: 'line',
            spacingBottom: 70
        },
        credits: {
            enabled: false
        },
        title: {
            text: 'Daily Trading P&L'
        },
        xAxis: {
            type: 'datetime',
            title: {
                text: 'Date'
            }
        },
        yAxis: {
            title: {
                text: '$ in thousands ($000\'s)'
            }
        },
        legend: {
            enabled: true,
            y: 50
        },
        series: [{
            id: "marketMoves",
            name: 'Market Moves',
            data: sectors[sectorNames[0]].marketMoves,
            marker: { enabled: false }
        }, {
            id: "newTrades",
            name: 'New Trades',
            data: sectors[sectorNames[0]].newTrades,
            marker: { enabled: false }
        }, {
            id: "fees",
            name: 'Fees and Commissions',
            data: sectors[sectorNames[0]].fees,
            marker: { enabled: false }
        }, {
            id: "total",
            name: 'Total',
            data: sectors[sectorNames[0]].total,
            marker: { enabled: false }
        }]
    });

    // Add a click event to sector list to repopulate the chart
    $('#sectorList li a').click(function () {
        swtichSector(this.innerText);
    });

    function getSector(name) {
        var sector = sectors[name];
        if (sector == null) {
            sector = new Object();
            sector.marketMoves = [];
            sector.newTrades = [];
            sector.fees = [];
            sector.total = [];
            sectors[name] = sector;
        }
        return sector;
    }

    function switchSector(sectorName) {
        chart1.get("marketMoves").setData(sectors[sectorName].marketMoves, false);
        chart1.get("newTrades").setData(sectors[sectorName].newTrades, false);
        chart1.get("fees").setData(sectors[sectorName].fees, false);
        chart1.get("total").setData(sectors[sectorName].total, false);
        chart1.redraw();
    }

    $('#sectorList').archfirstListbox({
        data: sectorNames,
        onClickOfItem: switchSector
    });
}