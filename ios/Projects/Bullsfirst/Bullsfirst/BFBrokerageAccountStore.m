//
//  BFBrokerageAccountStore.m
//  Bullsfirst
//
//  Created by Joe Howard
//  Copyright 2012 Archfirst
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "BFBrokerageAccountStore.h"
#import "BFBrokerageAccount.h"
#import "AppDelegate.h"

static BFBrokerageAccountStore *defaultStore = nil;

@implementation BFBrokerageAccountStore

#pragma mark - Singleton Methods

+ (BFBrokerageAccountStore *)defaultStore
{
    @synchronized(self)
    {
        if (defaultStore == nil) 
            defaultStore = [[self alloc] init];
    }
    return defaultStore;
}

- (id)init
{
    if(defaultStore) 
        return defaultStore;
    
    self = [super init];
    
    if(self)
    {
    }
    return self;
}

#pragma mark - Methods
- (void)accountsFromJSONData:(NSData *)data;
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.accounts = [BFBrokerageAccount accountsFromJSONData:data];
}

- (NSArray *)allBrokerageAccounts
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.accounts;
}

- (void)addBrokerageAccount:(BFBrokerageAccount *)theBrokerageAccount
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.accounts addObject:theBrokerageAccount];
}

- (void)clearAccounts
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.accounts removeAllObjects];
}

@end
