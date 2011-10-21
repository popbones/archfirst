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

var Bullsfirst = window.Bullsfirst || {};

Bullsfirst.ready = function () {

    /* Properties
     * ---------------------------------------------------------------------- */
    var username, password, user;


    /* Events
     * ---------------------------------------------------------------------- */
    $('#loginForm').submit(function () {
        username = $('#loginForm #username').val();
        password = $('#loginForm #password').val();
        login();
        return false;
    });

    $('#statusbar_cancel_button').click(function () {
        hideStatusBar();
    });


    /* Login
     * ---------------------------------------------------------------------- */

    /**
     * Logs in to the server using saved credentials. If login is successful,
     * saves the returned user information in the user object.
     */
    function login() {
        $.ajax({
            url: '/bfoms-javaee/rest/secure/users/' + username,
            beforeSend: setAuthorizationHeader,
            success: function (data, textStatus, jqXHR) {
                user = data;
                showStatusMessage('info', 'Welcome ' + user.firstName + ' ' + user.lastName + '!');
            },
            error: function (jqXHR, textStatus, errorThrown) {
                showStatusMessage('error', errorThrown);
            }
        });
    }


    /* Authoriztion Header
     * ---------------------------------------------------------------------- */

    /**
     * Sets an Authorization header in the request. We force this header in every
     * request to avoid being challenged by the server for credentials (the server
     * sends a 401 Unauthorized error along with a WWW-Authenticate header to do this).
     * Specifically, we don't rely on username/password settings in the jQuery.ajax()
     * call since they cause an unnecessary roundtrip to the server resulting in a 401
     * before sending the Authorization header.
     */
    function setAuthorizationHeader(xhr) {
        xhr.setRequestHeader(
            'Authorization',
            'Basic ' + base64_encode(username + ':' + password));
    }


    /* Statusbar
     * ---------------------------------------------------------------------- */
    var messageColors = {
        debug: 'black',
        info: 'green',
        warn: 'brown',
        error: 'red'
    }

    function showStatusMessage(category, message) {
        $('#statusbar_message').html('[' + category + '] ' + message);
        $('#statusbar_message').css('color', messageColors[category]);
        $('#statusbar').fadeIn('fast');
    }

    function hideStatusBar() {
        $('#statusbar').fadeOut('fast');
    }
}