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
    toolBar.tbc=self;
    accountsViewController.toolbar=toolBar; 
    [accountsViewController.view addSubview:toolBar.view];
    [accountsViewController.view bringSubviewToFront:toolBar.view];
    
    positionsViewController = [[PositionsViewController alloc] initWithNibName:@"PositionsViewController" bundle:nil];
    toolBar = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    toolBar.tbc=self;
    positionsViewController.toolbar=toolBar; 
    [positionsViewController.view addSubview:toolBar.view];
    [positionsViewController.view bringSubviewToFront:toolBar.view];
    
    ordersViewController= [[OrdersViewController alloc] initWithNibName:@"OrdersViewController" bundle:nil];
    toolBar = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    toolBar.tbc=self;
    ordersViewController.toolbar=toolBar; 
    [ordersViewController.view addSubview:toolBar.view];
    [ordersViewController.view bringSubviewToFront:toolBar.view];
    
    transactionsViewController = [[TransactionsViewController alloc] initWithNibName:@"TransactionsViewController" bundle:nil];
    toolBar = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    toolBar.tbc=self;
    transactionsViewController.toolbar=toolBar; 
    [transactionsViewController.view addSubview:toolBar.view];
    [transactionsViewController.view bringSubviewToFront:toolBar.view];
    
    [self setViewControllers:[NSArray arrayWithObjects:accountsViewController,positionsViewController,ordersViewController,transactionsViewController, nil]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
