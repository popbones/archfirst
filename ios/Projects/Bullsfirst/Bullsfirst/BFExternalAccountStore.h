//
//  BFExternalAccountStore.h
//  Bullsfirst
//
//  Created by suravi on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BFExternalAccount;
@interface BFExternalAccountStore : NSObject
+ (BFExternalAccountStore *)defaultStore;
- (void)accountsFromJSONData:(NSData *)data;

- (NSArray *)allExternalAccounts;
@end
