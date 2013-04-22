//
//  PositionsSecurityViewController.m
//  Bullsfirst2
//
//  Created by Rashmi Garg on 12/13/12.
//  For storyboard and Bullsfirst2 design
//  Copyright (c) 2012 Rashmi Garg. All rights reserved.
//

#import "AppDelegate.h"
#import "PositionsSecurityViewController.h"
#import "PositionsSecurityTableViewCell.h"
#import "PositionsSummaryViewController.h"
#import "BFBrokerageSecurityStore.h"
#import "BFBrokerageSecurity.h"
#import "BFMoney.h"

@interface PositionsSecurityViewController()

@end

@implementation PositionsSecurityViewController

@synthesize totalCostLabel, totalGainLabel, totalMarketValueLabel, symbolsTable, selectedRow;

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
    self.navigationItem.titleView.hidden = YES;
    symbolsTable.delegate = self;
    symbolsTable.dataSource = self;
    [symbolsTable reloadData];
    if([self.navigationController.navigationBar  respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"HeaderBar_BackgroundGradient.jpg"] forBarMetrics: UIBarMetricsDefault];
    }
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate addObserver:self forKeyPath:@"securities" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    NSMutableArray *brokerageSecurities = (NSMutableArray*)[[BFBrokerageSecurityStore defaultStore] allBrokerageSecurities];
    if([brokerageSecurities count] > 0)
    {
        int totalCost=0, totalMarketValue=0, gain = 0;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setMaximumFractionDigits:0];
        [formatter setMinimumFractionDigits:0];
        for(int i=0; i < [brokerageSecurities count]; i++)
        {
            BFBrokerageSecurity *security = (BFBrokerageSecurity *)[brokerageSecurities objectAtIndex:i];
            totalMarketValue += [security.marketValue.amount integerValue];
            totalCost += [security.totalCost.amount integerValue];
        }
        gain = totalMarketValue - totalCost;
        self.totalMarketValueLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:totalMarketValue]];
        self.totalCostLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:totalCost]];
        self.totalGainLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:gain]];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [symbolsTable reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"securities"])
    {
        NSMutableArray *brokerageSecurities = (NSMutableArray*)[[BFBrokerageSecurityStore defaultStore] allBrokerageSecurities];
    
        if ([brokerageSecurities count] > 0)
        {
            int totalCost=0, totalMarketValue=0, gain = 0;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [formatter setMaximumFractionDigits:0];
            [formatter setMinimumFractionDigits:0];
            for(int i=0; i < [brokerageSecurities count]; i++)
            {
                BFBrokerageSecurity *security = (BFBrokerageSecurity *)[brokerageSecurities objectAtIndex:i];
                totalMarketValue += [security.marketValue.amount integerValue];
                totalCost += [security.totalCost.amount integerValue];
            }
            gain = totalMarketValue - totalCost;
            self.totalMarketValueLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:totalMarketValue]];
            self.totalCostLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:totalCost]];
            self.totalGainLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:gain]];
            [symbolsTable reloadData];          
        }
        return;
    }
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
    return [brokerageSecurities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SecurityDataCell";
    
    NSMutableArray *brokerageSecurities = (NSMutableArray*)[[BFBrokerageSecurityStore defaultStore] allBrokerageSecurities];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    BFBrokerageSecurity *security = [brokerageSecurities objectAtIndex:indexPath.row];
    PositionsSecurityTableViewCell *cell = (PositionsSecurityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
            cell = [[PositionsSecurityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if([brokerageSecurities count] > 0)
    {
        cell.symbol.text = security.instrumentSymbol;
        cell.symName.text = security.instrumentName;
        cell.quantity.text = [security.quantity stringValue];
        cell.lastTrade.text = [formatter stringFromNumber:security.lastTrade.amount];
        cell.marketValue.text = [formatter stringFromNumber:security.marketValue.amount];
        //if ([security.instrumentSymbol isEqualToString:@"CASH"] != YES)
        cell.cellAccessoryImageView.image = [UIImage imageNamed:@"more_info.png"];
    
        NSNumber *gain = [[NSNumber alloc]init];
        float perc;
        NSNumberFormatter *percentageFormatter = [[NSNumberFormatter alloc] init];
        [percentageFormatter setNumberStyle:NSNumberFormatterPercentStyle];
        [percentageFormatter setMinimumFractionDigits:0];
        [percentageFormatter setMaximumFractionDigits:1];
        if(([security.marketValue.amount intValue] == 0)  && ([security.totalCost.amount intValue] == 0))
            perc = 0.0;
        else
            perc = ([security.marketValue.amount floatValue] - [security.totalCost.amount floatValue])/([security.totalCost.amount floatValue]);
        gain = [NSNumber numberWithFloat:perc];
        cell.gainPercentage.text = [percentageFormatter stringFromNumber:gain];
    }
    return cell;    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        selectedRow = indexPath.row;
        [self performSegueWithIdentifier:@"PositionsSummaryViewSegue" sender:self];
        
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PositionsSummaryViewSegue"])
    {
        PositionsSummaryViewController *destController = [segue destinationViewController];
        
        if([destController isKindOfClass:[PositionsSummaryViewController class]])
          destController.selectedSecurity = selectedRow;
    }    
}



@end
