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
* app/extensions/SmartChartLegend
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.extensions.SmartChartLegend', {
    extend: 'Ext.chart.Legend',

    /**
    * @private Create all the sprites for the legend
    */
    create: function () {
        var me = this,
            seriesItems = me.chart.series.items,
            i, ln, series;

        me.createBox();

        if (me.rebuild !== false) {
            me.createItems();
        }

        if (!me.created && me.isDisplayed()) {
            me.created = true;

            // Listen for changes to series titles to trigger regeneration of the legend
            for (i = 0, ln = seriesItems.length; i < ln; i++) {
                series = seriesItems[i];
                series.on('titlechange', function () {
                    me.create();
                    me.updatePosition();
                });
            }
        }
    },

    /**
    * @private Determine whether the legend should be displayed. Looks at the legend's 'visible' config,
    * and also the 'showInLegend' config for each of the series.
    */
    isDisplayed: function () {
        return this.visible && this.chart.series.findIndex('showInLegend', true) !== -1;
    },

    /**
    * @private Create the series markers and labels
    */
    createItems: function () {
        var me = this,
            chart = me.chart,
            seriesItems = chart.series.items,
            ln, series,
            surface = chart.surface,
            items = me.items,
            padding = me.padding,
            itemSpacing = me.itemSpacing,
            spacingOffset = 2,
            maxWidth = 0,
            maxHeight = 0,
            totalWidth = 0,
            totalHeight = 0,
            vertical = true,
            math = Math,
            mfloor = math.floor,
            mmax = math.max,
            index = 0,
            i = 0,
            len = items ? items.length : 0,
            x, y, spacing, item, bbox, height, width,
            fields, field, nFields, j;

        //remove all legend items
        if (len) {
            for (; i < len; i++) {
                items[i].destroy();
            }
        }
        //empty array
        items.length = [];
        // Create all the item labels, collecting their dimensions and positioning each one
        // properly in relation to the previous item
        for (i = 0, ln = seriesItems.length; i < ln; i++) {
            series = seriesItems[i];
            if (series.showInLegend) {
                fields = [].concat(series.yField);
                for (j = 0, nFields = fields.length; j < nFields; j++) {
                    field = fields[j];
                    item = new Ext.chart.LegendItem({
                        legend: this,
                        series: series,
                        surface: chart.surface,
                        yFieldIndex: j
                    });
                    bbox = item.getBBox();

                    //always measure from x=0, since not all markers go all the way to the left
                    width = bbox.width;
                    height = bbox.height;

                    if (i + j === 0) {
                        spacing = vertical ? padding + height / 2 : padding;
                    }
                    else {
                        spacing = itemSpacing / (vertical ? 2 : 1);
                    }
                    // Set the item's position relative to the legend box
                    item.x = mfloor(vertical ? padding : totalWidth + spacing);
                    item.y = mfloor(vertical ? totalHeight + spacing : padding + height / 2);

                    // Collect cumulative dimensions
                    totalWidth += width + spacing;
                    totalHeight += height + spacing;
                    maxWidth = mmax(maxWidth, width);
                    maxHeight = mmax(maxHeight, height);

                    items.push(item);
                }
            }
        }

        // Store the collected dimensions for later
        me.width = mfloor((vertical ? maxWidth : totalWidth) + padding * 2);
        if (vertical && items.length === 1) {
            spacingOffset = 1;
        }
        me.height = mfloor((vertical ? totalHeight - spacingOffset * spacing : maxHeight) + (padding * 2));
        me.itemHeight = maxHeight;
    },

    /**
    * @private Get the bounds for the legend's outer box
    */
    getBBox: function () {
        var me = this;
        return {
            x: Math.round(me.x) - me.boxStrokeWidth / 2,
            y: Math.round(me.y) - me.boxStrokeWidth / 2,
            width: 100,
            height: 100
        };
    },

    /**
    * @private Create the box around the legend items
    */
    createBox: function () {
        var me = this,
            box, bbox;

        if (me.boxSprite) {
            me.boxSprite.destroy();
        }

        bbox = me.getBBox();
        //if some of the dimensions are NaN this means that we
        //cannot set a specific width/height for the legend
        //container. One possibility for this is that there are
        //actually no items to show in the legend, and the legend
        //should be hidden.
        if (isNaN(bbox.width) || isNaN(bbox.height)) {
            me.boxSprite = false;
            return;
        }

        box = me.boxSprite = me.chart.surface.add(Ext.apply({
            type: 'rect',
            stroke: me.boxStroke,
            "stroke-width": me.boxStrokeWidth,
            fill: me.boxFill,
            zIndex: me.boxZIndex
        }, bbox));

        box.redraw();
    },

    /**
    * @private Update the position of all the legend's sprites to match its current x/y values
    */
    updatePosition: function () {
        var me = this,
            items = me.items,
            i, ln,
            x, y,
            legendWidth = me.width || 0,
            legendHeight = me.height || 0,
            padding = me.padding,
            chart = me.chart,
            chartBBox = chart.chartBBox,
            insets = chart.insetPadding,
            chartWidth = chartBBox.width - (insets * 2),
            chartHeight = chartBBox.height - (insets * 2),
            chartX = chartBBox.x + insets,
            chartY = chartBBox.y + insets,
            surface = chart.surface,
            mfloor = Math.floor,
            bbox;

        if (me.isDisplayed()) {
            // Find the position based on the dimensions
            switch (me.position) {
                case "left":
                    x = insets;
                    y = mfloor(chartY + chartHeight / 2 - legendHeight / 2);
                    break;
                case "right":
                    x = mfloor(surface.width - legendWidth) - insets;
                    y = mfloor(chartY + chartHeight / 2 - legendHeight / 2);
                    break;
                case "top":
                    x = mfloor(chartX + chartWidth / 2 - legendWidth / 2);
                    y = insets;
                    break;
                case "bottom":
                    x = mfloor(chartX + chartWidth / 2 - legendWidth / 2);
                    y = mfloor(surface.height - legendHeight) - insets;
                    break;
                default:
                    x = mfloor(me.origX) + insets;
                    y = mfloor(me.origY) + insets;
            }
            me.x = x;
            me.y = y;

            // Update the position of each item
            for (i = 0, ln = items.length; i < ln; i++) {
                items[i].updatePosition();
            }

            bbox = me.getBBox();

            //if some of the dimensions are NaN this means that we
            //cannot set a specific width/height for the legend
            //container. One possibility for this is that there are
            //actually no items to show in the legend, and the legend
            //should be hidden.
            if (isNaN(bbox.width) || isNaN(bbox.height)) {
                if (me.boxSprite) {
                    me.boxSprite.hide(true);
                }
            } else {
                if (!me.boxSprite) {
                    me.createBox();
                }
                // Update the position of the outer box
                me.boxSprite.setAttributes(bbox, true);
                me.boxSprite.show(true);
            }
        }
    },

    /** toggle
    * @param {Boolean} Whether to show or hide the legend.
    *
    */
    toggle: function (show) {
        var me = this,
          i = 0,
          items = me.items,
          len = items.length;

        if (me.boxSprite) {
            if (show) {
                me.boxSprite.show(true);
            } else {
                me.boxSprite.hide(true);
            }
        }

        for (; i < len; ++i) {
            if (show) {
                items[i].show(true);
            } else {
                items[i].hide(true);
            }
        }

        me.visible = show;
    }

});

 
	
