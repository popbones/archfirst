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


    // ------------------------------------------------------------------------
    // jQuery ListBox
    // ------------------------------------------------------------------------
    $('#fruitList').archfirstListbox({
        data: fruits,
        onClickOfItem: displayItem
    });
    displayItem(fruits[0]);


    // ------------------------------------------------------------------------
    // Backbone.js ListBox
    // ------------------------------------------------------------------------
    // Item
    // ----
    var Item = Backbone.Model.extend({

        defaults: {
            value: "undefined",
            selected: false
        },

        // Toggle the selected state of this Item.
        toggleSelected: function () {
            this.set({ "selected": !this.get("selected") });
        }
    });

    // ItemList
    // --------
    var ItemList = Backbone.Collection.extend({
        model: Item,

        // Adds items to the list using the supplied values
        addItems: function (values) {
            for (var i = 0; i < values.length; i++) {
                this.add(new Item({ value: values[i] }));
            };
        }
    });

    // ItemView
    // --------
    var ItemView = Backbone.View.extend({
        tagName: "li",

        template: _.template($('#item-template').html()),

        events: {
            "click": "toggleSelect"
        },

        // Re-render the contents of the list item.
        render: function () {
            $(this.el).html(this.template(this.model.toJSON()));
            this.setContent();
            return this;
        },

        // Toggle the "select" state of the model.
        toggleSelect: function () {
            this.model.toggleSelect();
        }
    });

    // ItemListView
    // ------------
    var ItemListView = Backbone.View.extend({

        template: _.template($('#item-template').html()),

        events: {
            "click": "toggleSelect"
        },

        addItemViews: function (itemList) {
            itemList.each(this.addItemView);
        },

        addItemView: function (item) {
            var itemView = new ItemView
        }
    });

    var veggieList = new ItemList;
    veggieList.addItems(veggies);
    var veggieListView = new ItemListView({ el: $("#veggieList") });
}