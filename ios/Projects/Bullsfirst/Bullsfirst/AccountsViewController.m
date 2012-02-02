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


@implementation AccountsViewController

@synthesize toolbar;

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
    
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [pieChartMVPositionViewController viewDidDisappear:animated];
    [pieChartMVAccountsViewController viewDidDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [spinner startAnimating];

    [headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_bg_yellow.png"]]];
    
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
    [self retrieveAccountData]; 
    
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
    jsonResponseData = [[NSMutableData alloc] init];
    [spinner startAnimating];
    
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/brokerage_accounts"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kRequestTimeout];
    
    [req setHTTPMethod:@"GET"]; // default
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    
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

#pragma mark - NSURLCollectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{    
    [jsonResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSString *jsonCheck = [[NSString alloc] initWithData:jsonResponseData encoding:NSUTF8StringEncoding];    
    //BFDebugLog(@"jsonCheck = %@", jsonCheck);
    
    // TODO: Handle error conditions and timeout
    
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
        [spinner stopAnimating];
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
    
    [spinner stopAnimating];    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    urlConnection = nil;
    jsonResponseData = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}


 - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    BFDebugLog(@"challenge");

    if([challenge previousFailureCount] > 0) {        
        NSError *failure = [challenge error];
        BFErrorLog(@"Can't authenticate: %@", [failure localizedDescription]);

        [[challenge sender] cancelAuthenticationChallenge:challenge];
        return;
    }

    NSURLCredential *newCred = [NSURLCredential credentialWithUser:[[NSUserDefaults standardUserDefaults] valueForKey:kUsername]
                                                          password:[[NSUserDefaults standardUserDefaults] valueForKey:kPassword]
                                                       persistence:NSURLCredentialPersistenceNone];

    // Supply the credential to the sender of the challenge
    [[challenge sender] useCredential:newCred forAuthenticationChallenge:challenge];
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
