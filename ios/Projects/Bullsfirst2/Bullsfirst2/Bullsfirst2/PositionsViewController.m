//
//  PositionsViewController.m
//  Bullsfirst
//
//  Created by Joe Howard
//  Edited by Rashmi Garg - changes for storyboard and Bullsfirst2 design
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

#import "PositionsDetailViewController.h"
#import "PositionsSecurityTableViewCell.h"
#import "PositionsViewController.h"
#import "AppDelegate.h"
#import "BFBrokerageAccountStore.h"
#import "BFBrokerageAccount.h"
#import "BFPosition.h"
#import "BFMoney.h"
#import "tradePositionBTN.h"
#import "expandPositionBTN.h"
#import "TradeViewController.h"
#import "PositionTableViewCell.h"
#import "EditAccountNameViewController.h"

@implementation PositionsViewController

@synthesize positionTBL;
@synthesize positionCell;
@synthesize selectedAccount;
@synthesize selectedSubAccount;
@synthesize selectedSecurity;
@synthesize portraitTitleBar;
@synthesize landscrapeTitleBar;
@synthesize expanedRowSet;
@synthesize editButton;
@synthesize totalCostLabel, totalGainLabel, totalMarketValueLabel, accountNameLabel;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Positions"];
        UIImage *i = [UIImage imageNamed:@"TabBar_Positions.png"];
        [tbi setImage:i];        
    }
    
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil account:(int)account
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedAccount = account;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    if([brokerageAccounts count] >0 && selectedAccount > -1)
    {
    BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];
    
    self.accountNameLabel.text = account.name;
    
    if ([account.positions count] > 0)
    {
        int totalCost=0, totalMarketValue=0, gain = 0;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setMaximumFractionDigits:0];
        [formatter setMinimumFractionDigits:0];
        for(int i=0; i < [account.positions count]; i++)
        {
            BFPosition *position = [account.positions objectAtIndex:i];
            
            totalMarketValue += [position.marketValue.amount integerValue];
            totalCost += [position.totalCost.amount integerValue];
        }
        NSLog(@"total market value is %d", totalMarketValue);
        gain = totalMarketValue - totalCost;
        self.totalMarketValueLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:totalMarketValue]];
        self.totalCostLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:totalCost]];
        
        
        self.totalGainLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:gain]];
    }
    
    
    NSLog(@"in PositionsViewController account selecetd is %d",self.selectedAccount );
    positionTBL.dataSource = self;
    positionTBL.delegate = self;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14.0];
    //label.font = [UIFont boldSystemFontOfSize:20.0];
    //label.textAlignment = UITextAlignmentCenter;
    //label.textAlignment = UITextAlignmentLeft;
    //self.navigationItem.titleView = label;
    //self.title = account.name;
    //label.text = account.name;
    //label.textColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    //[label sizeToFit];
    
    expanedRowSet = [[NSMutableArray alloc] init];
    for (int i=0; i<[account.positions count];i++){
        [expanedRowSet addObject:[NSNumber numberWithBool:NO]];
    }
    
    portraitTitleBar.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    landscrapeTitleBar.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
//#endif
    }
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate addObserver:self forKeyPath:@"accounts" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:@"USER_LOGOUT" object:nil];

}

- (void)viewDidUnload
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate removeObserver:self forKeyPath:@"accounts"];
    [self setPositionTBL:nil];
    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    if([brokerageAccounts count] > 0 && selectedAccount > -1)
    {
        BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:14.0];
        label.text = account.name;
        label.textColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
        [label sizeToFit];
    }
    
}
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [positionTBL reloadData];
}

#pragma mark MVC Delegate methods

-(void)userLogout:(NSNotification*)notification
{
    [[BFBrokerageAccountStore defaultStore] clearAccounts];
    self.selectedAccount = -1;
}

#pragma mark - KVO lifecycle


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"accounts"]) 
    {
        NSMutableArray *brokerageAccounts = (NSMutableArray*)[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
        if ([brokerageAccounts count] > 0 && selectedAccount > -1)
        {
            BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];
            //self.title = account.name;
            expanedRowSet = [[NSMutableArray alloc] init];
            for (int i=0; i<[account.positions count];i++){
                [expanedRowSet addObject:[NSNumber numberWithBool:NO]];
            }
            [positionTBL reloadData];
        }
        return;
    }
}

#pragma mark - IBActions
- (IBAction)refreshBTNClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        return landscrapeTitleBar;
    } else {
        return portraitTitleBar;
    }
    }
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    return 44;
else
    return 0;

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
    if ([brokerageAccounts count] > 0 && [brokerageAccounts count] > selectedAccount) {
        BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];
        return [account.positions count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"SecurityDataCell";
    
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    PositionsSecurityTableViewCell *cell = (PositionsSecurityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[PositionsSecurityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if([brokerageAccounts count] >0 && selectedAccount > -1)
    {
        BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];
        BFPosition *position = [account.positions objectAtIndex:indexPath.row];
        cell.symbol.text = position.instrumentSymbol;
        cell.symName.text = position.instrumentName;
        cell.marketValue.text = [formatter stringFromNumber:position.marketValue.amount];
        cell.lastTrade.text = [formatter stringFromNumber:position.lastTrade.amount];
        cell.quantity.text = [position.quantity stringValue];
        if ([position.instrumentSymbol isEqualToString:@"CASH"] != YES)
            cell.cellAccessoryImageView.image = [UIImage imageNamed:@"more_info.png"];
        NSNumber *gain = [[NSNumber alloc]init];
        float perc;
        NSNumberFormatter *percentageFormatter = [[NSNumberFormatter alloc] init];
        [percentageFormatter setNumberStyle:NSNumberFormatterPercentStyle];
        [percentageFormatter setMinimumFractionDigits:0];
        [percentageFormatter setMaximumFractionDigits:1];
        if(([position.marketValue.amount intValue] == 0)  && ([position.totalCost.amount intValue] == 0))
            perc = 0.0;
        else
        {
        perc = ([position.marketValue.amount floatValue] - [position.totalCost.amount floatValue])/([position.totalCost.amount floatValue]);
        
        }
        gain = [NSNumber numberWithFloat:perc];
        NSLog(@"gain percentage is %f", [gain floatValue]);
        cell.gainPercentage.text = [percentageFormatter stringFromNumber:gain];
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
        if ([brokerageAccounts count] > 0)
        {
            BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];
            BFPosition *position = [account.positions objectAtIndex:indexPath.row];
            selectedSubAccount = indexPath.row;
            if ([position.instrumentSymbol isEqualToString:@"CASH"] != YES)
                [self performSegueWithIdentifier:@"PositionsDetailViewSegue" sender:self];
        }
    }
}

-(void)expandPosition:(id)sender
{
    expandPositionBTN *button = (expandPositionBTN *)sender;
    
    NSNumber *expand_Row = [expanedRowSet objectAtIndex:button.indexPath.row];
    if (expand_Row != nil && [expand_Row boolValue] == YES) {
        [expanedRowSet replaceObjectAtIndex:button.indexPath.row withObject:[NSNumber numberWithBool:NO]];
    } else {
        [expanedRowSet replaceObjectAtIndex:button.indexPath.row withObject:[NSNumber numberWithBool:YES]];
    }
    [positionTBL reloadData];
}

-(void)tradePosition:(id)sender
{
    tradePositionBTN *button = (tradePositionBTN *)sender;
    
    TradeViewController *tradeController = [[TradeViewController alloc] initWithNibName:@"TradeViewController" bundle:nil position:button.position];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:tradeController];
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentViewController:controller animated:YES completion:NULL];
    controller.view.superview.bounds=CGRectMake(0, 0, 500,400);
    controller.view.frame=CGRectMake(0, 0, 500,400);
}
- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"in prepare for segue for identifier %@",segue.identifier );
    if([segue.identifier isEqualToString:@"PositionsDetailViewSegue"])
    {
        PositionsDetailViewController *destController = [segue destinationViewController];
        
        if([destController isKindOfClass:[PositionsDetailViewController class]])
        {
            destController.isComingFromAccountsScreen = YES;
            destController.selectedAccount = self.selectedAccount;
            destController.selectedSecurityInAccount = self.selectedSubAccount;
            NSLog(@"in PositionsViewController account selected is %d, security selected is %d",self.selectedAccount, self.selectedSubAccount );
            
        }
    } else if([segue.identifier isEqualToString:@"EditAccountSegue"])
    {
        EditAccountNameViewController  *destController = [segue destinationViewController];
        NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
        if ([brokerageAccounts count] > 0)
        {
            BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];

            if([destController isKindOfClass:[EditAccountNameViewController class]])
            
                [destController initWithAccountName:account.name withId:[NSString stringWithFormat:@"%d",self.selectedAccount]];
        }
    }
    
}
- (IBAction)editButtonClicked:(id)sender {
    
        [self performSegueWithIdentifier:@"EditAccountSegue" sender:editButton];
}
@end
