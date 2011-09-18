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
 * @fileoverview A subset of <select> tag that can be styled very easily.
 * It uses <ul> and <li> tags to create a list.
 *
 * @requires: ../utility/string.supplant.js
 *
 * @author Naresh Bhatia
 */

BackboneArchfirst = window.BackboneArchfirst || {};

BackboneArchfirst.Listbox = function (options) {

    // Item
    // ----
    var Item = Backbone.Model.extend({

        defaults: {
            value: "undefined",
            selected: false
        },

        // Select this item
        select: function () {
            this.set({ "selected": true });
        },

        // Deselect this item
        deselect: function () {
            this.set({ "selected": false });
        }
    });


    // ItemList
    // --------
    var ItemList = Backbone.Collection.extend({

        model: Item,

        findSelectedItem: function () {
            return this.find(function (item) {
                return (item.get("selected") == true);
            });
        },

        changeSelection: function (newlySelectedItem) {
            var currentlySelectedItem = this.findSelectedItem();
            if (currentlySelectedItem == null) {
                newlySelectedItem.select();
            }
            else if (currentlySelectedItem != newlySelectedItem) {
                currentlySelectedItem.deselect();
                newlySelectedItem.select();
            }
        }
    });


    // ItemView
    // --------
    var ItemView = Backbone.View.extend({

        tagName: "li",

        events: {
            "click": "changeSelection"
        },

        initialize: function () {
            this.model.bind("change:selected", this.renderSelection, this);
        },

        // Render the contents of the item
        render: function () {
            $(this.el).html(this.options.templateString.supplant(this.model.toJSON()));
            this.renderSelection();
            return this;
        },

        renderSelection: function () {
            var selected = this.model.get("selected");
            $(this.el)[selected ? "addClass" : "removeClass"]("active");

            // Call the selection callback supplied by user
            if (selected) {
                this.options.selectionCallback(this.model.get("value"));
            }
        },

        changeSelection: function () {
            this.model.collection.changeSelection(this.model);
        }
    });


    // ItemListView
    // ------------
    var ItemListView = Backbone.View.extend({

        initialize: function () {
            // Create item views
            this.collection.each(this.addItemView, this);

            // Select the first one
            this.collection.at(0).select();
        },

        addItemView: function (item) {
            var itemView = new ItemView({
                model: item,
                templateString: this.options.templateString,
                selectionCallback: this.options.selectionCallback
            });
            this.el.append(itemView.render().el);
        }
    });


    // Replace the raw array of data with an ItemList collection
    options.collection = new ItemList(options.collection);

    // Return a new instance of ItemListView that runs the listbox
    return new ItemListView(options);
}