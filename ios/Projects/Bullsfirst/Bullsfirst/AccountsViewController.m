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
#import "PieChartMVAccountsViewController.h"
#import "PieChartMVPositionViewController.h"
#import "BullFirstWebServiceObject.h"
#import "AppDelegate.h"

@implementation AccountsViewController

@synthesize toolbar,restServiceObject,pieChartMVAccountsViewController,portraitView,landscapeView,toolbarPortraitView;

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
    pieChartMVPositionViewController.view.hidden=true;
    pieChartMVAccountsViewController.view.hidden=false;
}
-(void) clearCurrentView
{
if(landscapeView.superview)
    {
        [landscapeView removeFromSuperview];
    }
    else
    {
        [portraitView removeFromSuperview];
    }
}
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation==UIDeviceOrientationLandscapeRight||toInterfaceOrientation==UIDeviceOrientationLandscapeLeft)
    {
        [self clearCurrentView];
        [landscapeView addSubview:toolbar.view];
        [landscapeView bringSubviewToFront:toolbar.view];
        [self.view insertSubview:landscapeView atIndex:0];
    }
    else
    {
        [self clearCurrentView];
        [portraitView addSubview:toolbarPortraitView.view];
        [portraitView bringSubviewToFront:toolbarPortraitView.view];
        [self.view insertSubview:portraitView atIndex:0];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];
    
    accountsTableViewController = [[AccountsTableViewController alloc] init];
    [accountsTableViewController setView:accountsTable];
    [accountsTableViewController setDelegate:self];
    [accountsTable setDelegate:accountsTableViewController];
    [accountsTable setDataSource:accountsTableViewController];    
    
    
    accountsTablePortraitViewController = [[AccountsTableViewController alloc] init];
    [accountsTablePortraitViewController setView:accountsTablePortraitView];
    [accountsTablePortraitViewController setDelegate:self];
    [accountsTablePortraitView setDelegate:accountsTablePortraitViewController];
    [accountsTablePortraitView setDataSource:accountsTablePortraitViewController];
    
    
    pieChartMVAccountsViewController = [[PieChartMVAccountsViewController alloc] init];
    [pieChartMVAccountsViewController setView:pieChartMVAccountsView];
    [pieChartMVAccountsViewController setPieChartView:pieChartMVAccountsView];     
    pieChartMVAccountsViewController.delegate=self;
    pieChartMVPositionViewController = [[PieChartMVPositionViewController alloc] init];
    [pieChartMVPositionViewController setView:pieChartMVPositionView];
    [pieChartMVPositionViewController setPieChartView:pieChartMVPositionView];         
    pieChartMVPositionViewController.delegate=self;
   
    
    [[self view] bringSubviewToFront:accountsPlotLabel];
    [[self view] bringSubviewToFront:positionPlotLabel];
    orientation=[[UIDevice currentDevice] orientation];
    if(orientation==UIDeviceOrientationUnknown||orientation==UIDeviceOrientationFaceDown||orientation==UIDeviceOrientationFaceUp)
    {
        orientation=UIDeviceOrientationPortrait;
        [self clearCurrentView];
        [portraitView addSubview:toolbarPortraitView.view];
        [portraitView bringSubviewToFront:toolbarPortraitView.view];
        
        [self.view insertSubview:portraitView atIndex:0];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin:) name:@"USER_LOGIN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:@"USER_LOGOUT" object:nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate addObserver:self forKeyPath:@"accounts" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USER_LOGIN" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USER_LOGOUT" object:nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate removeObserver:self forKeyPath:@"accounts"];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return YES;
}

#pragma mark - Methods

- (void)retrieveAccountData
{
    [spinner startAnimating];
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

-(void) clearViewData
{
    [[BFBrokerageAccountStore defaultStore] clearAccounts];
    /*
    [accountsTable reloadData];
    [accountsTablePortraitView reloadData];
    [pieChartMVAccountsViewController constructPieChart];
    [pieChartMVPositionViewController constructPieChart];
*/
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
    
   NSString *errorString = [NSString stringWithString:@"Try Refreshing!"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceeded:(NSData *)data
{
    [spinner stopAnimating];
    [[BFBrokerageAccountStore defaultStore] accountsFromJSONData:data];

}

#pragma mark AccountsTableViewController Delegate methods


-(void) editingStartedForAccountWithName:(NSString *)accName withId:(NSString*) accId
{
    EditAccountNameViewController *editAccountViewController = [[EditAccountNameViewController alloc] initWithNibName:@"EditAccountNameViewController" bundle:nil oldAccountName:accName withId:accId];
    [editAccountViewController setAvc:self];
    
    [editAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [editAccountViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:editAccountViewController animated:YES];
}

#pragma mark MVC Delegate methods

-(void)userLogout:(NSNotification*)notification
{
    [[BFBrokerageAccountStore defaultStore] clearAccounts];
}


-(void)userLogin:(NSNotification*)notification
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [self retrieveAccountData];

    NSString* fullName=[appDelegate.currentUser.firstName stringByAppendingString:@" "];
    fullName=[fullName stringByAppendingString:appDelegate.currentUser.lastName];
    fullName=[fullName uppercaseString];

    self.toolbar.userName.text=fullName;
    self.toolbarPortraitView.userName.text=fullName;
}

#pragma mark - KVO lifecycle

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"accounts"]) {
        [accountsTable reloadData];
        [accountsTablePortraitView reloadData];
        [pieChartMVAccountsViewController constructPieChart];
        [pieChartMVPositionViewController constructPieChart];
        return;
    }
    
}

@end
