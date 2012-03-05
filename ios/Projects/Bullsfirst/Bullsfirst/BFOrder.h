//
//  BFOrder.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
         executionPrice:(BFMoney *)theExecutionPrice;

@end
