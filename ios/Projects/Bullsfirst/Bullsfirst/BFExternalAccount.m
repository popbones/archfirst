//
//  BFExternalAccount.m
//  Bullsfirst
//
//  Created by suravi on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BFExternalAccount.h"

@implementation BFExternalAccount
@synthesize externalAccountID,name,routingNumber,accountNumber;
+ (NSMutableArray *)accountsFromJSONData:(NSData *)data
{
    NSMutableArray *accounts = [[NSMutableArray alloc] init];
    
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    BFDebugLog(@"jsonObject = %@", jsonObject);
    
    if([jsonObject isEqual:[NSNull null]] || (jsonObject == nil))
    {
        return accounts;        
    }
    for(NSDictionary *theAccount in jsonObject)
    {
        BFExternalAccount *externalAccount = [BFExternalAccount accountFromDictionary:theAccount];
        [accounts addObject:externalAccount];
    }
    
    return accounts;
}

+ (BFExternalAccount *)accountFromDictionary:(NSDictionary *)theDictionary
{
    
    NSNumber *theExternalAccountID = [NSNumber numberWithInt:[[theDictionary valueForKey:@"id"] intValue]];        
    NSString *theName = [theDictionary valueForKey:@"name"];
    
      
    NSNumber *theRoutingNumber = [NSNumber numberWithInt:[[theDictionary valueForKey:@"routingNumber"] intValue]];
    NSNumber *theAccountNumber = [NSNumber numberWithInt:[[theDictionary valueForKey:@"accountNumber"] intValue]];
      
    BFExternalAccount *theAccount = [[BFExternalAccount alloc] initWithName:theName
                                                           externalAccountID:theExternalAccountID
                                                                 routingNumber:theRoutingNumber
                                                                  accountNumber:theAccountNumber];
    
    
    BFDebugLog(@"id = %@", theExternalAccountID);
    BFDebugLog(@"name = %@", theName);
   
    BFDebugLog(@"accountNumber  = %@", theAccountNumber);
    BFDebugLog(@"routingNumber  = %@", theRoutingNumber);
    return theAccount;
    
}

- (id)initWithName:(NSString *)theName
 externalAccountID:(NSNumber *)theExternalAccountID
     routingNumber:(NSNumber *)theRoutingNumber
     accountNumber:(NSNumber *)theAccountNumber
{    
    self = [super init];
    
    if(self)
    {
        self.name=theName;
        self.externalAccountID=theExternalAccountID;
        self.routingNumber=theRoutingNumber;
        self.accountNumber=theAccountNumber;
    }
    return self;    
}

- (id)init
{
    return [self initWithName:@"Name"
                externalAccountID:[NSNumber numberWithInt:0] 
                routingNumber:[NSNumber numberWithInt:0] 
                accountNumber:[NSNumber numberWithInt:0]
              ];
}


@end
