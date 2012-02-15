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
#import "BFMoney.h"
#import "BFBrokerageAccountStore.h"
#import "AccountsTableViewController.h"
#import "AddAccountViewController.h"
#import "EditAccountNameViewController.h"
#import "PieChartMVAccountsViewController.h"
#import "PieChartMVPositionViewController.h"
#import "BullFirstWebServiceObject.h"
#import "AppDelegate.h"
#import "editAccountNameBTN.h"
#import "showPositionsBTN.h"
@implementation AccountsViewController

@synthesize toolbar,pieChartMVAccountsViewController,toolbarPortraitView;
@synthesize accountCell;
@synthesize accountNameLBL,accountNumberLBL,marketValueLBL,cashLBL,actionLBL;
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Bullsfirst";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
   
    pieChartMVAccountsViewController = [[PieChartMVAccountsViewController alloc] init];
    [pieChartMVAccountsViewController setView:pieChartMVAccountsView];
    [pieChartMVAccountsViewController setPieChartView:pieChartMVAccountsView];     
    pieChartMVAccountsViewController.delegate=self;
    CGRect chartRect= pieChartMVAccountsViewController.view.frame;
    pieChartMVAccountsViewController.view.frame = CGRectMake(chartRect.origin.x, chartRect.origin.y,420,613);
    
    pieChartMVPositionViewController = [[PieChartMVPositionViewController alloc] init];
    [pieChartMVPositionViewController setView:pieChartMVPositionView];
    [pieChartMVPositionViewController setPieChartView:pieChartMVPositionView];         
    pieChartMVPositionViewController.delegate=self;
    chartRect= pieChartMVPositionViewController.view.frame;
    pieChartMVPositionViewController.view.frame=CGRectMake(chartRect.origin.x, chartRect.origin.y,420,613);

    accountsTable.layer.borderWidth=1.0;
    
    accountsTable.layer.borderColor=[UIColor colorWithRed:(float)((0x272727&0xFF0000)/255.0) green:(float)((0x272727&0xFF00)/255.0) blue:(float)((0x272727&0xFF)/255.0) alpha:1.0].CGColor;

    orientation=[[UIDevice currentDevice] orientation];
   
    
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
        CGRect rect=accountsTable.frame;
        accountsTable.frame = CGRectMake(rect.origin.x, rect.origin.y,620,612);
        rect=accountNameLBL.frame;
        accountNameLBL.frame = CGRectMake(15, rect.origin.y, rect.size.width, rect.size.height);
        rect = accountNumberLBL.frame;
        accountNumberLBL.frame = CGRectMake(160, rect.origin.y, rect.size.width, rect.size.height);
        rect = marketValueLBL.frame;
        marketValueLBL.frame = CGRectMake(280, rect.origin.y, rect.size.width, rect.size.height);
        rect = cashLBL.frame;
        cashLBL.frame = CGRectMake(460, rect.origin.y, rect.size.width, rect.size.height);
        rect = actionLBL.frame;
        actionLBL.frame = CGRectMake(550, rect.origin.y, rect.size.width, rect.size.height);

    }
    else
    {
        CGRect rect=accountsTable.frame;
        
        accountsTable.frame = CGRectMake(rect.origin.x,rect.origin.y,766, 869); 
        rect=accountNameLBL.frame;
        accountNameLBL.frame = CGRectMake(20, rect.origin.y, rect.size.width, rect.size.height);
        rect = accountNumberLBL.frame;
        accountNumberLBL.frame = CGRectMake(180, rect.origin.y, rect.size.width, rect.size.height);
        rect = marketValueLBL.frame;
        marketValueLBL.frame = CGRectMake(370, rect.origin.y, rect.size.width, rect.size.height);
        rect = cashLBL.frame;
        cashLBL.frame = CGRectMake(590, rect.origin.y, rect.size.width, rect.size.height);
        rect = actionLBL.frame;
        actionLBL.frame = CGRectMake(700, rect.origin.y, rect.size.width, rect.size.height);
    }
    [accountsTable reloadData];
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
    [editAccountViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:editAccountViewController animated:YES];
    editAccountViewController.view.superview.bounds=CGRectMake(0, 0, 540,185);
    
}

#pragma mark - KVO lifecycle

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"accounts"]) {
        [accountsTable reloadData];
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
#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        return headerView;
    } else {
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    
    
    return [brokerageAccounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:indexPath.row];
    NSString *currencySymbol;
    if([account.marketValue.currency isEqual:@"USD"])
    {
        currencySymbol = @"$";
    }
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        UITableViewCell *cell;
        [[NSBundle mainBundle] loadNibNamed:@"AccountLandscapeTableViewCell" owner:self options:nil];
        cell = accountCell;
        /*
        */
        
        UILabel *label;
        label = (UILabel *)[cell viewWithTag:1];
        label.text = account.name;
        
        label = (UILabel *)[cell viewWithTag:2];
        label.text = [NSString stringWithFormat:@"%d", [account.brokerageAccountID intValue]];
        
        label = (UILabel *)[cell viewWithTag:3];
        label.text = [NSString stringWithFormat:@"%@%@", currencySymbol, account.marketValue.amount];

        label = (UILabel *)[cell viewWithTag:4];
        label.text = [NSString stringWithFormat:@"%@%@", currencySymbol, account.cashPosition.amount];
       
        editAccountNameBTN *edit = (editAccountNameBTN *)[cell viewWithTag:5]; // expand button
        [edit addTarget:self action:@selector(editAccount:) forControlEvents:UIControlEventTouchUpInside];
        edit.currentName=account.name;
        
        edit.accountID=[NSString stringWithFormat:@"%d", [account.brokerageAccountID intValue]];
                
        showPositionsBTN *arrowBTN = (showPositionsBTN *)[cell viewWithTag:6]; // expand button
        [arrowBTN addTarget:self action:@selector(showPositions:) forControlEvents:UIControlEventTouchUpInside];
        arrowBTN.positionIndex=indexPath.row;
        
              
        return cell;
    }
    else
    {
        UITableViewCell *cell;
        [[NSBundle mainBundle] loadNibNamed:@"AccountTableViewCell" owner:self options:nil];
        cell = accountCell;
              
        UILabel *label;
        label = (UILabel *)[cell viewWithTag:1];
        label.text = account.name;
        
        label = (UILabel *)[cell viewWithTag:2];
        label.text = [NSString stringWithFormat:@"%d", [account.brokerageAccountID intValue]];
        
        label = (UILabel *)[cell viewWithTag:3];
        label.text = [NSString stringWithFormat:@"%@%@", currencySymbol, account.marketValue.amount];
        
        
        label = (UILabel *)[cell viewWithTag:4];
        label.text = [NSString stringWithFormat:@"%@%@", currencySymbol, account.cashPosition.amount];
        
        editAccountNameBTN *edit = (editAccountNameBTN *)[cell viewWithTag:5]; // edit button
        [edit addTarget:self action:@selector(editAccount:) forControlEvents:UIControlEventTouchUpInside];
        edit.currentName=account.name;
        
        edit.accountID=[NSString stringWithFormat:@"%d", [account.brokerageAccountID intValue]];
        
        showPositionsBTN *arrowBTN = (showPositionsBTN *)[cell viewWithTag:6]; // showpostions button
        [arrowBTN addTarget:self action:@selector(showPositions:) forControlEvents:UIControlEventTouchUpInside];
        arrowBTN.positionIndex=indexPath.row;
        
        edit.accountID=[NSString stringWithFormat:@"%d", [account.brokerageAccountID intValue]];
        return cell;

    }
    
}
-(void)editAccount:(id)sender
{
    editAccountNameBTN *button = (editAccountNameBTN *)sender;
    EditAccountNameViewController *editAccountViewController = [[EditAccountNameViewController alloc] initWithNibName:@"EditAccountNameViewController" bundle:nil oldAccountName:button.currentName withId:button.accountID];    
    [editAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [editAccountViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:editAccountViewController animated:YES];
    editAccountViewController.view.superview.bounds=CGRectMake(0, 0, 540,185);
}
-(void)showPositions:(id)sender
{
    //self.tabBarController.selectedIndex=1
}
- (IBAction)backBTNClicked:(id)sender
{
    pieChartMVPositionViewController.view.hidden=true;
    pieChartMVAccountsViewController.view.hidden=false;
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
