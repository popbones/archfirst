﻿/**
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
 * @fileoverview Supports the Highcharts demo screen.
 *
 * @requires: ../../libs/highcharts/highcharts-2.1.6/js/highcharts.js
 *
 * @author Naresh Bhatia
 */

var ChartingComparison = window.ChartingComparison || {}; ;
ChartingComparison.HighchartsDemo = function () {

    var sectors = {};
    var sectorNames = [];
    var chart1;

    // Get P&L data from server and save it in sectors
    $.ajax({
        // have to use synchronous here, else the function 
        // will return before the data is fetched
        async: false,
        url: "cumulative-pnl-weekly-by-sector.json",
        dataType: "json",
        success: function (data) {
            for (var i = 0; i < data.length; i++) {
                var sector = getSector(data[i].sector);
                sector.marketMoves.push([data[i].week, data[i].marketMoves]);
                sector.newTrades.push([data[i].week, data[i].newTrades]);
                sector.fees.push([data[i].week, data[i].fees]);
                sector.total.push([data[i].week, data[i].total]);
            }
        }
    });

    // Create sector names and populate in sector listbox
    var options = "";
    var selected = ' selected="selected"';
    for (var sectorName in sectors) {
        sectorNames.push(sectorName);
        options += '<option value="' + sectorName + '"' + selected + '>' + sectorName + '</option>';
        selected = "";  // clear selected after first time through the loop
    }
    $('#sectorList').html(options);

    // Create a chart using data for the first sector
    chart1 = new Highcharts.Chart({
        chart: {
            renderTo: 'chart1',
            type: 'line'
        },
        credits: {
            enabled: false
        },
        title: {
            text: 'Cumulative Trading P&L YTD'
        },
        xAxis: {
            title: {
                text: 'Week'
            }
        },
        yAxis: {
            title: {
                text: '$ in thousands ($000\'s)'
            }
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

    // Add a change event to sector list to repopulate the chart
    $('#sectorList').change(function () {
        swtichSector(this.value);
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

    function swtichSector(sectorName) {
        chart1.get("marketMoves").setData(sectors[sectorName].marketMoves, false);
        chart1.get("newTrades").setData(sectors[sectorName].newTrades, false);
        chart1.get("fees").setData(sectors[sectorName].fees, false);
        chart1.get("total").setData(sectors[sectorName].total, false);
        chart1.redraw();
    }
}