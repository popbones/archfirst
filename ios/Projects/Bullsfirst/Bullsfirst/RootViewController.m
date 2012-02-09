//
//  RootViewController.h
//  Bullsfirst
//
//  Created by Subramanian R
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

#import "RootViewController.h"
#import "BFToolbar.h"
#import "WebServiceObject.h"
@implementation RootViewController
@synthesize accountsViewController;
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
    BFToolbar *toolBar = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    [toolBar setTbc:self];
    [accountsViewController setToolbar:toolBar]; 
    
    toolBar = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    CGRect frame= toolBar.view.frame;
    frame.size.width=768;
    toolBar.view.frame=frame;
    [toolBar setTbc:self];
    [accountsViewController setToolbarPortraitView:toolBar]; 

    
    positionsViewController = [[PositionsViewController alloc] init];
    toolBar = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    [toolBar setTbc:self];
    [positionsViewController setToolbar:toolBar]; [[positionsViewController view] addSubview:[toolBar view]];
    [[positionsViewController view] bringSubviewToFront:[toolBar view]];
    
    
    ordersViewController= [[OrdersViewController alloc] init];
    toolBar = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    [toolBar setTbc:self];
    [ordersViewController setToolbar:toolBar]; [[ordersViewController view] addSubview:[toolBar view]];
    [[ordersViewController view] bringSubviewToFront:[toolBar view]];
    
    
    transactionsViewController = [[TransactionsViewController alloc] init];
    toolBar = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    [toolBar setTbc:self];
    [transactionsViewController setToolbar:toolBar]; [[transactionsViewController view] addSubview:[toolBar view]];
    [[transactionsViewController view] bringSubviewToFront:[toolBar view]];

    NSArray *viewControllers = [NSArray arrayWithObjects:accountsViewController,positionsViewController,ordersViewController,transactionsViewController, nil];
    
    
    
    
    [self setViewControllers:viewControllers];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) loggedin:(NSString *)fullName
{
    [accountsViewController retrieveAccountData];
   
    accountsViewController.toolbar.userName.text=fullName;
    accountsViewController.toolbarPortraitView.userName.text=fullName;
    // accountsViewController.pieChartMVAccountsViewController.view.hidden=FALSE;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
/*
 #pragma mark tabBarController delegate methods

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [viewController viewDidAppear:YES];
    
}*/

@end
