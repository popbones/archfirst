//
//  AccountsViewController.m
//  Bullsfirst
//
//  Created by Joe Howard
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

#import "AccountsViewController.h"
#import "BFBrokerageAccount.h"
#import "BFBrokerageAccountStore.h"
#import "AccountsTableViewController.h"
#import "AddAccountViewController.h"
#import "EditAccountNameViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "PieChartMVAccountsViewController.h"
#import "PieChartMVPositionViewController.h"
#import "BullFirstWebServiceObject.h"

@implementation AccountsViewController

@synthesize toolbar,restServiceObject,pieChartMVAccountsViewController;

//- (id)init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Accounts"];
        UIImage *i = [UIImage imageNamed:@"iconAccounts.png"];
        [tbi setImage:i];                
    }
    
    return self;
}
-(void) pieChartMVPositionClicked
{
    pieChartMVPositionViewController.view.hidden=true;
    pieChartMVAccountsViewController.view.hidden=false;
}
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}
*/
-(void) pieChartMVAccountsClicked:(int) onIndex
{
    pieChartMVPositionViewController.accountIndex=onIndex;
    [pieChartMVPositionViewController constructPieChart];
    pieChartMVAccountsViewController.view.hidden=true;
    pieChartMVPositionViewController.view.hidden=false;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [pieChartMVPositionViewController viewDidAppear:animated];
    [pieChartMVAccountsViewController viewDidAppear:animated];
    [headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_bg_yellow.png"]]];
    
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [pieChartMVPositionViewController viewDidDisappear:animated];
    [pieChartMVAccountsViewController viewDidDisappear:animated];
}
-(void) viewWillAppear:(BOOL)animated
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [spinner startAnimating];
    accountsTableViewController = [[AccountsTableViewController alloc] init];
    [accountsTableViewController setView:accountsTable];
    [accountsTableViewController setDelegate:self];
    [accountsTable setDelegate:accountsTableViewController];
    [accountsTable setDataSource:accountsTableViewController];    
    
    pieChartMVAccountsViewController = [[PieChartMVAccountsViewController alloc] init];
    [pieChartMVAccountsViewController setView:pieChartMVAccountsView];
    [pieChartMVAccountsViewController setPieChartView:pieChartMVAccountsView];     
    pieChartMVAccountsViewController.delegate=self;
    pieChartMVPositionViewController = [[PieChartMVPositionViewController alloc] init];
    [pieChartMVPositionViewController setView:pieChartMVPositionView];
    [pieChartMVPositionViewController setPieChartView:pieChartMVPositionView];         
    pieChartMVPositionViewController.delegate=self;
   // [self retrieveAccountData]; 
    
    [[self view] bringSubviewToFront:accountsPlotLabel];
    [[self view] bringSubviewToFront:positionPlotLabel];

    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Methods

- (void)retrieveAccountData
{
    [spinner startAnimating];
    
    restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/brokerage_accounts"];
    [restServiceObject getRequestWithURL:url];    
}

- (IBAction)createAccount:(id)sender
{
    AddAccountViewController *addAccountViewController = [[AddAccountViewController alloc] initWithNibName:@"AddAccountViewController" bundle:nil];
    [addAccountViewController setAvc:self];
    
    [addAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [addAccountViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:addAccountViewController animated:YES];
}

- (IBAction)refreshAccounts:(id)sender
{
    [[BFBrokerageAccountStore defaultStore] clearAccounts];
    [self retrieveAccountData];
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
    urlConnection = nil;
    jsonResponseData = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceeded:(NSData *)data
{
    [spinner stopAnimating];
    jsonResponseData = [NSMutableData dataWithData:data];
    
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonResponseData options:0 error:&err];
    BFDebugLog(@"jsonObject = %@", jsonObject);
    
    if([jsonObject isEqual:[NSNull null]] || (jsonObject == nil))
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"Please logout and try again"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        
        return;        
    }
    
    
    
    // Ingest the JSON data
    for(NSDictionary *theAccount in jsonObject)
    {
        BFBrokerageAccount *brokerageAccount = [BFBrokerageAccount accountFromDictionary:theAccount];
        [[BFBrokerageAccountStore defaultStore] addBrokerageAccount:brokerageAccount];
    }
    
    NSLog(@"count = %d", [[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts] count]);
    
    [accountsTable reloadData];
    [pieChartMVAccountsViewController constructPieChart];
    [pieChartMVPositionViewController constructPieChart];
    
    
    
}
#pragma mark AccountsTableViewController Delegate methods


-(void) editingStartedForAccountWithName:(NSString *)accName
{
    EditAccountNameViewController *editAccountViewController = [[EditAccountNameViewController alloc] initWithNibName:@"EditAccountNameViewController" bundle:nil oldAccountName:accName];
    [editAccountViewController setAvc:self];
    
    [editAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [editAccountViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:editAccountViewController animated:YES];
}


@end
