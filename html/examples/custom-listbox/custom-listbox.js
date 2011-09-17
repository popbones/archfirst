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
 * @author Naresh Bhatia
 */

var CustomListboxExample = window.CustomListboxExample || {};

CustomListboxExample.Run = function () {

    var fruits = ['Apple', 'Banana', 'Cherry', 'Date', 'Fig', 'Grape', 'Kiwi', 'Mango', 'Orange', 'Peach', 'Strawberry'];
    var veggies = [
        { value: 'Artichoke' },
        { value: 'Broccoli' },
        { value: 'Carrot' },
        { value: 'Garlic' },
        { value: 'Lettuce' },
        { value: 'Mushroom' },
        { value: 'Okra' },
        { value: 'Potato' },
        { value: 'Spinach' },
        { value: 'Tomato' },
        { value: 'Yam' }
    ];

    function displayItem(itemName) {
        $('#selected-item-display').text(itemName);
    }
    displayItem(fruits[0]);

    // ------------------------------------------------------------------------
    // jQuery ListBox
    // ------------------------------------------------------------------------
    $('#fruitList').archfirstListbox({
        data: fruits,
        onClickOfItem: displayItem
    });

    // ------------------------------------------------------------------------
    // Backbone.js ListBox
    // ------------------------------------------------------------------------
    var veggieListView = new BackboneArchfirstListbox.ItemListView({
        el: $("#veggieList"),
        templateString: "<a href='#'>{value}</a>",
        collection: new BackboneArchfirstListbox.ItemList(veggies),
        selectionCallback: displayItem
    });
}