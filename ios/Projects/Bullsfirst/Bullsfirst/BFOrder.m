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
    NSNumber *orderID = [NSNumber numberWithInt:[[theDictionary valueForKey:@"id"] intValue]];   

    return [[BFOrder alloc] initWithAccountID:accountID 
                                  accountName:accountName 
                                         side:side 
                             instrumentSymbol:symbol 
                                     quantity:quantity 
                                         type:type 
                                   limitPrice:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                                         term:term 
                                    allOrNone:[allOrNone intValue]];
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
