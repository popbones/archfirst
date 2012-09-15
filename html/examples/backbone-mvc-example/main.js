function color2hex(color) {
    var hex = color.toString(16).toUpperCase();
    hex = "000000".substr(0, 6-hex.length) + hex;
    return hex;
}

var Tile = Backbone.Model.extend({
});

var TileRectView = Backbone.View.extend({
    initialize: function() {
        this.model.on('change', this.render, this);
    },

    render : function() {
        this.$el.css('background-color', '#' + color2hex(this.model.get('color')));
    }
});

var TileTextView = Backbone.View.extend({
    initialize: function() {
        this.model.on('change', this.render, this);
    },

    render : function() {
        this.$el.html(color2hex(this.model.get('color')));
    }
});

var tile = new Tile();

var tileRectView = new TileRectView({
    el: '#tile',
    model: tile
});

var tileTextView = new TileTextView({
    el: '#tileText',
    model: tile
});

function changeTileColor() {
    var r = $('#rSlider').slider('value');
    var g = $('#gSlider').slider('value');
    var b = $('#bSlider').slider('value');
    tile.set({color: (r << 16) + (g << 8) + b});
}

$(document).ready(function() {

    $('#rSlider, #gSlider, #bSlider').slider({
        range: 'min',
        max: 255,
        slide: changeTileColor,
        change: changeTileColor
    });

    // Initialize tile color to gold
    $('#rSlider').slider('value', 0xF8);
    $('#gSlider').slider('value', 0x9F);
    $('#bSlider').slider('value', 0x1B);
});