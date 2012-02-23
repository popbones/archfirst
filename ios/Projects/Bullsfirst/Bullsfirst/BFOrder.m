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
@synthesize creationTime;
@synthesize status;
@synthesize cumQty;
@synthesize orderId;

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
                        limitPrice:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]];
            
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
                                   limitPrice:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]];
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
