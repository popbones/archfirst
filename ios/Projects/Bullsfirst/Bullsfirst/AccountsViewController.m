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


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void) viewDidAppear:(BOOL)animated
{
    if(selectedRow!=-1)
    {
        orientation=[[UIDevice currentDevice] orientation];
        [accountsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        UITableViewCell* cell=[accountsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
        UIButton *editButton = (UIButton *)[cell viewWithTag:5];
        editButton.highlighted = NO;
    }
    [super viewDidAppear:animated];
    
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 268.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
    // anyone know how to get it perfect?
    tools.barStyle = -1; // clear background
    tools.contentMode = UIViewContentModeCenter;
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStylePlain;
    barButtonItem.tintColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    [buttons addObject:barButtonItem];
    
    // Create a spacer.
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barButtonItem.width = 30.0f;
        [buttons addObject:barButtonItem];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"HeaderBar_Transfer.png"] style:UIBarButtonItemStylePlain target:self action:@selector(transferBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStylePlain;
    barButtonItem.tintColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    [buttons addObject:barButtonItem];
    
    // Create a spacer.
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barButtonItem.width = 30.0f;
    [buttons addObject:barButtonItem];
    
    
    barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"HeaderBar_Trade.png"] style:UIBarButtonItemStylePlain target:self action:@selector(tradeBTNClicked:)];
    
    barButtonItem.style = UIBarButtonItemStylePlain;
    barButtonItem.tintColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    [buttons addObject:barButtonItem];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barButtonItem.width = 30.0f;
    [buttons addObject:barButtonItem];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshBTNClicked:)];
    
    barButtonItem.style = UIBarButtonItemStylePlain;
    barButtonItem.tintColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    [buttons addObject:barButtonItem];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barButtonItem.width = 30.0f;
    [buttons addObject:barButtonItem];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HeaderBar_Settings.png"] style:UIBarButtonItemStyleBordered target:(id)self action:@selector(logout)];
    barButtonItem.style = UIBarButtonItemStylePlain;
    barButtonItem.tintColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    [buttons addObject:barButtonItem];
    
    [tools setItems:buttons animated:NO];
    UIBarButtonItem *titleButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem = titleButtons;

    barButtonItem = [[UIBarButtonItem alloc] init];
	barButtonItem.title = @"Accounts";
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
	self.navigationItem.backBarButtonItem = barButtonItem;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = label;
    label.text = @"Accounts";
    label.textColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    [label sizeToFit];
    backBTN.hidden = YES;
    
    selectedRow=-1;
    
    pieChartViewController = [[PieChartViewController alloc] init];
    [pieChartViewController setView:chartView];
    [pieChartViewController setPieChartView:pieChartView];
    rightBorderView.layer.backgroundColor=[UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1].CGColor;
    leftBorderView.layer.backgroundColor=[UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1].CGColor;    orientation=[[UIDevice currentDevice] orientation];
    
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate addObserver:self forKeyPath:@"accounts" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [pieChartViewController addObserver:self forKeyPath:@"currentChart" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [pieChartViewController viewDidLoad];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    accountCell=[tableView cellForRowAtIndexPath:indexPath];
    UIButton *editButton = (UIButton *)[accountCell viewWithTag:5];
    editButton.highlighted = NO;
    PositionsViewController *controller = [[PositionsViewController alloc] initWithNibName:@"PositionsViewController" bundle:nil account:indexPath.row];    
    selectedRow = indexPath.row;
    [self.navigationController pushViewController:controller animated:YES];
    
}


@end
