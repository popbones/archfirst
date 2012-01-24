//
//  BFPosition.h
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

@class BFMoney;

@interface BFPosition : NSObject
{
    NSNumber *accountID; // long
    NSString *accountName;
    NSString *instrumentSymbol;
    NSString *instrumentName;
    NSNumber *lotID; // long
    NSDate *lotCreationTime;
    NSNumber *quantity; // double
    BFMoney *lastTrade;
    BFMoney *marketValue;
    BFMoney *pricePaid;
    BFMoney *totalCost;
    BFMoney *gain;
    NSNumber *gainPercent; // float    
    NSArray *children;
}

@property (nonatomic, retain) NSNumber *accountID;
@property (nonatomic, retain) NSString *accountName;
@property (nonatomic, retain) NSString *instrumentSymbol;
@property (nonatomic, retain) NSString *instrumentName;
@property (nonatomic, retain) NSNumber *lotID;
@property (nonatomic, retain) NSDate *lotCreationTime;
@property (nonatomic, retain) NSNumber *quantity;
@property (nonatomic, retain) BFMoney *lastTrade;
@property (nonatomic, retain) BFMoney *marketValue;
@property (nonatomic, retain) BFMoney *pricePaid;
@property (nonatomic, retain) BFMoney *totalCost;
@property (nonatomic, retain) BFMoney *gain;
@property (nonatomic, retain) NSNumber *gainPercent;    
@property (nonatomic, retain) NSArray *children;

+ (BFPosition *)positionFromDictionary:(NSDictionary *)theDictionary;

/*
+ (BFPosition *)positionWithAccountName:(NSString *)theAccountName
                              accountID:(NSNumber *)theAccountID
                       instrumentSymbol:(NSString *)theInstrumentSymbol
                         instrumentName:(NSString *)theInstrumentName
                                  lotID:(NSNumber *)theLotID
                        lotCreationTime:(NSDate *)theLotCreationTime
                               quantity:(NSNumber *)theQuantity
                              lastTrade:(BFMoney *)theLastTrade
                            marketValue:(BFMoney *)theMarketValue
                              pricePaid:(BFMoney *)thePricePaid
                              totalCost:(BFMoney *)theTotalCost
                                   gain:(BFMoney *)theGain
                            gainPercent:(NSNumber *)theGainPercent
                               children:(NSArray *)theChildren;
*/

- (id)initWithAccountName:(NSString *)theAccountName
                accountID:(NSNumber *)theAccountID
         instrumentSymbol:(NSString *)theInstrumentSymbol
           instrumentName:(NSString *)theInstrumentName
                    lotID:(NSNumber *)theLotID
          lotCreationTime:(NSDate *)theLotCreationTime
                 quantity:(NSNumber *)theQuantity
                lastTrade:(BFMoney *)theLastTrade
              marketValue:(BFMoney *)theMarketValue
                pricePaid:(BFMoney *)thePricePaid
                totalCost:(BFMoney *)theTotalCost
                     gain:(BFMoney *)theGain
              gainPercent:(NSNumber *)theGainPercent
                 children:(NSArray *)theChildren;

@end
