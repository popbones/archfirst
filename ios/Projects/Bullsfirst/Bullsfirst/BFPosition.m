//
//  BFPosition.m
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

#import "BFPosition.h"
#import "BFMoney.h"

@implementation BFPosition

@synthesize accountID;
@synthesize accountName;
@synthesize instrumentSymbol;
@synthesize instrumentName;
@synthesize lotID;
@synthesize lotCreationTime;
@synthesize quantity;
@synthesize lastTrade;
@synthesize marketValue;
@synthesize pricePaid;
@synthesize totalCost;
@synthesize gain;
@synthesize gainPercent;
@synthesize children;

+ (BFPosition *)positionFromDictionary:(NSDictionary *)theDictionary
{
    NSNumber *theAccountID = [NSNumber numberWithInt:[[theDictionary valueForKey:@"accountId"] intValue]];        
    NSString *theAccountName = [theDictionary valueForKey:@"accountName"];
    
    NSDictionary *lastTradeDic = [theDictionary objectForKey:@"lastTrade"];
    BFMoney *theLastTrade = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[lastTradeDic valueForKey:@"amount"] floatValue]] currency:[lastTradeDic valueForKey:@"currency"]];
    
    NSDictionary *mvDic = [theDictionary objectForKey:@"marketValue"];
    BFMoney *theMarketValue = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[mvDic valueForKey:@"amount"] floatValue]] currency:[mvDic valueForKey:@"currency"]];

    NSDictionary *pricePaidDic = [theDictionary objectForKey:@"pricePaid"];
    BFMoney *thePricePaid = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[pricePaidDic valueForKey:@"amount"] floatValue]] currency:[pricePaidDic valueForKey:@"currency"]];

    NSDictionary *totalCostDic = [theDictionary objectForKey:@"totalCost"];
    BFMoney *theTotalCost = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[totalCostDic valueForKey:@"amount"] floatValue]] currency:[totalCostDic valueForKey:@"currency"]];

    NSDictionary *gainDic = [theDictionary objectForKey:@"gain"];
    BFMoney *theGain = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[gainDic valueForKey:@"amount"] floatValue]] currency:[gainDic valueForKey:@"currency"]];
    
    NSString *theInstrumentSymbol = [theDictionary valueForKey:@"instrumentSymbol"];
    NSString *theInstrumentName = [theDictionary valueForKey:@"instrumentName"];
    
    NSNumber *theQuantity = [NSNumber numberWithFloat:[[theDictionary valueForKey:@"quantity"] floatValue]];
    NSNumber *theGainPercent = [NSNumber numberWithFloat:[[theDictionary valueForKey:@"gainPercent"] floatValue]];

    NSNumber *theLotID = [NSNumber numberWithInt:[[theDictionary valueForKey:@"lotId"] intValue]];   
    
    // TODO: Fix reading in the lotCreationTime, for now just getting null
    NSString *dateStrTemp = [theDictionary objectForKey:@"lotCreationTime"];
    // removed the last : in the time zone
    NSRange zoneRange = {23, 6};
    NSString *dateStr = [dateStrTemp stringByReplacingOccurrencesOfString:@":"
                                                               withString:@""
                                                                  options:0
                                                                    range:zoneRange
                         ];

    NSLog(@"*** = %@", dateStr);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"]; //2011-11-14T12:37:22.000-05:00
    NSDate *theLotCreationTime = [dateFormat dateFromString:dateStr];
    
    NSArray *childrenArrayTemp = [theDictionary objectForKey:@"children"];    
    NSMutableArray *childrenArray = [[NSMutableArray alloc] init];    
    for(NSDictionary *theChild in childrenArrayTemp)
    {
        [childrenArray addObject:[BFPosition positionFromDictionary:theChild]];
    }
    
                                  
    BFPosition *position = [[BFPosition alloc] initWithAccountName:theAccountName
                                                         accountID:theAccountID
                                                  instrumentSymbol:theInstrumentSymbol
                                                    instrumentName:theInstrumentName
                                                             lotID:theLotID
                                                   lotCreationTime:theLotCreationTime
                                                          quantity:theQuantity
                                                         lastTrade:theLastTrade
                                                       marketValue:theMarketValue
                                                         pricePaid:thePricePaid
                                                         totalCost:theTotalCost
                                                              gain:theGain
                                                       gainPercent:theGainPercent
                                                          children:childrenArray];

    BFDebugLog(@"accountId = %@", theAccountID);
    BFDebugLog(@"accountName = %@", theAccountName);
    BFDebugLog(@"instrumentSymbol = %@", theInstrumentSymbol);
    BFDebugLog(@"instrumentName = %@", theInstrumentName);    
    BFDebugLog(@"quantity = %@", theQuantity);
    BFDebugLog(@"lotId = %@", theLotID);
    BFDebugLog(@"lotCreationTime = %@", theLotCreationTime);
    
    return position;

}

/*
+ (BFPosition *)positionWithAccountName:(NSString *)theAccountName ***
                              accountID:(NSNumber *)theAccountID ***
                       instrumentSymbol:(NSString *)theInstrumentSymbol ***
                         instrumentName:(NSString *)theInstrumentName ***
                                  lotID:(NSNumber *)theLotID ***
                        lotCreationTime:(NSDate *)theLotCreationTime
                               quantity:(NSNumber *)theQuantity ***
                              lastTrade:(BFMoney *)theLastTrade ***
                            marketValue:(BFMoney *)theMarketValue ***
                              pricePaid:(BFMoney *)thePricePaid ***
                              totalCost:(BFMoney *)theTotalCost ***
                                   gain:(BFMoney *)theGain ***
                            gainPercent:(NSNumber *)theGainPercent ***
                               children:(NSArray *)theChildren
{
    
}
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
                 children:(NSArray *)theChildren
{
    self = [super init];
    
    if(self)
    {
        [self setAccountName:theAccountName];
        [self setAccountID:theAccountID];
        [self setInstrumentSymbol:theInstrumentSymbol];
        [self setInstrumentName:theInstrumentName];
        [self setLotID:theLotID];
        [self setLotCreationTime:theLotCreationTime];
        [self setQuantity:theQuantity];
        [self setLastTrade:theLastTrade];
        [self setMarketValue:theMarketValue];
        [self setPricePaid:thePricePaid];
        [self setTotalCost:theTotalCost];
        [self setGain:theGain];
        [self setGainPercent:theGainPercent];
        [self setChildren:theChildren];
    }
    
    return self;      
}

- (id)init
{
    return [self initWithAccountName:@""
                           accountID:[NSNumber numberWithInt:0]
                    instrumentSymbol:@""
                      instrumentName:@""
                               lotID:[NSNumber numberWithInt:0]
                     lotCreationTime:[NSDate date]
                            quantity:[NSNumber numberWithInt:0]
                           lastTrade:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                         marketValue:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                           pricePaid:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                           totalCost:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                                gain:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                         gainPercent:[NSNumber numberWithInt:0]
                            children:[NSArray array]];
}
@end
