//
//  BFMoney.m
//  Bullsfirst
//
//  Created by Joe Howard
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

#import "BFMoney.h"

@implementation BFMoney

@synthesize amount;
@synthesize currency;

+ (id)moneyWithAmount:(NSNumber *)theAmount currency:(NSString *)theCurrency
{
    BFMoney *money = [[BFMoney alloc] initWithAmount:theAmount currency:theCurrency];
    
    return money;
}

- (id)initWithAmount:(NSNumber *)theAmount currency:(NSString *)theCurrency
{
    self = [super init];
    
    if(self)
    {
        [self setAmount:theAmount];
        [self setCurrency:theCurrency];
        
    }
    
    return self;
}

- (id)init
{
    return [self initWithAmount:[NSNumber numberWithInt:0] currency:@""];
}

//comparison

-(NSComparisonResult) compare:(BFMoney*) anotherMoney
{
    return [self.amount compare:anotherMoney.amount];
}

@end
