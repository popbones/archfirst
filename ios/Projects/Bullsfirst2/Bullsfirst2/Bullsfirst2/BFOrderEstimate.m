//
//  BFOrderEstimate.m
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

#import "BFOrderEstimate.h"

@implementation BFOrderEstimate

@synthesize compliance;
@synthesize estimatedValue;
@synthesize fees;
@synthesize estimatedValueIncFee;

- (id)initWithEstimate:(NSString *)theCompliance
        estimatedValue:(BFMoney *)thePrice
                   fees:(BFMoney *)theFee
  estimatedValueIncFee:(BFMoney *)theEstimatedValueIncFee
{
    self = [super init];
    
    if(self)
    {
        self.compliance = theCompliance;
        self.estimatedValue = thePrice;
        self.fees = theFee;
        self.estimatedValueIncFee = theEstimatedValueIncFee;
    }
    
    return self;      
   
}

+ (BFOrderEstimate *)estimateValueFromJSONData:(NSData *)data
{
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    BFDebugLog(@"jsonObject = %@", jsonObject);
    
    NSString *compliance = [jsonObject valueForKey:@"compliance"];
    // TODO: Fix reading in the lotCreationTime, for now just getting null
    
    NSDictionary *priceDic = [jsonObject valueForKey:@"estimatedValue"];
    BFMoney *theEstimatedValue;
    if (priceDic != nil && [priceDic count] > 0) {
        theEstimatedValue = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[priceDic valueForKey:@"amount"] floatValue]] currency:[priceDic valueForKey:@"currency"]];
    }
    
    priceDic = [jsonObject valueForKey:@"fees"];
    BFMoney *thefees;
    if (priceDic != nil && [priceDic count] > 0) {
        thefees = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[priceDic valueForKey:@"amount"] floatValue]] currency:[priceDic valueForKey:@"currency"]];
    }

    BFMoney *theEstimatedValueIncFee;
    if (thefees.amount >0||theEstimatedValue.amount>0) {
        theEstimatedValueIncFee = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:(theEstimatedValue.amount.floatValue+thefees.amount.floatValue)] currency:[priceDic valueForKey:@"currency"]];
    }
    BFOrderEstimate *estimate = [[BFOrderEstimate alloc] initWithEstimate:compliance 
                                                           estimatedValue:theEstimatedValue 
                                                                      fees:thefees
                                                     estimatedValueIncFee:theEstimatedValueIncFee];
    
    return estimate;
}


@end
