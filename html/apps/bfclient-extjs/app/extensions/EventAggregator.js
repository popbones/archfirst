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
* app/extensions/EventAggregator
*
* @author Vikas Goyal
*/
Ext.define('EventAggregator', {
    singleton: true,
    mixins: {
        observable: 'Ext.util.Observable'
    },
    events: [
        'userloggedin',
        'userloginError',
        'useraccountcreated',
        'useraccountcreationError',
        'brokerageaccountcreated',
        'brokerageaccountcreationError',
        'externalaccountcreated',
        'externalaccountcreationError',
        'brokerageaccountedited',
        'brokerageaccounteditError',
        'brokerageaccountsstoreloaded',
        'brokerageaccountsstoreloadError',
        'instrumentsstoreloaded',
        'instrumentsstoreloadError',
        'ordercanceled',
        'ordercancellationError',
        'orderestimatecreated',
        'orderestimatecreationError',
        'ordercreated',
        'ordercreationError',
        'marketpricerecieved',
        'marketpricerecieveError',
        'transactionsstoreloaded',
        'transactionsstoreloadError',
        'externalaccountsstoreloaded',
        'externalaccountsstoreloadError',
        'transferprocessed',
        'transferprocessError',
        'tradeordercomplianceError',
        'ordersstoreloaded',
        'ordersstoreloadError'
    ],
    hasListeners: {},

    publish: function publish(eventName, eventArgs, customArgs) {
        EventAggregator.fireEvent(eventName, eventArgs, eventName, customArgs);
    },

    subscribeForever: function subscribeForever(eventName, eventHandler, scopeObject) {
        EventAggregator.addListener(eventName, eventHandler, scopeObject);
    },

    subscribe: function subscribe(eventName, eventHandler, scopeObject) {
        EventAggregator.addListener(eventName, eventHandler, scopeObject, {single: true});
    },

    unsubscribe: function unsubscribe(eventName, eventHandler, scopeObject) {
        EventAggregator.removeListener(eventName, eventHandler, scopeObject);
    }

});

 
	
