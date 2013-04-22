//
//  PositionsSummaryViewController.m
//  Bullsfirst2
//
//  Created by Rashmi Garg on 12/13/12.
//  For storyboard and Bullsfirst2 design
//  Copyright (c) 2012 Rashmi Garg. All rights reserved.
//

#import "PositionsSummaryViewController.h"
#import "PositionsSummaryTableViewCell.h"
#import "PositionsDetailViewController.h"
#import "BFBrokerageSecurityStore.h"
#import "BFBrokerageSecurity.h"
#import "BFBrokerageAccount.h"
#import "BFPosition.h"
#import "BFMoney.h"

@interface PositionsSummaryViewController ()

@end

@implementation PositionsSummaryViewController
@synthesize accountsTable, selectedSecurity, selectedAccountInSecurity;
@synthesize totalCostLabel, totalGainLabel, totalMarketValueLabel, securityNameLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title = @"Positions";
    accountsTable.dataSource = self;
    accountsTable.delegate = self;
    NSMutableArray *brokerageSecurities = (NSMutableArray*)[[BFBrokerageSecurityStore defaultStore] allBrokerageSecurities];
    if([brokerageSecurities count] > 0)
    {
        BFBrokerageSecurity *security = [brokerageSecurities objectAtIndex:selectedSecurity];
        self.securityNameLabel.text = security.instrumentName;
        int totalCost=0, totalMarketValue=0, gain = 0;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setMaximumFractionDigits:0];
        [formatter setMinimumFractionDigits:0];
        for(int i=0; i < [security.accounts count]; i++)
        {
            BFPosition *account = (BFPosition *)[security.accounts objectAtIndex:i];
            totalMarketValue += [account.marketValue.amount integerValue];
            totalCost += [account.totalCost.amount integerValue];
        }
        gain = totalMarketValue - totalCost;
        self.totalMarketValueLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:totalMarketValue]];
        self.totalCostLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:totalCost]];
        self.totalGainLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:gain]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSMutableArray *brokerageSecurities = (NSMutableArray*)[[BFBrokerageSecurityStore defaultStore] allBrokerageSecurities];
    if([brokerageSecurities count] > 0)
    {
        BFBrokerageSecurity *security = [brokerageSecurities objectAtIndex:selectedSecurity];
        return [security.accounts count];
    }
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SecuritySummaryDataCell";
    PositionsSummaryTableViewCell *cell = (PositionsSummaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PositionsSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSMutableArray *brokerageSecurities = (NSMutableArray*)[[BFBrokerageSecurityStore defaultStore] allBrokerageSecurities];
    if([brokerageSecurities count] > 0)
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
        NSNumberFormatter *percentageFormatter = [[NSNumberFormatter alloc] init];
        [percentageFormatter setNumberStyle:NSNumberFormatterPercentStyle];
        [percentageFormatter setMinimumFractionDigits:0];
        [percentageFormatter setMaximumFractionDigits:2];
    
        BFBrokerageSecurity *security = [brokerageSecurities objectAtIndex:selectedSecurity];
        BFPosition *account = [security.accounts objectAtIndex:indexPath.row];
    
        
    
        cell.accName.text = account.accountName;
        cell.marketValue.text = [formatter stringFromNumber:account.marketValue.amount];
        cell.quantity.text = [decimalFormatter stringFromNumber:account.quantity];
        cell.gainPercentage.text = [percentageFormatter stringFromNumber:account.gainPercent];
        if ([security.instrumentSymbol isEqualToString:@"CASH"] != YES)
            cell.cellAccessoryImageView.image = [UIImage imageNamed:@"more_info.png"];
        
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        selectedAccountInSecurity = indexPath.row;
        NSMutableArray *brokerageSecurities = (NSMutableArray*)[[BFBrokerageSecurityStore defaultStore] allBrokerageSecurities];
        BFBrokerageSecurity *security = [brokerageSecurities objectAtIndex:selectedSecurity];
        
        if ([security.instrumentSymbol isEqualToString:@"CASH"] != YES)
        [self performSegueWithIdentifier:@"PositionsDetailViewSegue" sender:self];
        
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PositionsDetailViewSegue"])
    {
        PositionsDetailViewController *destController = [segue destinationViewController];
        
        if([destController isKindOfClass:[PositionsDetailViewController class]])
        {
            destController.isComingFromAccountsScreen = NO;
            destController.selectedSecurity = selectedSecurity;
            destController.selectedAccountInSecurity = selectedAccountInSecurity;

        }
    }
    
}

@end
