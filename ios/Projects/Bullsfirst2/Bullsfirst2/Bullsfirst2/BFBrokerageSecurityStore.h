//
//  BFBrokerageSecurityStore.h
//  Bullsfirst2
//
//  Created by Rashmi Garg on 12/21/12.
//  For storyboard and Bullsfirst2 design
//  Copyright (c) 2012 Rashmi Garg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BFBrokerageSecurity;

@interface BFBrokerageSecurityStore : NSObject {
    NSArray *sortDescriptors;
}

+ (BFBrokerageSecurityStore *)defaultStore;
- (void)securitiesFromJSONData:(NSData *)data;

- (NSArray *)allBrokerageSecurities;

- (NSArray *)allBrokerageSecuritiesInSortedOrder;


@end