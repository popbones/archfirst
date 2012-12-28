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
    "use strict";

    AF.Grid.fakeDataSet4 = (function () {
        function getColumns() {
            return [
                {
                    label: "Title Name",
                    id: "colTitleName",
                    width: 150,
                    isGroupable: false
                },
                {
                    label: "Title Released",
                    id: "colTitleReleased",
                    width: 100
                },
                {
                    label: "Artist Name",
                    id: "colName",
                    width: 150
                },
                {
                    label: "Born",
                    id: "colBorn",
                    width: 100,
                    renderer: "SYSTEM_DATE"
                },
                {
                    label: "Died",
                    id: "colDied",
                    renderer: "SYSTEM_DATE",
                    width: 100
                },
                {
                    label: "Genre",
                    id: "colGenre",
                    width: 150
                }
            ];
        }

        var rows = (function () {
            return $.map([
                {"id": 1, "data": ["Billie Jean", "1983", "Michael Jackson", "1958-08-29", "2009-06-25", "Pop"]},
                {"id": 2, "data": ["Beat It", "1983", "Michael Jackson", "1958-08-29", "2009-06-25", "Pop"]},
                {"id": 3, "data": ["Thriller", "1984", "Michael Jackson", "1958-08-29", "2009-06-25", "Pop"]},
                {"id": 4, "data": ["Bad", "1987", "Michael Jackson", "1958-08-29", "2009-06-25", "Pop"]},
                {"id": 5, "data": ["I Just Can't Stop Loving You", "1987", "Michael Jackson", "1958-08-29", "2009-06-25", "Pop"]},
                {"id": 6, "data": ["Man in the Mirror", "1987", "Michael Jackson", "1958-08-29", "2009-06-25", "Pop"]},
                {"id": 7, "data": ["Black or White", "1991", "Michael Jackson", "1958-08-29", "2009-06-25", "Pop"]},
                {"id": 8, "data": ["Please Mister Postman", "1963", "John Lennon", "1940-10-09", "1980-12-08", "Rock"]},
                {"id": 9, "data": ["Ticket to Ride", "1965", "John Lennon", "1940-10-09", "1980-12-08", "Rock"]},
                {"id": 10, "data": ["Come Together", "1969", "John Lennon", "1940-10-09", "1980-12-08", "Rock"]},
                {"id": 11, "data": ["All My Loving", "1963", "Paul McCartney", "1942-06-18", "-", "Rock"]},
                {"id": 12, "data": ["Can't Buy Me Love", "1964", "Paul McCartney", "1942-06-18", "-", "Rock"]},
                {"id": 13, "data": ["Yesterday", "1965", "Paul McCartney", "1942-06-18", "-", "Rock"]},
                {"id": 14, "data": ["Ob-La-Di, Ob-La-Da", "1968", "Paul McCartney", "1942-06-18", "-", "Rock"]},
                {"id": 15, "data": ["Let It Be", "1970", "Paul McCartney", "1942-06-18", "-", "Rock"]},
                {"id": 16, "data": ["Get Back", "1970", "Paul McCartney", "1942-06-18", "-", "Rock"]},
                {"id": 17, "data": ["Superstition", "1972", "Stevie Wonder", "1950-05-13", "-", "Pop"]},
                {"id": 18, "data": ["Ebony and Ivory", "1982", "Stevie Wonder", "1950-05-13", "-", "Pop"]},
                {"id": 19, "data": ["I Just Called to Say I Love You", "1984", "Stevie Wonder", "1950-05-13", "-", "Pop"]},
                {"id": 20, "data": ["Love Me Tender", "1956", "Elvis Presley", "1935-01-08", "1977-08-16", "Rock and Roll"]},
                {"id": 21, "data": ["Heartbreak Hotel", "1956", "Elvis Presley", "1935-01-08", "1977-08-16", "Rock and Roll"]},
                {"id": 22, "data": ["All Shook Up", "1957", "Elvis Presley", "1935-01-08", "1977-08-16", "Rock and Roll"]},
                {"id": 23, "data": ["Are You Lonesome Tonight?", "1960", "Elvis Presley", "1935-01-08", "1977-08-16", "Rock and Roll"]},
                {"id": 24, "data": ["The Power of Love", "1993", "Celine Dion", "1968-03-30", "-", "Pop"]},
                {"id": 25, "data": ["Because You Loved Me", "1996", "Celine Dion", "1968-03-30", "-", "Pop"]},
                {"id": 26, "data": ["It's All Coming Back to Me Now", "1996", "Celine Dion", "1968-03-30", "-", "Pop"]},
                {"id": 27, "data": ["My Heart Will Go On", "1997", "Celine Dion", "1968-03-30", "-", "Pop"]},
                {"id": 28, "data": ["Rock n' Roll Madonna", "1970", "Elton John", "1947-03-25", "-", "Rock"]},
                {"id": 29, "data": ["Victim of Love", "1979", "Elton John", "1947-03-25", "-", "Rock"]},
                {"id": 30, "data": ["Like a Virgin", "1984", "Madonna", "1958-08-16", "-", "Pop"]},
                {"id": 31, "data": ["Papa Don't Preach", "1986", "Madonna", "1958-08-16", "-", "Pop"]},
                {"id": 32, "data": ["La Isla Bonita", "1986", "Madonna", "1958-08-16", "-", "Pop"]},
                {"id": 33, "data": ["Paint It Black", "1966", "Mick Jagger", "1943-07-26", "-", "Rock"]},
                {"id": 34, "data": ["(I Can't Get No) Satisfaction", "1965", "Mick Jagger", "1943-07-26", "-", "Rock"]},
                {"id": 35, "data": ["-", "-", "Barbra Streisand", "1942-04-24", "-", "Pop"]},
                {"id": 36, "data": ["-", "-", "Barbra Streisand", "1942-04-24", "-", "Pop"]},
                {"id": 37, "data": ["Born in the U.S.A.", "1984", "Bruce Springsteen", "1949-09-23", "-", "Rock"]},
                {"id": 38, "data": ["Dancing in the Dark", "1984", "Bruce Springsteen", "1949-09-23", "-", "Rock"]},
                {"id": 39, "data": ["We've Only Just Begun", "1970", "Karen Carpenter", "1950-03-02", "-", "Pop"]},
                {"id": 40, "data": ["Superstar", "1971", "Karen Carpenter", "1950-03-02", "-", "Pop"]},
                {"id": 41, "data": ["Rainy Days And Mondays", "1971", "Karen Carpenter", "1950-03-02", "-", "Pop"]},
                {"id": 42, "data": ["Top Of The World", "1973", "Karen Carpenter", "1950-03-02", "-", "Pop"]},
                {"id": 43, "data": ["-", "-", "Frank Sinatra", "1915-12-12", "1998-05-14", "Pop"]},
                {"id": 44, "data": ["-", "-", "Frank Sinatra", "1915-12-12", "1998-05-14", "Pop"]},
                {"id": 45, "data": ["Lady", "1980", "Kenny Rogers", "1938-08-21", "-", "Country"]},
                {"id": 46, "data": ["Islands in the Stream", "1983", "Kenny Rogers", "1938-08-21", "-", "Country"]},
                {"id": 47, "data": ["Endless Love", "1981", "Lionel Richie", "1949-06-20", "-", "Soul"]},
                {"id": 48, "data": ["All Night Long", "1983", "Lionel Richie", "1949-06-20", "-", "Soul"]},
                {"id": 49, "data": ["Hello", "1984", "Lionel Richie", "1949-06-20", "-", "Soul"]},
                {"id": 50, "data": ["Say You, Say Me", "1985", "Lionel Richie", "1949-06-20", "-", "Soul"]}
            ], function (item) {
                return {
                    id: item.id,
                    colTitleName: item.data[0],
                    colTitleReleased: item.data[1],
                    colName: item.data[2],
                    colBorn: item.data[3],
                    colDied: item.data[4],
                    colGenre: item.data[5]
                };
            });
        }());

        function getFilters() {
            return [
                {
                    id: "colBorn",
                    type: "DATE"
                },
                {
                    id: "colTitleName",
                    type: "FREE_TEXT"
                },
                {
                    id: "colName",
                    type: "FREE_TEXT"
                }
            ];
        }

        return {
            columns: getColumns(),
            filters: getFilters(),
            rows: rows
        };

    }());

}(jQuery));