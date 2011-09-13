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
* @fileoverview Shows multiple ways to build custom ListBoxes.
*
* @requires: ../../libs/archfirst/utility/string.supplant.js
* @requires: ../../libs/archfirst/jquery-archfirst-listbox/jquery.archfirst.listbox.js
*
* @author Naresh Bhatia
*/

var CustomListBoxExample = window.CustomListBoxExample || {}; ;

CustomListBoxExample.Run = function () {
    var fruits = ['Apple', 'Banana', 'Cherry', 'Date', 'Fig', 'Grape', 'Kiwi', 'Mango', 'Orange', 'Peach', 'Strawberry'];
    var veggies = ['Artichoke', 'Broccoli', 'Carrot', 'Garlic', 'Lettuce', 'Mushroom', 'Okra', 'Potato', 'Spinach', 'Tomato', 'Yam'];

    function displayItem(itemName) {
        $('#selected-item-display').text(itemName);
    }

    $('#fruitList').archfirstListbox({
        data: fruits,
        onClickOfItem: displayItem
    });
    displayItem(fruits[0]);
}