/**
 * Copyright 2012 Archfirst
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
 * bullsfirst/views/AccountChartView
 *
 * @author Naresh Bhatia
 */
define(function() {

    var accounts_title = 'All Accounts';
    var accounts_subtitle = 'Click on an account to view positions';
    var positions_subtitle = 'Click on the chart to return to all accounts';
    var colors = [
        { radialGradient: {cx: 0, cy: 0, r: 1}, stops: [[0, '#fde79c'], [1, '#f6bc0c']] },
        { radialGradient: {cx: 0, cy: 0, r: 1}, stops: [[0, '#b9d6f7'], [1, '#284b70']] },
        { radialGradient: {cx: 0, cy: 0, r: 1}, stops: [[0, '#fbb7b5'], [1, '#702828']] },
        { radialGradient: {cx: 0, cy: 0, r: 1}, stops: [[0, '#b8c0ac'], [1, '#5f7143']] },
        { radialGradient: {cx: 0, cy: 0, r: 1}, stops: [[0, '#a9a3bd'], [1, '#382c6c']] },
        { radialGradient: {cx: 0, cy: 0, r: 1}, stops: [[0, '#98c1dc'], [1, '#0271ae']] },
        { radialGradient: {cx: 0, cy: 0, r: 1}, stops: [[0, '#9dc2b3'], [1, '#1d7554']] },
        { radialGradient: {cx: 0, cy: 0, r: 1}, stops: [[0, '#b1a1b1'], [1, '#50224f']] },
        { radialGradient: {cx: 0, cy: 0, r: 1}, stops: [[0, '#c1c0ae'], [1, '#706e41']] },
        { radialGradient: {cx: 0, cy: 0, r: 1}, stops: [[0, '#adbdc0'], [1, '#446a73']] }
    ];

    return Backbone.View.extend({

        el: '#accounts_chart',

        initialize: function(options) {
            this.collection.bind('reset', this.render, this);
        },

        render: function() {
            var context = this;

            // Convert accounts collection to a structure understood by the Highcharts
            this.accounts = this.collection.map(function(account) {
                return {
                    name: account.get('name'),
                    y: account.get('marketValue').amount,
                    positions: account.get('positions').map(function(position) {
                        return {
                            name: position.get('instrumentSymbol'),
                            y: position.get('marketValue').amount
                        }
                    })
                };
            });

            // Sort accounts by descending market value and assign colors
            this.accounts = _.sortBy(this.accounts, function(account) { return -account.y; }) ;
            if (this.accounts.length > 10) {
                this._truncateSeries(this.accounts);
                this.accounts[9].positions =
                    [{name: 'Miscellaneous', y: this.accounts[9].y}]
            }
            _.each(this.accounts, function(account, index) {
                account.color = colors[index % 10];
                account.positions = _.sortBy(account.positions, function(position) {
                    return -position.y;
                }) ;
                if (account.positions.length > 10) {
                    this._truncateSeries(account.positions);
                }
                _.each(account.positions, function(position, index) {
                    position.color = colors[index % 10];
                });
            }, this);

            var chart = new Highcharts.Chart({
                chart: {
                    renderTo: 'accounts_chart',
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false
                },
                title: {
                    text: accounts_title
                },
                subtitle: {
                    text: accounts_subtitle
                },
                credits: {
                    enabled: false
                },
                tooltip: {
                    formatter: function() {
                        return this.point.name + '<br/>' + this.percentage.toFixed(1) +' %';
                    }
                },
                plotOptions: {
                    pie: {
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false
                        },
                        showInLegend: true,
                        shadow: false,
                        point: {
                            events: {
                                click: function(event) {
                                    // Positions exist only at the account level
                                    var positions = this.positions;
                                    var name = this.name;
                                    chart.series[0].remove();  // 'this' is now destroyed, don't use it
                                    if (positions) {  // drill down
                                        chart.setTitle({text: name}, {text: positions_subtitle});
                                        chart.addSeries({
                                            type: 'pie',
                                            name: name,
                                            data: positions
                                        });
                                    }
                                    else {  // restore
                                        chart.setTitle({text: accounts_title}, {text: accounts_subtitle});
                                        chart.addSeries({
                                            type: 'pie',
                                            name: accounts_title,
                                            data: context.accounts
                                        });
                                    }
                                }
                            }
                        }
                    }
                },
                legend: {
                    itemWidth: 160
                },
                series: [{
                    type: 'pie',
                    name: 'All Accounts',
                    data: context.accounts
                }]
            });

            return this;
        },

        /* Truncates the series to 10 points */
        _truncateSeries: function(series) {
            var elementsToRemove = series.length - 10;
            for (i=elementsToRemove; i>0; i--) {
                var point = series.pop();
                series[9].y += point.y;
            }
            series[9].name = 'Other';
        }
    });
});