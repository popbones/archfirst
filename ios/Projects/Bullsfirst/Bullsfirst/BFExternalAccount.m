//
//  BFExternalAccount.m
//  Bullsfirst
//
//  Created by Subramanian Ravi
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
