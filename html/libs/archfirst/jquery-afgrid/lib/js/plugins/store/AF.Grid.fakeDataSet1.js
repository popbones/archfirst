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
 * @author Manish Shanker
 */

(function ($) {

    AF.Grid.fakeDataSet1 = (function () {
        function getColumns() {
            return [{
                label: "Column 1",
                id: "colAN",
                width: 240,
                filterData: AF.Grid.FakeLocalStore.getFilterData(0, rows),
                groupBy: true
            }, {
                label: "Column 2",
                id: "colAS",
                width: 150,
                filterData: "",
                groupBy: true
            }, {
                label: "Column 3",
                id: "colAT",
                width: 150,
                groupBy: true,
                filterData: AF.Grid.FakeLocalStore.getFilterData(2, rows)
            }, {
                label: "Column 4",
                id: "colDate",
                width: 100,
                renderer: "DATE",
                filterData: "DATERANGE"
            }, {
                label: "Comment",
                id: "colComment",
                sortable: false,
                width: 100,
                renderer: "LABEL_BUTTON"
            }];
        }

        var rows = [{
            id: 1,
            data: ["Sample Data", "Sample Data 4", "Sample Data 5", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 2,
            data: ["Sample Data", "Sample Data 4", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 3,
            data: ["Sample Data 7", "True", "Value", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 4,
            data: ["Sample Data 3", "Large", "Small", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 5,
            data: ["Sample Data 3", "Large", "Small", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 6,
            data: ["Sample Data 3", "Large", "Small", "25-May-2011", "Last Name, First Name2"]
        }, {
            id: 7,
            data: ["Sample Data 2", "True", "False", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 8,
            data: ["Sample Data 2", "True", "False", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 9,
            data: ["Sample Data 2", "True", "False", "25-May-2011", "Last Name, First Name3"]
        }, {
            id: 10,
            data: ["Sample Data 2", "True", "False", "25-May-2011", "Last Name, First Name121"]
        }, {
            id: 11,
            data: ["Sample Data 2", "True", "False", "25-May-2011", "Last Name, First Name111"]
        }, {
            id: 12,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 13,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 14,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name21"]
        }, {
            id: 15,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name11"]
        }, {
            id: 16,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name221"]
        }, {
            id: 17,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name211"]
        }, {
            id: 18,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name321"]
        }, {
            id: 19,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name31"]
        }, {
            id: 20,
            data: ["Region", "Global", "US", "25-May-2011", "Last Name, First Name321"]
        }, {
            id: 21,
            data: ["Region", "Global", "UK", "25-May-2011", "Last Name, First Name3"]
        }, {
            id: 22,
            data: ["Region", "Global", "UK", "25-May-2011", "Last Name, First Name4"]
        }, {
            id: 23,
            data: ["Style", "Sector", "False", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 24,
            data: ["Style", "Sector", "Value", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 25,
            data: ["New Sample Data", "Sample Data 4", "Sample Data 5", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 26,
            data: ["New Sample Data", "Sample Data 4", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 27,
            data: ["New Sample Data 6", "True", "Value", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 28,
            data: ["New Sample Data 3", "Large", "Small", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 29,
            data: ["New 1 Sample Data", "Sample Data 4", "Sample Data 5", "25-May-2011", "Last Name, First Name"]
        }, {
            id: 30,
            data: ["New 1 Sample Data 1", "Sample Data 4 1", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 31,
            data: ["New 1 Sample Data 1", "Sample Data 4 2", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 32,
            data: ["New 1 Sample Data 1", "Sample Data 4 3", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 33,
            data: ["New 1 Sample Data 1", "Sample Data 4 4", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 34,
            data: ["New 1 Sample Data 2", "Sample Data 4 1", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 35,
            data: ["New 1 Sample Data 2", "Sample Data 4 2", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 36,
            data: ["New 1 Sample Data 2", "Sample Data 4 3", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 37,
            data: ["New 1 Sample Data 2", "Sample Data 4 4", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 38,
            data: ["New 1 Sample Data 3", "Sample Data 4 1", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 39,
            data: ["New 1 Sample Data 3", "Sample Data 4 2", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 40,
            data: ["New 1 Sample Data 3", "Sample Data 4 3", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 41,
            data: ["New 1 Sample Data 3", "Sample Data 4 4", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 42,
            data: ["New 1 Sample Data 4", "Sample Data 4 1", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 43,
            data: ["New 1 Sample Data 4", "Sample Data 4 2", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 44,
            data: ["New 1 Sample Data 4", "Sample Data 4 3", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 45,
            data: ["New 1 Sample Data 4", "Sample Data 4 4", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 46,
            data: ["New 1 Sample Data 5", "Sample Data 4 1", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 47,
            data: ["New 1 Sample Data 5", "Sample Data 4 2", "Sample Data 5", "25-May-2011", "Last Name, First Name1"]
        }, {
            id: 48,
            data: ["New 1 Does Rep", "True", "Value", "25-May-2011", "Last Name, First Name"]
        }];

        return {
            columns: getColumns(),
            rows: rows
        };

    }());

}(jQuery));