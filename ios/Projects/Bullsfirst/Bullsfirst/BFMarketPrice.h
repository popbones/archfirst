//
//  BFMarketPrice.h
//  Bullsfirst
//
//  Created by Pong Choa on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFMoney.h"

@interface BFMarketPrice : NSObject {
    NSString *instrumentSymbol;
    BFMoney *price;
    NSDate *effectiveTime;
}

@property (nonatomic, retain) NSDate *effectiveTime;
@property (nonatomic, retain) NSString *instrumentSymbol;
@property (nonatomic, retain) BFMoney *price;

+ (BFMarketPrice *)marketPriceFromJSONData:(NSData *)data;

- (id)initWithSymbol:(NSString *)theInstrumentSymbol
       effectiveTime:(NSDate *)theEffectiveTIme
               price:(BFMoney *)thePrice;


@end
