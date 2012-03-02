//
//  BFInstrument.m
//  Bullsfirst
//
//  Created by Pong Choa on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BFInstrument.h"
#import "AppDelegate.h"

@implementation BFInstrument
@synthesize symbol;
@synthesize name;
@synthesize exchange;

static NSArray *defaultInstruments = nil;

+ (NSMutableArray *)instrumentsFromJSONData:(NSData *)data
{
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    BFDebugLog(@"jsonObject = %@", jsonObject);
    
    NSMutableArray *instruments = [[NSMutableArray alloc] init];
    
    if([jsonObject isEqual:[NSNull null]] || (jsonObject == nil))
    {
        return instruments;        
    }
    
    for(NSDictionary *instrument in jsonObject)
    {
        BFInstrument *anInstrument = [BFInstrument instrumentFromDictionary:instrument];
        [instruments addObject:anInstrument];
    }
    
    return instruments;
}


+ (BFInstrument *)instrumentFromDictionary:(NSDictionary *)theDictionary
{
    NSString *aName = [theDictionary valueForKey:@"name"];
    NSString *aSymbol = [theDictionary valueForKey:@"symbol"];
    NSString *aExchange = [theDictionary valueForKey:@"exchange"];
    
    return [[BFInstrument alloc] initWithInstrumentSymbol:aSymbol name:aName exchange:aExchange];
}

+ (NSArray *)getAllInstruments
{
    return defaultInstruments;
}

+ (NSArray *)setAllInstruments:(NSArray *)instrumnets
{
    defaultInstruments = [NSArray arrayWithArray:instrumnets];
    return defaultInstruments;
}

- (id) initWithInstrumentSymbol:(NSString*)theSymbol name:(NSString*)theName exchange:(NSString*)theExchange
{
    self = [super init];
    
    self.symbol = [NSString stringWithString:theSymbol];
    self.name = [NSString stringWithString:theName];
    self.exchange = [NSString stringWithString:theExchange];
    
    return self;
}


@end
