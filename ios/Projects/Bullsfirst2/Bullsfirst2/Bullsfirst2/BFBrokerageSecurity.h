//
//  BFBrokerageSecurity.h
//  Bullsfirst2
//
//  Created by Rashmi Garg on 12/21/12.
//  For storyboard and Bullsfirst2 design
//  Copyright (c) 2012 Rashmi Garg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFMoney;
@interface BFBrokerageSecurity : NSObject
{
    NSString *instrumentName;
    NSString *instrumentSymbol;
    NSNumber *quantity;
    BFMoney *lastTrade;
    BFMoney *marketValue;
    BFMoney *pricePaid;
    BFMoney *totalCost;
    BFMoney *gain;
    NSNumber *gainPercent; // float
    NSMutableArray *accounts;
}

@property (nonatomic, retain) NSString *instrumentSymbol;
@property (nonatomic, retain)  NSString *instrumentName;
//@property (nonatomic, retain) BFMoney *cashPosition;
@property (nonatomic, retain) NSNumber *quantity;
@property (nonatomic, retain) BFMoney *lastTrade;
@property (nonatomic, retain) BFMoney *marketValue;
@property (nonatomic, retain) BFMoney *pricePaid;
@property (nonatomic, retain) BFMoney *totalCost;
@property (nonatomic, retain) BFMoney *gain;
@property (nonatomic, retain) NSNumber *gainPercent; // float
@property (nonatomic, retain) NSMutableArray *accounts;

//+ (BFBrokerageSymbol *)securitiesFromDictionary:(NSDictionary *)theDictionary;
+ (NSMutableArray *)securitiesFromJSONData:(NSData *)data;

- (id)initWithName:(NSString *)theName
  instrumentSymbol:(NSString *)theInstrumentSymbol
          quantity:(NSNumber *)theQuantity
         lastTrade:(BFMoney *)theLastTrade
       marketValue:(BFMoney *)theMarketValue
         pricePaid:(BFMoney *)thePricePaid
         totalCost:(BFMoney *)theTotalCost
              gain:(BFMoney *)theGain
       gainPercent:(NSNumber *)theGainPercent
          accounts:(NSMutableArray *)theAccounts;

@end
