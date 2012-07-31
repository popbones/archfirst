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
        }
    });
});