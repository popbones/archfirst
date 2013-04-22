//
//  BFOrderEstimate.h
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
