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
* app/view/trading/LegendItem
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.view.trading.LegendItem', {
    extend: 'Ext.draw.Component',

    smartChartTheme: null,
    legendText: null,
    colorIndex: 0,    

    //Functions
    initComponent: function initAccountsViewComponents() {
        this.smartChartTheme = Bullsfirst.extensions.SmartChartTheme;
        var viewConfig = {
            gradients: this.smartChartTheme.legendGradients,
            viewBox: false
        };
        this.buildConfig(viewConfig);
        Ext.apply(this, Ext.apply(this.initialConfig, viewConfig));
        this.callParent();
    },
    buildConfig: function buildAccountsViewConfig(viewConfig) {
        this.buildItems(viewConfig);
    },
    buildItems: function buildAccountsViewItems(viewConfig) {
        viewConfig.items = [
            {
                type: 'rect',
                fill: this.smartChartTheme.legendColors[this.colorIndex],
                radius: 1,
                'stroke-width': 1,
                stroke: '#272727',
                width: 15,
                height: 15,
                x: 5,
                y: 5
            },
            {                                                       
                type: 'text',
                fill: 'black',
                font: '12px tahoma',
                text: this.legendText,
                x: 30,
                y: 13
            }
        ];
    }

});
