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
#import "BullFirstWebServiceObject.h"
#import "AppDelegate.h"
#import "editAccountNameBTN.h"
#import "PositionsViewController.h"
#import "UserViewController.h"

@implementation AccountsViewController

@synthesize accountCell;
@synthesize accountNameLBL,accountNumberLBL,marketValueLBL,cashLBL,actionLBL;

@synthesize userPopOver;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Accounts"];
        UIImage *i = [UIImage imageNamed:@"TabBar_Accounts.png"];
        [tbi setImage:i];                
    }
    
    return self;
}
//-(void) pieChartMVPositionClicked
//{
//    positionsChartView.hidden=true;
//    //pieChartMVAccountsViewController.view.hidden=false;
//}
//
//-(void) pieChartMVAccountsClicked:(int) onIndex
//{
//    pieChartMVPositionViewController.accountIndex=onIndex;
//    [pieChartMVPositionViewController constructPieChart];
//    pieChartMVAccountsViewController.view.hidden=true;
//    positionsChartView.hidden=false;
//    
//}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [pieChartMVPositionViewController viewDidAppear:animated];
//    [pieChartMVAccountsViewController viewDidAppear:animated];
     
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [pieChartMVPositionViewController viewDidDisappear:animated];
//    [pieChartMVAccountsViewController viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
	barButtonItem.title = @"Accounts";
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
	self.navigationItem.backBarButtonItem = barButtonItem;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = @"Accounts";
    [label sizeToFit];
    backBTN.hidden = YES;

    pieChartViewController = [[PieChartViewController alloc] init];
    [pieChartViewController setView:chartView];
    [pieChartViewController setPieChartView:pieChartView];
    //[pieChartMVAccountsViewController setView:pieChartMVAccountsView];
    //[pieChartMVAccountsViewController setPieChartView:pieChartMVAccountsView];     
    //pieChartMVAccountsViewController.delegate=self;
    
//    pieChartMVPositionViewController = [[PieChartMVPositionViewController alloc] init];
//    [pieChartMVPositionViewController setView:pieChartMVPositionView];
//    [pieChartMVPositionViewController setPieChartView:pieChartMVPositionView];         
//    pieChartMVPositionViewController.delegate=self;
    
//    positionsChartView.hidden=true;
//    pieChartMVAccountsViewController.view.hidden=false;
    rightBorderView.layer.backgroundColor=[UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1].CGColor;
    leftBorderView.layer.backgroundColor=[UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1].CGColor;    orientation=[[UIDevice currentDevice] orientation];
    
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate addObserver:self forKeyPath:@"accounts" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:@"USER_LOGOUT" object:nil];
    
    [pieChartViewController addObserver:self forKeyPath:@"currentChart" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate removeObserver:self forKeyPath:@"accounts"];
    
    [pieChartViewController removeObserver:self forKeyPath:@"currentChart"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USER_LOGOUT" object:nil];
    
}
//initialze brokerage accounts
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation==UIDeviceOrientationLandscapeRight||toInterfaceOrientation==UIDeviceOrientationLandscapeLeft)
    {
        CGRect rect=accountsTable.frame;
        accountsTable.frame = CGRectMake(rect.origin.x, rect.origin.y,620,699-44);
        rect=accountNameLBL.frame;
        accountNameLBL.frame = CGRectMake(20, rect.origin.y, rect.size.width, rect.size.height);
        rect = accountNumberLBL.frame;
        accountNumberLBL.frame = CGRectMake(180, rect.origin.y, rect.size.width, rect.size.height);
        rect = marketValueLBL.frame;
        marketValueLBL.frame = CGRectMake(280, rect.origin.y, rect.size.width, rect.size.height);
        rect = cashLBL.frame;
        cashLBL.frame = CGRectMake(446, rect.origin.y, rect.size.width, rect.size.height);
        rect = actionLBL.frame;
        actionLBL.frame = CGRectMake(554, rect.origin.y, rect.size.width, rect.size.height);
        rect=leftBorderView.frame;
        leftBorderView.frame=CGRectMake(rect.origin.x, rect.origin.y,1,699);
        rect=rightBorderView.frame;
        rightBorderView.frame=CGRectMake(1023, 0,1,699);
    }
    else
    {
        CGRect rect=accountsTable.frame;
        
        accountsTable.frame = CGRectMake(rect.origin.x,rect.origin.y,766, 920); 
        rect=accountNameLBL.frame;
        accountNameLBL.frame = CGRectMake(20, rect.origin.y, rect.size.width, rect.size.height);
        rect = accountNumberLBL.frame;
        accountNumberLBL.frame = CGRectMake(230, rect.origin.y, rect.size.width, rect.size.height);
        rect = marketValueLBL.frame;
        marketValueLBL.frame = CGRectMake(360, rect.origin.y, rect.size.width, rect.size.height);
        rect = cashLBL.frame;
        cashLBL.frame = CGRectMake(560, rect.origin.y, rect.size.width, rect.size.height);
        rect = actionLBL.frame;
        actionLBL.frame = CGRectMake(680, rect.origin.y, rect.size.width, rect.size.height);
        rect=leftBorderView.frame;
        leftBorderView.frame=CGRectMake(rect.origin.x, rect.origin.y,1,920);
        rect=rightBorderView.frame;
        rightBorderView.frame=CGRectMake(767, 0, 1, 920);
    }
    [accountsTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice].systemVersion intValue] >= 5) {
        [self willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:0.1];
    }
    return YES;
}

- (IBAction)createAccount:(id)sender
{
    AddAccountViewController *addAccountViewController = [[AddAccountViewController alloc] initWithNibName:@"AddAccountViewController" bundle:nil];
    [addAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentModalViewController:addAccountViewController animated:YES];
    addAccountViewController.view.superview.bounds=CGRectMake(0, 0, 500,235);
    //addAccountViewController.view.frame=CGRectMake(0, 0, 500,235);

    }

- (IBAction)filterBTNClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
}

- (IBAction)userProfile
{
}


//#pragma mark AccountsTableViewController Delegate methods
//
//
//-(void) editingStartedForAccountWithName:(NSString *)accName withId:(NSString*) accId
//{
//    EditAccountNameViewController *editAccountViewController = [[EditAccountNameViewController alloc] initWithNibName:@"EditAccountNameViewController" bundle:nil oldAccountName:accName withId:accId];    
//    [editAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
//    [editAccountViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    
//    [self presentModalViewController:editAccountViewController animated:YES];
//    editAccountViewController.view.superview.frame=CGRectMake(0, 0, 488,250);
//    
//}

#pragma mark - KVO lifecycle

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"accounts"]) 
    {
        NSMutableArray *brokerageAccounts = (NSMutableArray*)[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
        if ([brokerageAccounts count] > 0) 
        {
            [accountsTable reloadData];
            [pieChartViewController constructPieChart];
            //[pieChartMVPositionViewController constructPieChart];
        }
        return;
    }
    if([keyPath isEqualToString:@"currentChart"])
    {
        if([[change objectForKey:NSKeyValueChangeNewKey] intValue] == AccountsChart)
        {
            backBTN.hidden = YES;
        }
        else
        {
            backBTN.hidden = NO;
        }
    }
    
}
#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    headerView.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSMutableArray *brokerageAccounts = (NSMutableArray*)[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    return [brokerageAccounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *brokerageAccounts = (NSMutableArray*)[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    if ([brokerageAccounts count] < 1) {
        UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
        {
            UITableViewCell *cell;
            [[NSBundle mainBundle] loadNibNamed:@"AccountLandscapeTableViewCell" owner:self options:nil];
            cell = accountCell;
            return cell;
        }
        else
        {
            UITableViewCell *cell;
            [[NSBundle mainBundle] loadNibNamed:@"AccountTableViewCell" owner:self options:nil];
            cell = accountCell;
            return cell;
        }
    }
    
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
        
        UIView *selected = [[UIView alloc] initWithFrame:cell.contentView.frame];
        selected.backgroundColor=[UIColor colorWithRed:255/255.0 green:237/255.0 blue:184/255.0 alpha:1];
        cell.selectedBackgroundView = selected;
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
        edit.index=(NSInteger*)indexPath.row;

        UIView *selected = [[UIView alloc] initWithFrame:cell.contentView.frame];
        selected.backgroundColor=[UIColor colorWithRed:255/255.0 green:237/255.0 blue:184/255.0 alpha:1];
        cell.selectedBackgroundView = selected;
        return cell;

    }
    
}

-(void) selectionChanged:(id)sender
{
    }

-(void)editAccount:(id)sender
{
    editAccountNameBTN *button = (editAccountNameBTN *)sender;
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(NSInteger)button.index inSection:0];
//    [accountsTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];

   EditAccountNameViewController *editAccountViewController = [[EditAccountNameViewController alloc] initWithNibName:@"EditAccountNameViewController" bundle:nil oldAccountName:button.currentName withId:button.accountID];    
    [editAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [editAccountViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:editAccountViewController animated:YES];
    editAccountViewController.view.superview.bounds=CGRectMake(0, 0, 488,250);
}


- (IBAction)backBTNClicked:(id)sender
{
    [pieChartViewController backBTNClicked];
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
    accountCell=[tableView cellForRowAtIndexPath:indexPath];
    PositionsViewController *controller = [[PositionsViewController alloc] initWithNibName:@"PositionsViewController" bundle:nil account:indexPath.row];    
    [self.navigationController pushViewController:controller animated:YES];
    
}
#pragma mark MVC Delegate methods

-(void)userLogout:(NSNotification*)notification
{
//    [pieChartMVAccountsViewController clearPieChart];
//    [pieChartMVPositionViewController clearPieChart];
//    pieChartMVPositionViewController.view.hidden=true;
//    pieChartMVAccountsView.hidden=false;
    [pieChartViewController clearPieChart];
}

@end
