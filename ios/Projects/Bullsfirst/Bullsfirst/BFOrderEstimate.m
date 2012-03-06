//
//  BFOrderEstimate.m
//  Bullsfirst
//
//  Created by Pong Choa on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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

    priceDic = [jsonObject valueForKey:@"fees"];
    BFMoney *theRstimatedValueIncFee;
    if (priceDic != nil && [priceDic count] > 0) {
        theRstimatedValueIncFee = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[priceDic valueForKey:@"amount"] floatValue]] currency:[priceDic valueForKey:@"currency"]];
    }
    BFOrderEstimate *estimate = [[BFOrderEstimate alloc] initWithEstimate:compliance 
                                                           estimatedValue:theEstimatedValue 
                                                                      fees:thefees
                                                     estimatedValueIncFee:theRstimatedValueIncFee];
    
    return estimate;
}


@end
