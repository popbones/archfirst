//
//  BFExternalAccount.h
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
