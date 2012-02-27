//
//  BFExternalAccount.h
//  Bullsfirst
//
//  Created by suravi on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFExternalAccount : NSObject
{
    NSNumber *externalAccountID; // long
    NSString *name;
    NSNumber *routingNumber;// long long
    NSNumber *accountNumber;// long long
}


@property (nonatomic, retain) NSNumber *externalAccountID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *routingNumber;
@property (nonatomic, retain) NSNumber *accountNumber;


+ (BFExternalAccount *)accountFromDictionary:(NSDictionary *)theDictionary;
+ (NSMutableArray *)accountsFromJSONData:(NSData *)data;

- (id)initWithName:(NSString *)theName
externalAccountID:(NSNumber *)theExternalAccountID
      routingNumber:(NSNumber *)theRoutingNumber
     accountNumber:(NSNumber *)theAccountNumber;
    
@end
