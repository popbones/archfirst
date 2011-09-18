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

var BackboneListboxExample = window.BackboneListboxExample || {};

BackboneListboxExample.Run = function () {

    var fruits = [
        { value: 'Apple' },
        { value: 'Banana' },
        { value: 'Cherry' },
        { value: 'Date' },
        { value: 'Fig' },
        { value: 'Grape' },
        { value: 'Kiwi' },
        { value: 'Mango' },
        { value: 'Orange' },
        { value: 'Peach' },
        { value: 'Strawberry' }
    ];

    function displayItem(itemName) {
        $('#selected-item-display').text(itemName);
    }

    new BackboneArchfirst.Listbox({
        el: $("#fruitList"),
        templateString: "<a href='#'>{value}</a>",
        collection: fruits,
        selectionCallback: displayItem
    });
}