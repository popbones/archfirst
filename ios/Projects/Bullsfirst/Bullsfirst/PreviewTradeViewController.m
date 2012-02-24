//
//  tradePreviewViewController.m
//  Bullsfirst
//
//  Created by Pong Choa on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PreviewTradeViewController.h"

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

@synthesize restServiceObject;

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
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    self.accountNameLabel.text = order.accountName;
    self.sideLabel.text = order.side;
    self.cusipLabel.text = order.instrumentSymbol;
    self.quantityLabel.text = [NSString stringWithFormat:@"%d share", [order.quantity intValue]];
    self.typeLabel.text = order.type;
    if ([order.type isEqualToString:@"Limited"])
        self.limitPriceLabel.text = [NSString stringWithFormat:@"$%d", [order.limitPrice.amount intValue]];
    else
        self.limitPriceLabel.text = @"";
    self.termLabel.text = order.term;
    if (order.allOrNone == YES)
        allOrNoneLabel.text = @"All or None";
    else
        allOrNoneLabel.text = @"";

    [spinner stopAnimating];
    restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self 
                                                        responseSelector:@selector(responseReceived:) 
                                                     receiveDataSelector:@selector(receivedData:) 
                                                         successSelector:@selector(requestSucceeded:) 
                                                           errorSelector:@selector(requestFailed:)];

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
    [self.restServiceObject getRequestWithURL:url];    
}

- (IBAction)cancelBTNClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - selectors for handling rest call callbacks

-(void)receivedData:(NSData *)data
{
    
}

-(void)responseReceived:(NSURLResponse *)data
{
    
}

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
}

@end
