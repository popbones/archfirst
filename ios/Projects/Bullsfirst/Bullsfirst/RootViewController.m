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
#import "WebServiceObject.h"
#import "AppDelegate.h"
#import "BFBrokerageAccountStore.h"
#import "BullFirstWebServiceObject.h"

@implementation RootViewController
@synthesize accountsViewController;
@synthesize restServiceObject;

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
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:accountsViewController];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    [viewControllers addObject:controller];    
    positionsViewController = [[PositionsViewController alloc] initWithNibName:@"PositionsViewController" bundle:nil];    
    controller = [[UINavigationController alloc] initWithRootViewController:positionsViewController];
    [viewControllers addObject:controller];
    ordersViewController= [[OrdersViewController alloc] initWithNibName:@"OrdersViewController" bundle:nil];
    controller = [[UINavigationController alloc] initWithRootViewController:ordersViewController];
    [viewControllers addObject:controller];
    transactionsViewController = [[TransactionsViewController alloc] initWithNibName:@"TransactionsViewController" bundle:nil];
    controller = [[UINavigationController alloc] initWithRootViewController:transactionsViewController];
    [viewControllers addObject:controller];
    [self setViewControllers:viewControllers];

    restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin:) name:@"USER_LOGIN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:@"USER_LOGOUT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin:) name:@"REFRESH_ACCOUNT" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USER_LOGIN" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USER_LOGOUT" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESH_ACCOUNT" object:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)retrieveAccountData
{
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
    NSString *errorString = [NSString stringWithString:@"Try Refreshing!"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceeded:(NSData *)data
{
    [[BFBrokerageAccountStore defaultStore] accountsFromJSONData:data];
}


#pragma mark MVC Delegate methods

-(void)userLogout:(NSNotification*)notification
{
    AppDelegate* appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.loginViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve]; 
    [self presentModalViewController: appDelegate.loginViewController animated:YES];
    [[BFBrokerageAccountStore defaultStore] clearAccounts];
}


-(void)userLogin:(NSNotification*)notification
{
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/brokerage_accounts"];
    [restServiceObject getRequestWithURL:url];    
}

/*
 #pragma mark tabBarController delegate methods

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [viewController viewDidAppear:YES];
    
}*/

@end
