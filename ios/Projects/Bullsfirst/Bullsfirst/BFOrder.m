//
//  BFOrder.m
//  Bullsfirst
//
//  Created by Pong Choa
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

#import "BFOrder.h"

@implementation BFOrder
@synthesize brokerageAccountID;
@synthesize accountName;
@synthesize side;
@synthesize instrumentSymbol;
@synthesize quantity;
@synthesize type;
@synthesize limitPrice;
@synthesize term;
@synthesize allOrNone;
@synthesize creationTime;
@synthesize status;
@synthesize cumQty;
@synthesize orderId;
@synthesize executionPrice;
@synthesize executionsPrice;

- (id)initWithAccountID:(NSNumber *)theAccountID
            accountName:(NSString *)theAccountName
              allOrNone:(BOOL)theAllOrNone
           creationTime:(NSDate *)theCreationTIme
                 cumQty:(NSNumber *)theCumQty
                orderId:(NSNumber *)theOrderId
               quantity:(NSNumber *)theQuantity
                   side:(NSString *)theSide
                 status:(NSString *)theStatus
       instrumentSymbol:(NSString *)theInstrumentSymbol
                   term:(NSString*)theTerm
                   type:(NSString *)theType
             limitPrice:(BFMoney *)theLimitPrice
         executionPrice:(BFMoney *)theExecutionPrice
         executionsPrice:(NSDictionary *)theExecutionsPrice
{
    self = [super init];
    
    if(self)
    {
        self.brokerageAccountID = theAccountID;
        self.accountName = theAccountName;
        self.allOrNone = theAllOrNone;
        self.creationTime = theCreationTIme;
        self.cumQty = theCumQty;
        self.orderId = theOrderId;
        self.quantity = theQuantity;
        self.side = theSide;
        self.status = theStatus;
        self.instrumentSymbol = theInstrumentSymbol;
        self.term = theTerm;
        self.type = theType;
        self.limitPrice = theLimitPrice;
        self.executionPrice = theExecutionPrice;
        self.executionsPrice = theExecutionsPrice;
    }
    
    return self;      
}

- (id)init
{
    return [self initWithAccountID:[NSNumber numberWithInt:0]
                       accountName:@""
                         allOrNone:NO
                      creationTime:[NSDate date]
                            cumQty:[NSNumber numberWithInt:0]
                           orderId:[NSNumber numberWithInt:0]
                          quantity:[NSNumber numberWithInt:0]
                              side:@""
                            status:@""
                  instrumentSymbol:@""
                              term:@""
                              type:@""
                        limitPrice:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                    executionPrice:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                   executionsPrice:nil];
            
}

+ (BFOrder *)orderFromDictionary:(NSDictionary *)theDictionary
{
    NSNumber *accountID = [NSNumber numberWithInt:[[theDictionary valueForKey:@"accountId"] intValue]];        
    NSString *accountName = [theDictionary valueForKey:@"accountName"];
    NSNumber *allOrNone = [theDictionary valueForKey:@"allOrNone"];
    // TODO: Fix reading in the lotCreationTime, for now just getting null
    NSString *dateStrTemp = [theDictionary objectForKey:@"creationTime"];
    // removed the last : in the time zone
    NSRange zoneRange = {23, 6};
    NSString *dateStr = [dateStrTemp stringByReplacingOccurrencesOfString:@":"
                                                               withString:@""
                                                                  options:0
                                                                    range:zoneRange];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"]; //2011-11-14T12:37:22.000-05:00
    NSDate *creationTime = [dateFormat dateFromString:dateStr];
    NSNumber *quantity = [NSNumber numberWithFloat:[[theDictionary valueForKey:@"quantity"] floatValue]];
    NSString *side = [theDictionary valueForKey:@"side"];
    NSString *status = [theDictionary valueForKey:@"status"];
    NSString *symbol = [theDictionary valueForKey:@"symbol"];
    NSString *term = [theDictionary valueForKey:@"term"];
    NSString *type = [theDictionary valueForKey:@"type"];
    NSNumber *cumQty = [NSNumber numberWithInt:[[theDictionary valueForKey:@"cumQty"] intValue]];
    NSNumber *orderID = [NSNumber numberWithInt:[[theDictionary valueForKey:@"id"] intValue]];   
    
    NSDictionary *limitedPriceDic = [theDictionary objectForKey:@"limitPrice"];
    BFMoney *limitedPrice;
    if (limitedPriceDic != nil && [limitedPriceDic count] > 0) {
        limitedPrice = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[limitedPriceDic valueForKey:@"amount"] floatValue]] currency:[limitedPriceDic valueForKey:@"currency"]];
    }

    NSDictionary *executionsPriceDic = [theDictionary objectForKey:@"executions"];
    BFMoney *executionPrice;
    if (executionsPriceDic != nil && [executionsPriceDic count] > 0) {
        float totalAmount = 0;
        float totalQty = 0;
        for (NSDictionary *execution in executionsPriceDic) {
            NSDictionary *priceDic = [execution objectForKey:@"price"];
            NSNumber *amount = [NSNumber numberWithFloat:[[priceDic valueForKey:@"amount"] floatValue]];
            totalAmount += [amount floatValue];
            NSNumber *quantity = [NSNumber numberWithFloat:[[execution valueForKey:@"quantity"] floatValue]];
            totalQty += [quantity floatValue];
        }
        executionPrice = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:totalAmount/totalQty] currency:@""];
    }

    return [[BFOrder alloc] initWithAccountID:accountID
                                  accountName:accountName
                                    allOrNone:[allOrNone intValue]
                                 creationTime:creationTime
                                       cumQty:cumQty
                                      orderId:orderID
                                     quantity:quantity
                                         side:side
                                       status:status
                             instrumentSymbol:symbol
                                         term:term
                                         type:type
                                   limitPrice:limitedPrice
                               executionPrice:executionPrice
                              executionsPrice:executionsPriceDic];
}

+ (NSMutableArray *)ordersFromJSONData:(NSData *)data
{
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    BFDebugLog(@"jsonObject = %@", jsonObject);

    NSMutableArray *orders = [[NSMutableArray alloc] init];
    
    if([jsonObject isEqual:[NSNull null]] || (jsonObject == nil))
    {
        return orders;        
    }
    
    for(NSDictionary *order in jsonObject)
    {
        BFOrder *anOrder = [BFOrder orderFromDictionary:order];
        [orders addObject:anOrder];
    }
    
    return orders;
}

@end
