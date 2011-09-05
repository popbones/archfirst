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
 * @fileoverview Supports the jqPlot demo screen.<br/>
 *
 * Questions:
 * <ol>
 *     <li>How to turn a series on and off using a LegendRenderer instead of checkboxes
 *         (see http://groups.google.com/group/jqplot-users/browse_thread/thread/372ab3ef2e6021c0)</li>
 *     <li>How to animate a series when turning it on or off?</li>
 *     <li>How to create a horizontal legend?</li>
 *     <li>How to create a second dimension for sectors (currently using listbox)?</li>
 * </ol>
 *
 * @requires: ../../libs/jqplot/jquery-jqplot-1.0.0b2/jquery.jqplot.js and several jqPot plugins
 *
 * @author Naresh Bhatia
 */

var ChartingComparison = window.ChartingComparison || {}; ;
ChartingComparison.JqplotDemo = function () {

    var sectors = {};
    var sectorNames = [];
    var plot1;

    $.jqplot.config.enablePlugins = true;

    // Initialize p&l data by sectors
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

    // Plot first sector
    plot1 = $.jqplot('chart1', [sectors[sectorNames[0]].marketMoves, sectors[sectorNames[0]].newTrades, sectors[sectorNames[0]].fees, sectors[sectorNames[0]].total], {
        title: {
            text: 'Cumulative Trading P&L YTD'
        },
        seriesDefaults: {
            show: true,
            showLabel: true,
            showMarker: false
        },
        series: [
                    { label: 'Market Moves' },
                    { label: 'New Trades' },
                    { label: 'Fees and commissions' },
                    { label: 'Total' }
                ],
        axesDefaults: {
            tickOptions: {
                fontSize: '8pt'
            }
        },
        axes: {
            xaxis: {
                label: 'Week',
                labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
                tickOptions: {
                    formatString: '%d'
                }
            },
            yaxis: {
                label: '$ in thousands ($000\'s)',
                labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
                tickOptions: {
                    formatString: '$%d'
                }
            }
        },
        highlighter: {
            show: true,
            sizeAdjust: 7.5
        },
        cursor: {
            show: true,
            zoom: true,
            showTooltip: false
        }
    });

    $('.legendVisibility').click(function () {
        var series_number = 0;
        switch (this.value) {
            case "market-moves":
                series_number = 0;
                break;
            case "new-trades":
                series_number = 1;
                break;
            case "fees":
                series_number = 2;
                break;
            case "total":
                series_number = 3;
                break;
        }
        plot1.series[series_number].show = this.checked;
        plot1.replot();
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
        plot1.series[0].data = sectors[sectorName].marketMoves;
        plot1.series[1].data = sectors[sectorName].newTrades;
        plot1.series[2].data = sectors[sectorName].fees;
        plot1.series[3].data = sectors[sectorName].total;
        plot1.resetAxesScale();
        plot1.replot();
    }
}