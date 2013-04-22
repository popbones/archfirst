
//
//  PositionsDetailViewController.m
//  Bullsfirst
//
//  Created by Rashmi Garg
//  For storyboard and Bullsfirst2 design
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
#import "AppDelegate.h"
#import "BFBrokerageSecurityStore.h"
#import "BFBrokerageSecurity.h"
#import "BFBrokerageAccountStore.h"
#import "BFBrokerageAccount.h"
#import "BFPosition.h"
#import "BFMoney.h"
#import "tradePositionBTN.h"
#import "expandPositionBTN.h"
#import "TradeViewController.h"
#import "PositionsDetailViewTableCell.h"

@implementation PositionsDetailViewController
@synthesize securityLBL, accountLBL;
@synthesize quantityLBL, lastTradeLBL, marketValueLBL, pricePaidLBL, totalCostLBL;
@synthesize lotsTable, isComingFromAccountsScreen;
@synthesize selectedAccountInSecurity;
@synthesize selectedSecurity;
@synthesize selectedAccount, selectedSecurityInAccount;



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
        self.selectedAccountInSecurity = account;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lotsTable.dataSource = self;
    lotsTable.delegate = self;
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate addObserver:self forKeyPath:@"accounts" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:@"USER_LOGOUT" object:nil];    
}

- (void)viewDidUnload
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate removeObserver:self forKeyPath:@"accounts"];
    [self setLotsTable:nil];
    
    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"in PositionsDetailViewController View Appear account selecetd is %d",self.selectedSecurity);
    /*
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];
    BFPosition *position = [account.positions objectAtIndex:selectedSubAccount];
    */
    
}
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [lotsTable reloadData];
}

#pragma mark MVC Delegate methods

-(void)userLogout:(NSNotification*)notification
{
    self.selectedAccountInSecurity= -1;
}

#pragma mark - KVO lifecycle

/*
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"accounts"])
    {
        NSMutableArray *brokerageSecurities = (NSMutableArray*)[[BFBrokerageSymbolStore defaultStore] allBrokerageSymbols];
        if ([brokerageSecurities count] > 0 && selectedAccount > -1)
        {
            BFBrokerageSymbol *security = [brokerageSecurities objectAtIndex:selectedSecurity];
            expanedRowSet = [[NSMutableArray alloc] init];
            for (int i=0; i<[account.positions count];i++){
                [expanedRowSet addObject:[NSNumber numberWithBool:NO]];
            }
            [lotsTable reloadData];
        }
        return;
    }
}
*/
#pragma mark - IBActions
- (IBAction)refreshBTNClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(!isComingFromAccountsScreen)
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

        NSArray *brokerageSecurities = [[BFBrokerageSecurityStore defaultStore] allBrokerageSecurities];
        if ([brokerageSecurities count] > 0 && [brokerageSecurities count] > selectedSecurity) {
            BFBrokerageSecurity *security = [brokerageSecurities objectAtIndex:selectedSecurity];
            securityLBL.text = [NSString stringWithFormat:@"%@ (%@)", security.instrumentSymbol,security.instrumentName];
            BFPosition *position = [security.accounts objectAtIndex:selectedAccountInSecurity];
            accountLBL.text = position.accountName;
            quantityLBL.text = [decimalFormatter stringFromNumber:position.quantity];
            marketValueLBL.text = [formatter stringFromNumber:position.marketValue.amount];
            lastTradeLBL.text = [formatter stringFromNumber:position.lastTrade.amount];
            pricePaidLBL.text = [formatter stringFromNumber:position.pricePaid.amount];
            totalCostLBL.text = [formatter stringFromNumber:position.totalCost.amount];
        return [position.children count];
        }
        else return 0;
    }
    else{
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
        if ([brokerageAccounts count] > 0 && [brokerageAccounts count] > selectedAccount) {
            BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];
            BFPosition *position = [account.positions objectAtIndex:selectedSecurityInAccount];
            securityLBL.text = [NSString stringWithFormat:@"%@ (%@)", position.instrumentSymbol,position.instrumentName];
            accountLBL.text = account.name;
            quantityLBL.text = [decimalFormatter stringFromNumber:position.quantity];
            marketValueLBL.text = [formatter stringFromNumber:position.marketValue.amount];
            lastTradeLBL.text = [formatter stringFromNumber:position.lastTrade.amount];
            pricePaidLBL.text = [formatter stringFromNumber:position.pricePaid.amount];
            totalCostLBL.text = [formatter stringFromNumber:position.totalCost.amount];
            return [position.children count];
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"PositionsDetailViewCell";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];    
    NSNumberFormatter *percentageFormatter = [[NSNumberFormatter alloc] init];
    [percentageFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    [percentageFormatter setMaximumFractionDigits:1];
    
    PositionsDetailViewTableCell *cell = (PositionsDetailViewTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PositionsDetailViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if(!isComingFromAccountsScreen)
    {
        NSArray *brokerageSecurities = [[BFBrokerageSecurityStore defaultStore] allBrokerageSecurities];
        if(brokerageSecurities.count > 0)
        {
            BFBrokerageSecurity *security = [brokerageSecurities objectAtIndex:selectedSecurity];
            BFPosition *account = [security.accounts objectAtIndex:selectedAccountInSecurity];
            BFPosition *lot = [account.children objectAtIndex:indexPath.row];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
            [dateFormat setDateFormat:@"MM/dd/yyyy"];
            
            cell.lotNumberLBL.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:lot.lotCreationTime]];
            cell.quantityLBL.text = [decimalFormatter stringFromNumber:lot.quantity];
            cell.pricePaidLBL.text = [formatter stringFromNumber:lot.pricePaid.amount];
            cell.totalCostLBL.text = [formatter stringFromNumber:lot.totalCost.amount];
        }        
    }
    else
    {
        NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
        if(brokerageAccounts.count > 0)
        {
            BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];
            BFPosition *position = [account.positions objectAtIndex:selectedSecurity];
            BFPosition *lot = [position.children objectAtIndex:indexPath.row];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
            [dateFormat setDateFormat:@"MM/dd/yyyy"];
            
            cell.lotNumberLBL.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:lot.lotCreationTime]];
            cell.quantityLBL.text = [decimalFormatter stringFromNumber:lot.quantity];
            cell.pricePaidLBL.text = [formatter stringFromNumber:lot.pricePaid.amount];
            cell.totalCostLBL.text = [formatter stringFromNumber:lot.totalCost.amount];
            
            

        }
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

/*
-(void)tradePosition:(id)sender
{
    tradePositionBTN *button = (tradePositionBTN *)sender;
    
    TradeViewController *tradeController = [[TradeViewController alloc] initWithNibName:@"TradeViewController" bundle:nil position:button.position];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:tradeController];
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentModalViewController:controller animated:YES];
    controller.view.superview.bounds=CGRectMake(0, 0, 500,400);
    controller.view.frame=CGRectMake(0, 0, 500,400);
}
 */
- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
