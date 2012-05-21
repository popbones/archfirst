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
* app/extensions/SmartChartTheme
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.extensions.SmartChartTheme', {
    extend: 'Ext.chart.theme.Base',

    statics: {
        lightColors: [
            '#fde79c',
            '#b9d6f7',
            '#fbb7b5',
            '#b8c0ac',
            '#a9a3bd',
            '#98c1dc',
            '#9dc2b3',
            '#b1a1b1',
            '#c1c0ae',
            '#adbdc0'
        ],

        darkColors: [
            '#f6bc0c',
            '#284b70',
            '#702828',
            '#5f7143',
            '#382c6c',
            '#0271ae',
            '#1d7554',
            '#50224f',
            '#706e41',
            '#446a73'
        ],

        chartGradients: null,

        legendGradients: null,

        chartColors: null,

        legendColors: null,

        createColorGradients: function createColorGradients() {
            var chartColors = [];
            var legendColors = [];
            var chartGradients = [];
            var legendGradients = [];

            for (var i = 0; i < this.lightColors.length; i++) {
                var chartGradient = {
                    id: 'smartChartColorId' + i,
                    angle: 225,
                    stops: {
                        0: {
                            color: this.lightColors[i]
                        },
                        20: {
                            color: this.darkColors[i]
                        }
                    }
                };
                chartGradients.push(chartGradient);
                chartColors.push('url(#smartChartColorId' + i + ')');

                var legendGradient = {
                    id: 'smartLegendColorId' + i,
                    angle: 225,
                    stops: {
                        0: {
                            color: this.lightColors[i]
                        },
                        5: {
                            color: this.darkColors[i]
                        }
                    }
                };

                legendGradients.push(legendGradient);
                legendColors.push('url(#smartLegendColorId' + i + ')');
            };
            this.chartColors = chartColors;
            this.chartGradients = chartGradients;
            this.legendColors = legendColors;
            this.legendGradients = legendGradients;

            return chartGradients;
        }
    },

    constructor: function (config) {
        this.callParent([Ext.apply({
            colors: Bullsfirst.extensions.SmartChartTheme.chartColors
        }, config)]);
    }



},
function () {
    Ext.chart.theme['SmartChartTheme'] = (function () { return new Bullsfirst.extensions.SmartChartTheme(); });
});

 
	
