//
//  BFOrder.m
//  Bullsfirst
//
//  Created by Pong Choa on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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

- (id)initWithAccountID:(NSNumber *)theAccountID
            accountName:(NSString *)theAccountName
                   side:(NSString *)theSide
       instrumentSymbol:(NSString *)theInstrumentSymbol
               quantity:(NSNumber *)theQuantity
                   type:(NSString *)theType
             limitPrice:(BFMoney *)theLimitPrice
                   term:(NSString*)theTerm
              allOrNone:(BOOL)theAllOrNone
{
    self = [super init];
    
    if(self)
    {
        self.brokerageAccountID = theAccountID;
        self.accountName = theAccountName;
        self.side = theSide;
        self.instrumentSymbol = theInstrumentSymbol;
        self.quantity = theQuantity;
        self.type = theType;
        self.limitPrice = theLimitPrice;
        self.term = term;
        self.allOrNone = theAllOrNone;
    }
    
    return self;      
}

- (id)init
{
    return [self initWithAccountID:[NSNumber numberWithInt:0]
                       accountName:@""
                              side:@""
                  instrumentSymbol:@""
                          quantity:[NSNumber numberWithInt:0]
                              type:@""
                        limitPrice:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                              term:@""
                         allOrNone:NO];
}
@end
