﻿/**
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

var BackboneArchfirstListbox = window.BackboneArchfirstListbox || {};

// Item
// ----
BackboneArchfirstListbox.Item = Backbone.Model.extend({

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
BackboneArchfirstListbox.ItemList = Backbone.Collection.extend({
    model: BackboneArchfirstListbox.Item,

    findSelectedItem: function () {
        return this.find(function (item) {
            return (item.get("selected") == true);
        });
    },

    findItemWithValue: function (value) {
        return this.find(function (item) {
            return (item.get("value") == value);
        });
    }
});

// ItemView
// --------
BackboneArchfirstListbox.ItemView = Backbone.View.extend({

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
        if (this.model.get("selected")) {
            $(this.el).addClass("active");
        }
        else {
            $(this.el).removeClass("active");
        }
    },

    changeSelection: function () {
        var currentlySelectedItem = this.model.collection.findSelectedItem();
        var newlySelectedItem = this.model;
        if (currentlySelectedItem == null) {
            newlySelectedItem.toggleSelected();
        }
        else if (currentlySelectedItem != newlySelectedItem) {
            currentlySelectedItem.toggleSelected();
            newlySelectedItem.toggleSelected();
        }
        // Call the selection callback supplied by user
        this.options.selectionCallback(newlySelectedItem.get("value"));
    }
});

// ItemListView
// ------------
BackboneArchfirstListbox.ItemListView = Backbone.View.extend({

    initialize: function () {
        // Create item views
        this.collection.each(this.addItemView, this);

        // Select the first one
        this.collection.at(0).toggleSelected();
    },

    addItemView: function (item) {
        var itemView = new BackboneArchfirstListbox.ItemView({
            model: item,
            templateString: this.options.templateString,
            selectionCallback: this.options.selectionCallback
        });
        this.el.append(itemView.render().el);
    }
});