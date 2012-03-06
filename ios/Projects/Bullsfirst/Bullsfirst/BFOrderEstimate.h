//
//  BFOrderEstimate.h
//  Bullsfirst
//
//  Created by Pong Choa on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFMoney.h"
@interface BFOrderEstimate : NSObject{
    NSString *compliance;
    BFMoney *estimatedValue;
    BFMoney *fees;
    BFMoney *estimatedValueIncFee;
}

@property (nonatomic, retain) NSString *compliance;
@property (nonatomic, retain) BFMoney *estimatedValue;
@property (nonatomic, retain) BFMoney *fees;
@property (nonatomic, retain) BFMoney *estimatedValueIncFee;

+ (BFOrderEstimate *)estimateValueFromJSONData:(NSData *)data;

- (id)initWithEstimate:(NSString *)theCompliance
        estimatedValue:(BFMoney *)thePrice
                  fees:(BFMoney *)theFee
  estimatedValueIncFee:(BFMoney *)theEstimatedValueIncFee;


@end
