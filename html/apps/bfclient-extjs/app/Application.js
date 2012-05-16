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
* app/Application
*
* @author Vikas Goyal
*/

// Enable the component AutoLoader
Ext.Loader.setConfig({
    enabled: true
});
 
//Launch the application
Ext.application({
    //Configs
    name: 'Bullsfirst',
    appFolder: 'app',
    autoCreateViewport: true,
    controllers: [
        'Bullsfirst.controller.login.LoginController',
        'Bullsfirst.controller.trading.MainController',
        'Bullsfirst.controller.trading.AccountsController',
        'Bullsfirst.controller.trading.PositionsController',
        'Bullsfirst.controller.trading.TradeController',
        'Bullsfirst.controller.trading.OrdersController',
        'Bullsfirst.controller.trading.TransferController',
        'Bullsfirst.controller.trading.TransactionsController'
    ],
    launch: function () {
        //ServerErrorHandler subscribe to all type of errors
        ServerErrorHandler.SubscribeToAllErrors();
    }
});