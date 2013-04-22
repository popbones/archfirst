//
//  BFBrokerageAccount.h
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

#import <Foundation/Foundation.h>
#import "BFConstants.h"

@class BFMoney;

@interface BFBrokerageAccount : NSObject
{
    NSNumber *brokerageAccountID; // long
    NSString *name;
    BFMoney *cashPosition;
    BFMoney *marketValue;
    NSNumber *editPermission; // boolean
    NSNumber *tradePermission; // boolean
    NSNumber *transferPermission; // boolean 
    NSArray *positions;
}

@property (nonatomic, retain) NSNumber *brokerageAccountID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) BFMoney *cashPosition;
@property (nonatomic, retain) BFMoney *marketValue;
@property (nonatomic, retain) NSNumber *editPermission;
@property (nonatomic, retain) NSNumber *tradePermission;
@property (nonatomic, retain) NSNumber *transferPermission; 
@property (nonatomic, retain) NSArray *positions;

+ (BFBrokerageAccount *)accountFromDictionary:(NSDictionary *)theDictionary;
+ (NSMutableArray *)accountsFromJSONData:(NSData *)data;

- (id)initWithName:(NSString *)theName
brokerageAccountID:(NSNumber *)theBrokerageAccountID
      cashPosition:(BFMoney *)theCashPosition
       marketValue:(BFMoney *)theMarketValue
    editPermission:(NSNumber *)theEditPermission
   tradePermission:(NSNumber *)theTradePermission
transferPermission:(NSNumber *)theTransferPermission
         positions:(NSArray *)thePositions;



@end
