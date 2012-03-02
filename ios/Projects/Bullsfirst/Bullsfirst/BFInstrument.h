//
//  BFInstrument.h
//  Bullsfirst
//
//  Created by Pong Choa on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFInstrument : NSObject {
    NSString* symbol;
    NSString* name;
    NSString* exchange;

}

@property (nonatomic, retain) NSString* symbol;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* exchange;

+ (BFInstrument *)instrumentFromDictionary:(NSDictionary *)theDictionary;
+ (NSMutableArray *)instrumentsFromJSONData:(NSData *)data;

+ (NSArray *)getAllInstruments;
+ (NSArray *)setAllInstruments:(NSArray *)instrumnets;

- (id) initWithInstrumentSymbol:(NSString*)theSymbol name:(NSString*)theName exchange:(NSString*)theExchange;

@end
