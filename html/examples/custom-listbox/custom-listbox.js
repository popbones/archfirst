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
        model: Item
    });

    // ItemView
    // --------
    var ItemView = Backbone.View.extend({

        tagName: "li",

        // TODO: Refers to hard-coded element in html - pass this in instead
        template: _.template($('#item-template').html()),

        initialize: function () {
            this.model.bind("change:selected", this.renderSelection, this);
        },

        // Render the contents of the item
        render: function () {
            $(this.el).html(this.template(this.model.toJSON()));
            this.renderSelection();
            return this;
        },

        renderSelection: function () {
            if (this.model.get("selected")) {
                $(this.el).addClass("active");
            }
            else {
                $(this.el).removeClass("active");
            }
        },

        // Toggle the "select" state of the item
        toggleSelected: function () {
            this.model.toggleSelected();
        }
    });

    // ItemListView
    // ------------
    var ItemListView = Backbone.View.extend({

        events: {
            "click": "changeSelection"
        },

        initialize: function () {
            // Create item views
            this.collection.each(this.addItemView, this);

            // Select the first one
            this.collection.at(0).toggleSelected();
        },

        addItemView: function (item) {
            var itemView = new ItemView({ model: item });
            this.el.append(itemView.render().el);
        },

        changeSelection: function (e) {
            // TODO: use some other strategy to detect target
            if ($(e.target).is('a')) {
                var currentlySelectedItem = this.findSelectedItem();
                var newlySelectedItem = this.findItemWithValue($(e.target).text);
                if (currentlySelectedItem == null) {
                    newlySelectedItem.toggleSelected();
                }
                else if (currentlySelectedItem != newlySelectedItem) {
                    currentlySelectedItem.toggleSelected();
                    newlySelectedItem.toggleSelected();
                }
            }
        },

        findSelectedItem: function () {
            return this.collection.find(function (item) {
                return (item.get("selected") != null);
            });
        },

        findItemWithValue: function (value) {
            return this.collection.find(function (item) {
                return (item.get("value") != value);
            });
        }
    });

    var veggieList = new ItemList(veggies);
    var veggieListView = new ItemListView({ el: $("#veggieList"), collection: veggieList });
}