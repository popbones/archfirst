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

#import "BFTransaction.h"

@implementation BFTransaction

@synthesize transactionType,amount,accountId,accountName,description,creationTime,transactionId;

+ (NSMutableArray *)transactionsFromJSONData:(NSData *)data
{
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    BFDebugLog(@"jsonObject = %@", jsonObject);
    
    NSMutableArray *transactions = [[NSMutableArray alloc] init];
    
    if([jsonObject isEqual:[NSNull null]] || (jsonObject == nil))
    {
        return transactions;        
    }
    
    for(NSDictionary *transaction in jsonObject)
    {
        BFTransaction *aTransaction = [BFTransaction transactionFromDictionary:transaction];
        [transactions addObject:aTransaction];
    }
    
    return transactions;
}


+ (BFTransaction *)transactionFromDictionary:(NSDictionary *)theDictionary
{
    NSNumber *accountID = [NSNumber numberWithInt:[[theDictionary valueForKey:@"accountId"] intValue]];        
    NSString *accountName = [theDictionary valueForKey:@"accountName"];
    
    NSString *dateStrTemp = [theDictionary objectForKey:@"creationTime"];
    // removed the last : in the time zone
    NSRange zoneRange = {23, 6};
    NSString *dateStr = [dateStrTemp stringByReplacingOccurrencesOfString:@":"
                                                               withString:@""
                                                                  options:0
                                                                    range:zoneRange];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"]; //2011-11-14T12:37:22.000-05:00
    NSDate *creationTime = [dateFormat dateFromString:dateStr];
    NSString *type = [theDictionary valueForKey:@"type"];
    NSNumber *theTransactionId = [theDictionary valueForKey:@"transactionId"]; 
    NSString *desc = [theDictionary valueForKey:@"description"];
    NSDictionary* moneyDictionary = [theDictionary valueForKey:@"amount"];
    
    NSNumber* theAmt= [moneyDictionary valueForKey:@"amount"];
    NSString* theCurrency = [moneyDictionary valueForKey:@"currency"];
    
    BFMoney *theAmount = [[BFMoney alloc]initWithAmount:theAmt currency:theCurrency];
    
    return ([[BFTransaction alloc] initWithTransactionId:theTransactionId creationTime:creationTime transactionType:type accountName:accountName accountId:accountID description:desc amount:theAmount]);
}

- (id) initWithTransactionId:(NSNumber*)theTransactiondId creationTime:(NSDate*)time transactionType:(NSString*)type accountName:(NSString*)accName accountId:(NSNumber*)accId description:(NSString*)desc amount:(BFMoney*) amt
{
    self = [super init];
    
    self.transactionId = theTransactiondId;
    self.creationTime = time;
    self.transactionType = type;
    self.accountName = accName;
    self.accountId = accId;
    self.description = desc;
    self.amount = amt;
    
    return self;
}

@end
