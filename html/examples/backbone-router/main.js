$(document).ready(function() {

    var AppRouter = Backbone.Router.extend({
        routes: {
            '': 'showHomePage',
            'home': 'showHomePage',
            'profile': 'showProfilePage'
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

    Backbone.history.start({root: '/examples/backbone-router/'});
});