//
//  tradePreviewViewController.m
//  Bullsfirst
//
//  Created by Pong Choa on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
    self.quantityLabel.text = [NSString stringWithFormat:@"%d", [order.quantity intValue]];
    self.typeLabel.text = order.type;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    if ([order.type isEqualToString:@"Limit"])
        self.limitPriceLabel.text = [formatter stringFromNumber:order.limitPrice.amount];
    else
        self.limitPriceLabel.text = @"";
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
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - selectors for handling rest call callbacks


-(void)requestFailed:(NSError *)error
{       
    [spinner stopAnimating];
    
    NSString *errorString = [NSString stringWithString:@"Can't submit the trade order!"];
    
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
    
    [self dismissModalViewControllerAnimated:YES];

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
