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
* app/store/BrokerageAccountChartSummaries
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.store.BrokerageAccountChartSummaries', {
    extend: 'Bullsfirst.store.AbstractStore',
    alias: 'brokerageaccountchartstore',

    bottomRecords: null,

    sorters: [
        {
            property: 'marketValue',
            direction: 'DESC'
        }
    ],

    add: function (records) {
        var maxRecords = Bullsfirst.GlobalConstants.PieMaxRecords;
        this.callParent(records);
        var sortedRecords = this.getRange();
        //if there are more than maxRecords, save others in bottomRecords and remove them from the store
        if (sortedRecords.length > maxRecords) {
            var topRecords = sortedRecords.slice(0, maxRecords);
            var bottomRecods = sortedRecords.slice(maxRecords - 1);
            this.bottomRecords = new Ext.util.AbstractMixedCollection();
            this.bottomRecords.addAll(bottomRecods);

            //Calculate total market value of the "Other" record
            var otherRecord = new Bullsfirst.model.BrokerageAccountSummary();
            var otherRecordMarketValue = this.bottomRecords.sum('marketValue', 'data');
            otherRecord.set('name', Bullsfirst.GlobalConstants.PieOtherRecordName);
            otherRecord.set('marketValue', { amount: otherRecordMarketValue });
            
            this.remove(bottomRecods);
            this.insert(maxRecords - 1, [otherRecord]);
            return topRecords;
        }
        return sortedRecords;
    }

});

 
	
