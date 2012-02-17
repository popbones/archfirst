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
    NSString *term;
    BOOL    allOrNone;
}

@property (nonatomic, retain) NSNumber *brokerageAccountID;
@property (nonatomic, retain) NSString *accountName;
@property (nonatomic, retain) NSString *side;
@property (nonatomic, retain) NSString *instrumentSymbol;
@property (nonatomic, retain) NSNumber *quantity;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) BFMoney *limitPrice;
@property (nonatomic, retain) NSString *term;
@property (nonatomic, assign) BOOL    allOrNone;

- (id)initWithAccountID:(NSNumber *)theAccountID
            accountName:(NSString *)theAccountName
                   side:(NSString *)theSide
       instrumentSymbol:(NSString *)theInstrumentSymbol
               quantity:(NSNumber *)theQuantity
                   type:(NSString *)theType
             limitPrice:(BFMoney *)theLimitPrice
                   term:(NSString*)theTerm
              allOrNone:(BOOL)theAllOrNone;

@end
