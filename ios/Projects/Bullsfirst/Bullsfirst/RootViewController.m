//
//  RootController.m
//  Bullsfirst
//
//  Created by suravi on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "BFToolbar.h"
@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    // Do any additional setup after loading the view from its nib.
    self.delegate=self;
    accountsViewController = [[AccountsViewController alloc] initWithNibName:@"AccountsViewController" bundle:nil];
    positionsViewController = [[PositionsViewController alloc] init];
    ordersViewController= [[OrdersViewController alloc] init];
    transactionsViewController = [[TransactionsViewController alloc] init];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:accountsViewController,positionsViewController,ordersViewController,transactionsViewController, nil];
    
    // NOTE: Would rather only have one instance of BFToolbar; use one per tab for now
    BFToolbar *toolBar1 = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    BFToolbar *toolBar2 = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    BFToolbar *toolBar3 = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    BFToolbar *toolBar4 = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    
   //[toolBar1 setLvc:self]; 
    [toolBar1 setTbc:self];
    //[toolBar2 setLvc:self]; 
    
    [toolBar2 setTbc:self];
    //[toolBar3 setLvc:self]; 
    [toolBar3 setTbc:self];
    //[toolBar4 setLvc:self];
    [toolBar4 setTbc:self];
    
    // Need to take ownership of toolbars; adding it to the view is not enough
    [accountsViewController setToolbar:toolBar1]; [[accountsViewController view] addSubview:[toolBar1 view]];
    [positionsViewController setToolbar:toolBar2]; [[positionsViewController view] addSubview:[toolBar2 view]];
    [ordersViewController setToolbar:toolBar3]; [[ordersViewController view] addSubview:[toolBar3 view]];
    [transactionsViewController setToolbar:toolBar4]; [[transactionsViewController view] addSubview:[toolBar4 view]];
    
    [[accountsViewController view] bringSubviewToFront:[toolBar1 view]];
    [[positionsViewController view] bringSubviewToFront:[toolBar2 view]];
    [[ordersViewController view] bringSubviewToFront:[toolBar3 view]];
    [[transactionsViewController view] bringSubviewToFront:[toolBar4 view]];

    [self setViewControllers:viewControllers];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) loggedin
{
    [accountsViewController retrieveAccountData];
   // accountsViewController.pieChartMVAccountsViewController.view.hidden=FALSE;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
