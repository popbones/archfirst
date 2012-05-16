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
* app/GlobalConstants
*
* @author Vikas Goyal
*/
Ext.define('Bullsfirst.GlobalConstants', {
    singleton: true,
    
    BaseUrl: 'http://archfirst.org',
    Login: 'Login',
    Edit: 'Edit',
    GettingStarted: 'Getting Started',
    SignOut: 'Sign Out',
    PleaseLogin: 'Please Login',
    OpenAccount: 'Open an Account',
    OpenAccountButton: 'Open Account',
    Update: 'Update',
    AddAccount: 'Add Account',
    PreviewOrder: 'Preview Order',
    Transfer: 'Transfer',
    Cancel: 'Cancel',
    CreateBrokerageAccount: 'Create New Account',
    EditBrokerageAccount: 'Edit Account',
    CreateExternalAccount: 'Add External Account',
    PreviewOrder: 'Preview Order',
    AddExternalAccount: 'Add an external account...',
    Transfer: 'Transfer',
    BrokeageAccountDefaultName: 'Brokerage Account 1',
    ExternalAccountDefaultName: 'External Account 1',
    ExternalAccountDefaultRoutingNumber: 22056782,
    ExternalAccountDefaultAccountNumber: 12345678,
    DefaultTransferAmount: 100000,
    InvalidDateMsg: "'To' date cannot be before 'From' date",
    AccountCreated: 'Congratulations!',
    AccountReloginMsg: 'Account Created! Please login using your new account',
    TradeMessage: "We love to trade, and we hope you do too. Now you can do it with the latest trading platform from Bullsfirst.  We guarantee  a  0-second trade execution, and will give you a free popsicle if your trade doesn't go through in this time period. On a side note, we just bought a big freezer and 10,000 popsicles. Thankfully, we've hedged all popsicle expenses for the next two years! (Commodity experts say popsicles are on the rise).",
    CopyrightMessage: "This is a demo application. All data displayed is fictitious. Copyright @ 2010-2012 <a href='http://archfirst.org/' target='new'>Archfirst</a>",

    //Mask messages
    LoadingMessage: 'Please wait, Loading...',
    LoggingInMaskMessage: 'Please wait, Logging in...',
    CreatingUserMaskMessage: 'Please wait, Creating user...',

    //Errors:
    ErrorTitle: 'Error!',
    GeneralError: 'The following error occurred while processing your request:</br>{0}',
    InvalidForm: 'The form has errors. Please correct and try again',
    UnknownError: 'An unknown error occurred while processing your request',
    StoreLoadError: 'An error occurred while loading {0}',
    UserLoginError: 'An error occurred while trying to login </br> {0}',
    CreateResourceError: 'An error occurred while trying to create a {0} </br> {1}',
    EditResourceError: 'An error occurred while trying to edit the {0} </br> {1}',
    CancelResourceError: 'An error occurred while trying to cancel the {0} </br> {1}',
    RetrievedResourceError: 'An error occurred while trying to retrieve the {0} </br> {1}'
});