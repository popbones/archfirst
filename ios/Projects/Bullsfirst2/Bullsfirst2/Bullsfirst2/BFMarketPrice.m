//
//  BFMarketPrice.m
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

#import "BFMarketPrice.h"

@implementation BFMarketPrice
@synthesize effectiveTime;
@synthesize price;
@synthesize instrumentSymbol;

- (id)initWithSymbol:(NSString *)theInstrumentSymbol
       effectiveTime:(NSDate *)theEffectiveTIme
               price:(BFMoney *)thePrice
{
    self = [super init];
    
    if(self)
    {
        self.instrumentSymbol = theInstrumentSymbol;
        self.price = thePrice;
        self.effectiveTime = theEffectiveTIme;
    }
    
    return self;      

}

- (id)init
{
    return [self initWithSymbol:@""
                  effectiveTime:[NSDate date]
                          price:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]];
    
}

+ (BFMarketPrice *)marketPriceFromJSONData:(NSData *)data
{
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    BFDebugLog(@"jsonObject = %@", jsonObject);
    
    NSString *symbol = [jsonObject valueForKey:@"symbol"];
    // TODO: Fix reading in the lotCreationTime, for now just getting null
    NSString *dateStrTemp = [jsonObject valueForKey:@"effective"];
    // removed the last : in the time zone
    NSRange zoneRange = {23, 6};
    NSString *dateStr = [dateStrTemp stringByReplacingOccurrencesOfString:@":"
                                                               withString:@""
                                                                  options:0
                                                                    range:zoneRange];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"]; //2011-11-14T12:37:22.000-05:00
    NSDate *effectTime = [dateFormat dateFromString:dateStr];
    
    NSDictionary *priceDic = [jsonObject valueForKey:@"price"];
    BFMoney *thePrice;
    if (priceDic != nil && [priceDic count] > 0) {
        thePrice = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[priceDic valueForKey:@"amount"] floatValue]] currency:[priceDic valueForKey:@"currency"]];
    }

    BFMarketPrice *price = [[BFMarketPrice alloc] initWithSymbol:symbol effectiveTime:effectTime price:thePrice];
    
    return price;
 
}
@end
