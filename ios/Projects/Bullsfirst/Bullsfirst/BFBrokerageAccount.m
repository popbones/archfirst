//
//  BFBrokerageAccount.m
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

#import "BFBrokerageAccount.h"
#import "BFMoney.h"
#import "BFPosition.h"
#import "BFBrokerageAccountStore.h"

@implementation BFBrokerageAccount

@synthesize brokerageAccountID;
@synthesize name;
@synthesize cashPosition; //
@synthesize marketValue; //
@synthesize editPermission; //
@synthesize tradePermission; //
@synthesize transferPermission; // 
@synthesize positions;

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
        BFBrokerageAccount *brokerageAccount = [BFBrokerageAccount accountFromDictionary:theAccount];
        [accounts addObject:brokerageAccount];
    }
    
    return accounts;
}

+ (BFBrokerageAccount *)accountFromDictionary:(NSDictionary *)theDictionary
{
    
    NSNumber *theBrokerageAccountID = [NSNumber numberWithInt:[[theDictionary valueForKey:@"id"] intValue]];        
    NSString *theName = [theDictionary valueForKey:@"name"];
    
    NSDictionary *cpDic = [theDictionary objectForKey:@"cashPosition"];
    BFMoney *theCashPosition = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[cpDic valueForKey:@"amount"] floatValue]] currency:[cpDic valueForKey:@"currency"]];

    NSDictionary *mvDic = [theDictionary objectForKey:@"marketValue"];
    BFMoney *theMarketValue = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[mvDic valueForKey:@"amount"] floatValue]] currency:[mvDic valueForKey:@"currency"]];
    
    NSNumber *theEditPermission = [NSNumber numberWithInt:[[theDictionary valueForKey:@"editPermission"] intValue]];
    NSNumber *theTradePermission = [NSNumber numberWithInt:[[theDictionary valueForKey:@"tradePermission"] intValue]];
    NSNumber *theTransferPermission = [NSNumber numberWithInt:[[theDictionary valueForKey:@"transferPermission"] intValue]];    
    
    NSArray *positionsArrayTemp = [theDictionary objectForKey:@"positions"];    
    NSMutableArray *positionsArray = [[NSMutableArray alloc] init];    
    for(NSDictionary *thePosition in positionsArrayTemp)
    {
        [positionsArray addObject:[BFPosition positionFromDictionary:thePosition]];
    }

    BFBrokerageAccount *theAccount = [[BFBrokerageAccount alloc] initWithName:theName
                                                           brokerageAccountID:theBrokerageAccountID
                                                                 cashPosition:theCashPosition
                                                                  marketValue:theMarketValue
                                                               editPermission:theEditPermission
                                                              tradePermission:theTradePermission
                                                           transferPermission:theTransferPermission
                                                                    positions:positionsArray];
    
    
    BFDebugLog(@"id = %@", theBrokerageAccountID);
    BFDebugLog(@"name = %@", theName);
    BFDebugLog(@"cp = %@", cpDic);
    BFDebugLog(@"mv = %@", mvDic);
    BFDebugLog(@"editPermission  = %@", theEditPermission);
    BFDebugLog(@"tradePermission  = %@", theTradePermission);
    BFDebugLog(@"transferPermission  = %@", theTransferPermission);
    
    return theAccount;
    
}

- (id)initWithName:(NSString *)theName
brokerageAccountID:(NSNumber *)theBrokerageAccountID
      cashPosition:(BFMoney *)theCashPosition
       marketValue:(BFMoney *)theMarketValue
    editPermission:(NSNumber *)theEditPermission
   tradePermission:(NSNumber *)theTradePermission
transferPermission:(NSNumber *)theTransferPermission
         positions:(NSArray *)thePositions
{    
    self = [super init];
    
    if(self)
    {
        [self setName:theName];
        [self setBrokerageAccountID:theBrokerageAccountID];
        [self setCashPosition:theCashPosition];
        [self setMarketValue:theMarketValue];
        [self setEditPermission:theEditPermission];
        [self setTradePermission:theTradePermission];
        [self setTransferPermission:theTransferPermission];
        [self setPositions:thePositions];
    }
    
    return self;    
}

- (id)init
{
    return [self initWithName:@"Name"
           brokerageAccountID:[NSNumber numberWithInt:0]            
                 cashPosition:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                  marketValue:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
               editPermission:[NSNumber numberWithInt:0]
              tradePermission:[NSNumber numberWithInt:0]
           transferPermission:[NSNumber numberWithInt:0]
                    positions:[NSArray array]];
}

@end
