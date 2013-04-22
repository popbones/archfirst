//
//  BFOrder.h
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

#import <Foundation/Foundation.h>
#import "BFMoney.h"

@interface BFOrder : NSObject {
    NSNumber *brokerageAccountID;
    NSString *accountName;
    NSString *side;
    NSString *instrumentSymbol;
    NSNumber *quantity;
    NSString *type;
    BFMoney *limitPrice;
    BFMoney *executionPrice;
    NSString *term;
    BOOL    allOrNone;
    NSDate *creationTime;
    NSString *status;
    NSNumber *orderId;
    NSNumber *cumQty;
    NSDictionary *executionsPrice;
}

@property (nonatomic, retain) NSNumber *brokerageAccountID;
@property (nonatomic, retain) NSString *accountName;
@property (nonatomic, assign) BOOL    allOrNone;
@property (nonatomic, retain) NSDate *creationTime;
@property (nonatomic, retain) NSNumber *cumQty;
@property (nonatomic, retain) NSNumber *orderId;
@property (nonatomic, retain) NSNumber *quantity;
@property (nonatomic, retain) NSString *side;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *instrumentSymbol;
@property (nonatomic, retain) NSString *term;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) BFMoney *limitPrice;
@property (nonatomic, retain) BFMoney *executionPrice;
@property (nonatomic, retain) NSDictionary *executionsPrice;

+ (NSMutableArray *)ordersFromJSONData:(NSData *)data;
+ (BFOrder *)orderFromDictionary:(NSDictionary *)theDictionary;

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
        executionsPrice:(NSDictionary *)theExecutionsPrice;

@end
