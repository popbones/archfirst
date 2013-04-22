//
//  BFBrokerageSecurity.m
//  Bullsfirst2
//
//  Created by Rashmi Garg on 12/21/12.
//  For storyboard and Bullsfirst2 design
//  Copyright (c) 2012 Rashmi Garg. All rights reserved.
//

#import "BFBrokerageSecurity.h"
#import "BFBrokerageAccount.h"
#import "BFPosition.h"
#import "BFMoney.h"

@implementation BFBrokerageSecurity
@synthesize instrumentName, instrumentSymbol, quantity, lastTrade, marketValue, pricePaid, totalCost, gain, gainPercent;
@synthesize accounts;

+(void) printSecurities:(NSMutableArray *)theSecurities
{
    BFBrokerageSecurity *sym;
    
    
    BFDebugLog(@"The securities Array is ");
    for(sym in theSecurities)
    {
        BFDebugLog(@"The name is %@", [sym instrumentName]);
        BFDebugLog(@"The symbol is %@", [sym instrumentSymbol]);
        BFDebugLog(@"The Count of Array is %d", [[sym accounts] count]);
        for(BFPosition *pos in [sym accounts])
        {
            BFDebugLog(@"The account is %@", [pos accountID]);
            BFDebugLog(@"The account name is %@", [pos accountName]);
            if([pos children])
                BFDebugLog(@"The Count of children is %d", [[pos children] count]);
            
        }
        
    }
    
}

+ (NSMutableArray *)securitiesFromJSONData:(NSData *)data
{
    NSMutableArray *securities = [[NSMutableArray alloc] init];
    
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    BFDebugLog(@"jsonObject = %@", jsonObject);
    
    if([jsonObject isEqual:[NSNull null]] || (jsonObject == nil))
    {
        return securities;
    }
    
    for(NSDictionary *theAccountInDic in jsonObject)
    {
    
        NSString *theName;
        NSString *theInstrumentSymbol;
        BFBrokerageSecurity *theFoundSecurity;
        Boolean found=FALSE;
        
        NSArray *positionsArrayTemp = [theAccountInDic objectForKey:@"positions"];
        //NSMutableArray *accountsArray = [[NSMutableArray alloc] init];
        for(NSDictionary *thePosition in positionsArrayTemp)
        {

            theName = [thePosition valueForKey:@"instrumentName"];
            theInstrumentSymbol = [thePosition valueForKey:@"instrumentSymbol"];
            
            NSNumber *theQuantity = [NSNumber numberWithFloat:[[thePosition valueForKey:@"quantity"] floatValue]];
            
            NSDictionary *lastTradeDic = [thePosition objectForKey:@"lastTrade"];
            BFMoney *theLastTrade = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[lastTradeDic valueForKey:@"amount"] floatValue]] currency:[lastTradeDic valueForKey:@"currency"]];
            
            NSDictionary *mvDic = [thePosition objectForKey:@"marketValue"];
            BFMoney *theMarketValue = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[mvDic valueForKey:@"amount"] floatValue]] currency:[mvDic valueForKey:@"currency"]];
            
            NSDictionary *pricePaidDic = [thePosition objectForKey:@"pricePaid"];
            BFMoney *thePricePaid = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[pricePaidDic valueForKey:@"amount"] floatValue]] currency:[pricePaidDic valueForKey:@"currency"]];
            
            NSDictionary *totalCostDic = [thePosition objectForKey:@"totalCost"];
            BFMoney *theTotalCost = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[totalCostDic valueForKey:@"amount"] floatValue]] currency:[totalCostDic valueForKey:@"currency"]];
            
            NSDictionary *gainDic = [thePosition objectForKey:@"gain"];
            BFMoney *theGain = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[[gainDic valueForKey:@"amount"] floatValue]] currency:[gainDic valueForKey:@"currency"]];
            
            
            
            NSNumber *theGainPercent = [NSNumber numberWithFloat:[[thePosition valueForKey:@"gainPercent"] floatValue]];
            NSMutableArray *accountsArray = [[NSMutableArray alloc] init];
            //BFBrokerageAccount *accountsArray = [[NSMutableArray alloc] init];
            [accountsArray addObject:[BFPosition positionFromDictionary:thePosition]];
            BFBrokerageSecurity *theSecurity = [[BFBrokerageSecurity alloc] initWithName:theName
                                                                      instrumentSymbol:theInstrumentSymbol
                                                                              quantity:(NSNumber *)theQuantity
                                                                             lastTrade:(BFMoney *)theLastTrade
                                                                           marketValue:(BFMoney *)theMarketValue
                                                                             pricePaid:(BFMoney *)thePricePaid
                                                                             totalCost:(BFMoney *)theTotalCost
                                                                                  gain:(BFMoney *)theGain
                                                                           gainPercent:(NSNumber *)theGainPercent
                                                                              accounts:accountsArray];
            found=FALSE;
            
            for(theFoundSecurity in securities)
            {
                NSString *instName = [theFoundSecurity instrumentName];
                //BFDebugLog(@"instrument names already = %@", theName);
                if([instName isEqualToString:theName])
                {
                    //BFDebugLog(@"Found Matching entry = %@", theName);
                    found=TRUE;
                    break;
                }
                
            }
            if(found)
            {
                //BFBrokerageSecurity *theSecurityFound = [securities valueForKey:@"instrumentName"];
                
                NSMutableArray *theSecurityPositions = [theFoundSecurity accounts];
                //BFDebugLog(@"Array found and has = %d children", [theSecurityPositions count]);
                [theSecurityPositions addObject:[BFPosition positionFromDictionary:thePosition]];
                //BFDebugLog(@"Array found and now has = %d children", [theSecurityPositions count]);
                
            }
            else
                [securities addObject:theSecurity];
            //BFDebugLog(@"Adding name = %@", theName);
            //BFDebugLog(@"Adding Security = %@", theInstrumentSymbol);
        }
  
    }
    
    //[self printSecurities:securities];
    
    return securities;
}



- (id)initWithName:(NSString *)theName
  instrumentSymbol:(NSString *)theInstrumentSymbol
          quantity:(NSNumber *)theQuantity
         lastTrade:(BFMoney *)theLastTrade
       marketValue:(BFMoney *)theMarketValue
         pricePaid:(BFMoney *)thePricePaid
         totalCost:(BFMoney *)theTotalCost
              gain:(BFMoney *)theGain
       gainPercent:(NSNumber *)theGainPercent
          accounts:(NSMutableArray *)theAccounts
{
    self = [super init];
    
    if(self)
    {
        [self setInstrumentName:theName];
        [self setInstrumentSymbol:theInstrumentSymbol];
        [self setQuantity:theQuantity];
        [self setLastTrade:theLastTrade];
        [self setMarketValue:theMarketValue];
        [self setPricePaid:thePricePaid];
        [self setTotalCost:theTotalCost];
        [self setGain:theGain];
        [self setGainPercent:theGainPercent];
        [self setAccounts:theAccounts];
    }
    
    return self;
    
}
- (id)init
{    
    return [self initWithName:@"Name"
             instrumentSymbol:@"Symbol"
                     quantity:[NSNumber numberWithInt:0]
                    lastTrade:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                  marketValue:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                    pricePaid:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                    totalCost:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                         gain:[BFMoney moneyWithAmount:[NSNumber numberWithInt:0] currency:@""]
                  gainPercent:[NSNumber numberWithInt:0]
                     accounts:[NSArray array]];
}



@end

