/**
 * Copyright 2011-2013 Archfirst
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

    AF.Grid.fakeDataSet3 = (function () {

        function getColumns() {
            return [
                {
                    label: "Col 1",
                    id: "colAN",
                    width: 240
                },
                {
                    label: "Col 2",
                    id: "colAS",
                    width: 150
                },
                {
                    label: "Col 3",
                    id: "colAT",
                    width: 150
                },
                {
                    label: "Col 4",
                    id: "colDate",
                    width: 100
                },
                {
                    label: "Col 5",
                    id: "colComment",
                    width: 200
                }
            ];
        }

        var rows =
            (function () {
                return $.map(
                    [
                        {
                            id: 1,
                            data: ["Sample Data 1 2", "Broadly Marketed", "Sample Data 2", "25-May-2011", "Last Name, First Name"]
                        },
                        {
                            id: 2,
                            data: ["Sample Data 1 2", "Broadly Marketed", "Sample Data 2", "25-May-2011", "Last Name, First Name1"]
                        },
                        {
                            id: 3,
                            data: ["Sample Data 3 2", "True", "Value", "25-May-2011", "Last Name, First Name"]
                        },
                        {
                            id: 4,
                            data: ["Sample Data 4 2", "Large", "Small", "25-May-2011", "Last Name, First Name"]
                        },
                        {
                            id: 5,
                            data: ["Sample Data 4 2", "Large", "Small", "25-May-2011", "Last Name, First Name1"]
                        },
                        {
                            id: 6,
                            data: ["Sample Data 4 2", "Large", "Small", "25-May-2011", "Last Name, First Name2"]
                        },
                        {
                            id: 7,
                            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name"]
                        },
                        {
                            id: 8,
                            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name1"]
                        },
                        {
                            id: 9,
                            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name3"]
                        },
                        {
                            id: 10,
                            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name121"]
                        },
                        {
                            id: 11,
                            data: ["Sample Data 5 2", "True", "False", "25-May-2011", "Last Name, First Name111"]
                        },
                        {
                            id: 12,
                            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name"]
                        },
                        {
                            id: 13,
                            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name1"]
                        },
                        {
                            id: 14,
                            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name21"]
                        },
                        {
                            id: 15,
                            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name11"]
                        },
                        {
                            id: 16,
                            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name221"]
                        },
                        {
                            id: 17,
                            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name211"]
                        },
                        {
                            id: 18,
                            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name321"]
                        },
                        {
                            id: 19,
                            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name31"]
                        },
                        {
                            id: 20,
                            data: ["Region 2", "Global", "US", "25-May-2011", "Last Name, First Name321"]
                        },
                        {
                            id: 21,
                            data: ["Region 2", "Global", "UK", "25-May-2011", "Last Name, First Name3"]
                        },
                        {
                            id: 22,
                            data: ["Region 2", "Global", "UK", "25-May-2011", "Last Name, First Name4"]
                        },
                        {
                            id: 23,
                            data: ["Style 2", "Sector", "False", "25-May-2011", "Last Name, First Name"]
                        },
                        {
                            id: 24,
                            data: ["Style 2", "Sector", "Value", "25-May-2011", "Last Name, First Name1"]
                        },
                        {
                            id: 25,
                            data: ["New Sample Data 1 2", "Broadly Marketed", "Sample Data 2", "25-May-2011", "Last Name, First Name"]
                        },
                        {
                            id: 26,
                            data: ["New Sample Data 1 2", "Broadly Marketed", "Sample Data 2", "25-May-2011", "Last Name, First Name1"]
                        },
                        {
                            id: 27,
                            data: ["New Sample Data 3 2", "True", "Value", "25-May-2011", "Last Name, First Name"]
                        },
                        {
                            id: 28,
                            data: ["New Sample Data 4 2", "Large", "Small", "25-May-2011", "Last Name, First Name"]
                        }
                    ],
                    function (item) {
                        return {
                            id: item.id,
                            colAN: item.data[0],
                            colAS: item.data[1],
                            colAT: item.data[2],
                            colDate: item.data[3],
                            colComment: item.data[4]

                        };
                    }
                );
            }());

        function getFilters() {
            return [
                {
                    id: "colAN",
                    type: "FREE_TEXT"
                },
                {
                    id: "colAS",
                    type: "FREE_TEXT"
                },
                {
                    id: "colAT",
                    type: "FREE_TEXT"
                },
                {
                    id: "colComment",
                    type: "FREE_TEXT"
                }
            ];
        }

        return {
            columns: getColumns(),
            rows: rows,
            filters: getFilters()
        };

    }());

}(jQuery));