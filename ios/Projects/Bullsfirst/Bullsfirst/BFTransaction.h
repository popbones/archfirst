//
//  TransactionsViewController.h
//  Bullsfirst
//
//  Created by Vivekan Arther
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

@interface BFTransaction : NSObject
{
    NSNumber* transactionId;
    NSDate* creationTime;
    NSString* transactionType;
    NSString* accountName;
    NSNumber* accountId;
    NSString* description;
    BFMoney* amount;
}

@property (nonatomic, retain) NSNumber* transactionId;
@property (nonatomic, retain) NSDate* creationTime;
@property (nonatomic, retain) NSString* transactionType;
@property (nonatomic, retain) NSString* accountName;
@property (nonatomic, retain) NSNumber* accountId;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) BFMoney* amount;

+ (NSMutableArray *)transactionsFromJSONData:(NSData *)data;
+ (BFTransaction *)transactionFromDictionary:(NSDictionary *)theDictionary;

- (id) initWithTransactionId:(NSNumber*)theTransactiondId creationTime:(NSDate*)time transactionType:(NSString*)type accountName:(NSString*)accName accountId:(NSNumber*)accId description:(NSString*)desc amount:(BFMoney*) amt;


@end
