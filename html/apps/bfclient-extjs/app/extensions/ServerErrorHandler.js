/**
* Copyright 2012 Archfirst
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
* app/extensions/ServerErrorHandler
*
* @author Vikas Goyal
*/
Ext.define('ServerErrorHandler', {
    singleton: true,

    SubscribeToAllErrors: function () {
        var allServerEvents = EventAggregator.events;
        for (var i = 0; i < allServerEvents.length; i++) {
            if (allServerEvents[i].search('Error') == allServerEvents[i].length - 5) {
                EventAggregator.subscribeForever(allServerEvents[i], ServerErrorHandler.handleError);
            }
        }
    },

    handleError: function (args, eventName) {
        if (args == null) {
            ServerErrorHandler.showErrorMessage(Bullsfirst.GlobalConstants.UnknownError);
            return;
        }

        //Store load errors
        if (eventName.search('store') >= 0) {
            ServerErrorHandler.showErrorMessage(Ext.String.format(Bullsfirst.GlobalConstants.StoreLoadError, eventName.slice(0, eventName.lastIndexOf('store'))));
            return;
        }

        //Error returning action objects
        if (args.$className.search('.action.') >= 0) {
            switch (eventName) {
                case 'userloginError':
                    ServerErrorHandler.showErrorMessage(Ext.String.format(Bullsfirst.GlobalConstants.UserLoginError, args.response.statusText));
                    break;
                default:
                    break;

            }
            return;
        }

        //Error returning operation objects
        if (args.$className.search('.Operation') >= 0) {
            var errorMessage = '';
            if (!Ext.isEmpty(args.customError)) {
                errorMessage = args.customError;
            }
            else {
                if (args.response != null && !Ext.isEmpty(args.response.responseText)) {
                    try {
                        var errorDetail = JSON.parse(args.response.responseText);
                        if (!Ext.isEmpty(errorDetail) && !Ext.isEmpty(errorDetail.detail)) {
                            errorMessage = errorDetail.detail
                        }
                    } catch (e) {

                    }

                }
            }
            
            if (errorMessage == '') {
                var operationError = args.getError();
                if (operationError != null && !Ext.isEmpty(operationError.statusText)) {
                    errorMessage = operationError.statusText;
                }
            }

            if (!Ext.isEmpty(errorMessage)) {
                ServerErrorHandler.showErrorMessage(Ext.String.format(Bullsfirst.GlobalConstants.GeneralError, errorMessage));
            }
            else {
                ServerErrorHandler.showErrorMessage(Bullsfirst.GlobalConstants.UnknownError);
            }
            return;
        }

    },

    showErrorMessage: function (msg) {
        Ext.Msg.alert(Bullsfirst.GlobalConstants.ErrorTitle, msg);
    }
});

 
	
