//
//  BFBrokerageSecurityStore.m
//  Bullsfirst2
//
//  Created by Rashmi Garg on 12/21/12.
//  For storyboard and Bullsfirst2 design
//  Copyright (c) 2012 Rashmi Garg. All rights reserved.
//

#import "BFBrokerageSecurityStore.h"
#import "BFBrokerageSecurity.h"
#import "AppDelegate.h"


static BFBrokerageSecurityStore *defaultStore = nil;
@implementation BFBrokerageSecurityStore

#pragma mark - Singleton Methods

+ (BFBrokerageSecurityStore *)defaultStore
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
        sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"InstrumentName" ascending:NO]];
    }
    return self;
}

#pragma mark - Methods
- (void)securitiesFromJSONData:(NSData *)data;
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.securities = [BFBrokerageSecurity securitiesFromJSONData:data];
}

- (NSArray *)allBrokerageSecurities
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.securities;
}

- (NSArray *)allBrokerageSecuritiesInSortedOrder
{
    NSArray* sortedBrokerageSymbols = [[[[BFBrokerageSecurityStore defaultStore] allBrokerageSecurities] sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    return sortedBrokerageSymbols;
}


- (void)clearSymbols
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.securities removeAllObjects];
}



@end





