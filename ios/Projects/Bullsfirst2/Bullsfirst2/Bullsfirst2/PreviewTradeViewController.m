//
//  PreviewTradeViewController.m
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

#import "PreviewTradeViewController.h"
#import "BFMarketPrice.h"
#import "BFOrderEstimate.h"
#import "AppDelegate.h"

@implementation PreviewTradeViewController
@synthesize order;
@synthesize accountNameLabel;
@synthesize sideLabel;
@synthesize quantityLabel;
@synthesize cusipLabel;
@synthesize typeLabel;
@synthesize termLabel;
@synthesize allOrNoneLabel;
@synthesize limitPriceLabel;
@synthesize spinner;
@synthesize orderTypeLabel;
@synthesize limitedPrice;
@synthesize term;
@synthesize allOrNone;
@synthesize estimateOrderServiceObject;
@synthesize estValue;
@synthesize fee;
@synthesize totalInclFee;
@synthesize lastTrade;
@synthesize restServiceObject;
@synthesize lastTradeServiceObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(BFOrder *)anOrder
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.order = anOrder;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.navigationItem.title = @"Preview Order";
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];
    
    self.accountNameLabel.text = order.accountName;
    self.sideLabel.text = order.side;
    self.cusipLabel.text = order.instrumentSymbol;
    NSNumberFormatter *decemalFormatter = [[NSNumberFormatter alloc] init];  
    [decemalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    self.quantityLabel.text = [decemalFormatter stringFromNumber:order.quantity];
    self.orderTypeLabel.text =order.type;

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    if ([order.type isEqualToString:@"Limit"]) {
        limitPriceLabel.text = [formatter stringFromNumber:order.limitPrice.amount];
        limitPriceLabel.hidden = NO;
        limitedPrice.hidden = NO;
        CGRect frame = CGRectMake(self.term.frame.origin.x, self.term.frame.origin.y+25, self.term.frame.size.width, self.term.frame.size.height);
        self.term.frame = frame;
        frame = CGRectMake(self.termLabel.frame.origin.x, self.termLabel.frame.origin.y+25, self.termLabel.frame.size.width, self.termLabel.frame.size.height);
        self.termLabel.frame = frame;
        frame = CGRectMake(self.allOrNoneLabel.frame.origin.x, self.allOrNoneLabel.frame.origin.y+25, self.allOrNoneLabel.frame.size.width, self.allOrNoneLabel.frame.size.height);
        self.allOrNoneLabel.frame = frame;
        frame = CGRectMake(self.allOrNone.frame.origin.x, self.allOrNone.frame.origin.y+25, self.allOrNone.frame.size.width, self.allOrNone.frame.size.height);
        self.allOrNone.frame = frame;
   } else {
        limitPriceLabel.hidden = YES;
        limitedPrice.hidden = YES;
    }
    self.termLabel.text = order.term;
    if (order.allOrNone == YES)
        allOrNoneLabel.text = @"Yes";
    else
        allOrNoneLabel.text = @"No";

    [spinner stopAnimating];
    restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self 
                                                        responseSelector:nil 
                                                     receiveDataSelector:nil 
                                                         successSelector:@selector(requestSucceeded:) 
                                                           errorSelector:@selector(requestFailed:)];
    
    estimateOrderServiceObject = [[BullFirstWebServiceObject alloc] initWithObject:self 
                                                                  responseSelector:nil
                                                               receiveDataSelector:nil
                                                                   successSelector:@selector(estimateRequestSucceeded:) 
                                                                     errorSelector:@selector(estimateRequestFailed:)];


    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/order_estimates"];
    
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    [jsonDic setValue:order.brokerageAccountID forKey:@"brokerageAccountId"];
    
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc] init];
    [orderDic setValue:order.side forKey:@"side"];
    [orderDic setValue:[order.instrumentSymbol uppercaseString] forKey:@"symbol"];
    [orderDic setValue:order.quantity forKey:@"quantity"];
    [orderDic setValue:order.type forKey:@"type"];
    if ([order.term isEqualToString:@"Good for day"])
        [orderDic setValue:@"GoodForTheDay" forKey:@"term"];
    else
        [orderDic setValue:@"GoodTilCanceled" forKey:@"term"];
    
    if (order.allOrNone == YES) 
        [orderDic setValue:@"true" forKey:@"allOrNone"];
    else
        [orderDic setValue:@"false" forKey:@"allOrNone"];
    
    if ([order.type isEqualToString:@"Limit"]) {
        NSMutableDictionary *limitedOrderDic = [[NSMutableDictionary alloc] init];
        [limitedOrderDic setValue:order.limitPrice.amount forKey:@"amount"];
        [limitedOrderDic setValue:order.limitPrice.currency forKey:@"currency"];
        [orderDic setValue:limitedOrderDic forKey:@"limitPrice"];
    }
    
    [jsonDic setValue:orderDic forKey:@"orderParams"];
    
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    
	NSString *responseData = [[NSString alloc] initWithData:jsonBodyData  encoding:NSMacOSRomanStringEncoding];
    BFDebugLog(@"jsonObject = %@", responseData);
    
    [estimateOrderServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];

    lastTradeServiceObject = [[BullFirstWebServiceObject alloc] initWithObject:self 
                                                                  responseSelector:nil
                                                               receiveDataSelector:nil
                                                                   successSelector:@selector(lastTradeRequestSucceeded:) 
                                                                     errorSelector:@selector(lastTradeRequestFailed:)];

    NSURL *lastTradeUrl = [NSURL URLWithString:[NSString stringWithFormat: @"http://archfirst.org/bfexch-javaee/rest/market_prices/%@", [order.instrumentSymbol uppercaseString]]];
    [lastTradeServiceObject getRequestWithURL:lastTradeUrl];
}

- (void)viewDidUnload
{
    [self setAccountNameLabel:nil];
    [self setSideLabel:nil];
    [self setQuantityLabel:nil];
    [self setCusipLabel:nil];
    [self setTypeLabel:nil];
    [self setTermLabel:nil];
    [self setAllOrNoneLabel:nil];
    [self setLimitPriceLabel:nil];
    [self setSpinner:nil];
    [self setLastTrade:nil];
    [self setEstValue:nil];
    [self setFee:nil];
    [self setTotalInclFee:nil];
    [self setOrderTypeLabel:nil];
    [self setLimitedPrice:nil];
    [self setTerm:nil];
    [self setAllOrNone:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - IBActions

- (IBAction)placeOrderBTNClicked:(id)sender {
    [spinner startAnimating];
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/orders"];

    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    [jsonDic setValue:order.brokerageAccountID forKey:@"brokerageAccountId"];
        
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc] init];
    [orderDic setValue:order.side forKey:@"side"];
    [orderDic setValue:[order.instrumentSymbol uppercaseString] forKey:@"symbol"];
    [orderDic setValue:order.quantity forKey:@"quantity"];
    [orderDic setValue:order.type forKey:@"type"];
    if ([order.term isEqualToString:@"Good for day"])
        [orderDic setValue:@"GoodForTheDay" forKey:@"term"];
    else
        [orderDic setValue:@"GoodTilCanceled" forKey:@"term"];
            
    if (order.allOrNone == YES) 
        [orderDic setValue:@"true" forKey:@"allOrNone"];
    else
        [orderDic setValue:@"false" forKey:@"allOrNone"];
        
    if ([order.type isEqualToString:@"Limit"]) {
        NSMutableDictionary *limitedOrderDic = [[NSMutableDictionary alloc] init];
        [limitedOrderDic setValue:order.limitPrice.amount forKey:@"amount"];
        [limitedOrderDic setValue:order.limitPrice.currency forKey:@"currency"];
        [orderDic setValue:limitedOrderDic forKey:@"limitPrice"];
    }

    [jsonDic setValue:orderDic forKey:@"orderParams"];

    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    
	NSString *responseData = [[NSString alloc] initWithData:jsonBodyData  encoding:NSMacOSRomanStringEncoding];
    BFDebugLog(@"jsonObject = %@", responseData);

    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
}

- (IBAction)cancelBTNClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - selectors for handling rest call callbacks


-(void)requestFailed:(NSError *)error
{       
    [spinner stopAnimating];
    
    NSString *errorString = @"Can't submit the trade order!";
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceeded:(NSData *)data
{
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    BFDebugLog(@"jsonObject = %@", jsonObject);

    [spinner stopAnimating];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRADE_ORDER_SUBMITTED" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:NULL];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.tabBarController.selectedIndex = 1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_TRANSACTIONS" object:nil];
}

-(void)estimateRequestFailed:(NSError *)error
{       
    [spinner stopAnimating];
    estValue.text =  @"NA";
    fee.text =  @"NA";
    totalInclFee.text =  @"NA";
}

-(void)estimateRequestSucceeded:(NSData *)data
{
    [spinner stopAnimating];
    BFOrderEstimate *estimate = [BFOrderEstimate estimateValueFromJSONData:data];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    estValue.text = [formatter stringFromNumber:estimate.estimatedValue.amount];
    fee.text = [formatter stringFromNumber:estimate.fees.amount];
    totalInclFee.text = [formatter stringFromNumber:estimate.estimatedValueIncFee.amount];
}

-(void)lastTradeRequestFailed:(NSError *)error
{       
    [spinner stopAnimating];
    lastTrade.text = @"NA";
    
}

-(void)lastTradeRequestSucceeded:(NSData *)data
{
    [spinner stopAnimating];
    BFMarketPrice *price = [BFMarketPrice marketPriceFromJSONData:data];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    lastTrade.text = [formatter stringFromNumber:price.price.amount];
}

@end
