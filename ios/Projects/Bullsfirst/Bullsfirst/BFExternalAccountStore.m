//
//  BFExternalAccountStore.m
//  Bullsfirst
//
//  Created by suravi on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BFExternalAccountStore.h"
#import "AppDelegate.h"
#import "BFExternalAccount.h"


@implementation BFExternalAccountStore
static BFExternalAccountStore *defaultStore = nil;

#pragma mark - Singleton Methods

+ (BFExternalAccountStore *)defaultStore
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
    
     return self;
}

#pragma mark - Methods
- (void)accountsFromJSONData:(NSData *)data;
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.externalAccounts = [BFExternalAccount accountsFromJSONData:data];
}

- (NSArray *)allExternalAccounts
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.externalAccounts;
}

- (void)clearAccounts
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.externalAccounts removeAllObjects];
}

@end
