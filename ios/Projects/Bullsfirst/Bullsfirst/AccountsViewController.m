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

@synthesize toolbar,pieChartMVAccountsViewController,portraitView,landscapeView,toolbarPortraitView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Bullsfirst";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = barButtonItem;

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
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate addObserver:self forKeyPath:@"accounts" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [appDelegate addObserver:self forKeyPath:@"currentUser" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate removeObserver:self forKeyPath:@"accounts"];
    [appDelegate removeObserver:self forKeyPath:@"currentUser"];
}
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice].systemVersion intValue] >= 5) {
        [self willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:0.1];
    }
    
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)createAccount:(id)sender
{
    AddAccountViewController *addAccountViewController = [[AddAccountViewController alloc] initWithNibName:@"AddAccountViewController" bundle:nil];
    [addAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    
   // [addAccountViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:addAccountViewController animated:YES];
    addAccountViewController.view.superview.bounds=CGRectMake(0, 0, 540,185);
    addAccountViewController.view.frame=CGRectMake(0, 0, 540,185);

    }

- (IBAction)refreshAccounts:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
}

- (IBAction)logout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGOUT" object:nil];
}

- (IBAction)userProfile
{
}


#pragma mark AccountsTableViewController Delegate methods


-(void) editingStartedForAccountWithName:(NSString *)accName withId:(NSString*) accId
{
    EditAccountNameViewController *editAccountViewController = [[EditAccountNameViewController alloc] initWithNibName:@"EditAccountNameViewController" bundle:nil oldAccountName:accName withId:accId];    
    [editAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [editAccountViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:editAccountViewController animated:YES];
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
    if ([keyPath isEqualToString:@"currentUser"]) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSString* fullName=[appDelegate.currentUser.firstName stringByAppendingString:@" "];
        fullName=[fullName stringByAppendingString:appDelegate.currentUser.lastName];
        fullName=[fullName uppercaseString];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:fullName style:UIBarButtonItemStylePlain target:self action:@selector(userProfile)];
        self.navigationItem.leftBarButtonItem = barButtonItem;

        return;
    }
}

@end
