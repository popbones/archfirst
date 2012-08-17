$(document).ready(function() {

    var AppRouter = Backbone.Router.extend({
        routes: {
            '': 'showHomePage',
            'home': 'showHomePage',
            'profile': 'showProfilePage'
        },

        initialize: function () {
            // Start with home view
            window.location.hash = '';
            return this;
        },

        showHomePage: function () {
            $('#home').show();
            $('#profile').hide();
        },

        showProfilePage: function () {
            $('#home').hide();
            $('#profile').show();
        }
    });

    var appRouter = new AppRouter();

    $('nav ul li a').on('click', function(event) {
        appRouter.navigate($(this).data('route'), {trigger: true});
    });

    Backbone.history.start({pushState: true, root: '/examples/backbone-router/'});
});