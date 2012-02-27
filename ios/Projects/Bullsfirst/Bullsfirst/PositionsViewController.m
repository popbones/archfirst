//
//  PositionsViewController.m
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

#import "PositionsViewController.h"
#import "AppDelegate.h"
#import "BFBrokerageAccountStore.h"
#import "BFBrokerageAccount.h"
#import "BFPosition.h"
#import "BFMoney.h"
#import "tradePositionBTN.h"
#import "expandPositionBTN.h"
#import "TradeViewController.h"

@implementation PositionsViewController
@synthesize positionTBL;
@synthesize positionCell;
@synthesize selectedAccount;
@synthesize expandRow;
@synthesize portraitTitleBar;
@synthesize landscrapeTitleBar;


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
    BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = label;
    label.text = account.name;
    label.textColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    [label sizeToFit];
    
    expandRow = -1;
    
    portraitTitleBar.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    landscrapeTitleBar.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
}

- (void)viewDidUnload
{
    [self setPositionTBL:nil];
    [super viewDidUnload];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [positionTBL reloadData];
    
}

#pragma mark - KVO lifecycle

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
}

#pragma mark - IBActions
- (IBAction)refreshBTNClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        return landscrapeTitleBar;
    } else {
        return portraitTitleBar;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == expandRow) {
        NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
        BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];
        BFPosition *position = [account.positions objectAtIndex:indexPath.row];
        return 44*(1+[position.children count]);
    }
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
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:selectedAccount];
    BFPosition *position = [account.positions objectAtIndex:indexPath.row];

    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        UITableViewCell *cell;
        [[NSBundle mainBundle] loadNibNamed:@"PositionLandscapeTableViewCell" owner:self options:nil];
        cell = positionCell;
        
        expandPositionBTN *expand = (expandPositionBTN *)[cell viewWithTag:1]; // expand button
        [expand addTarget:self action:@selector(expandPosition:) forControlEvents:UIControlEventTouchUpInside];
        expand.row = indexPath.row;
        [expand setTitle:@"+" forState:UIControlStateNormal];

        UILabel *label;
        label = (UILabel *)[cell viewWithTag:2];
        label.text = position.instrumentName;
        
        label = (UILabel *)[cell viewWithTag:3];
        label.text = position.instrumentSymbol;

        label = (UILabel *)[cell viewWithTag:4];
        label.text = [NSString stringWithFormat:@"%d", [position.quantity intValue]];
        
        label = (UILabel *)[cell viewWithTag:5];
        label.text = [NSString stringWithFormat:@"$%d", [position.lastTrade.amount intValue]];

        label = (UILabel *)[cell viewWithTag:6];
        label.text = [NSString stringWithFormat:@"$%d", [position.marketValue.amount intValue]];
        
        label = (UILabel *)[cell viewWithTag:7];
        label.text = [NSString stringWithFormat:@"$%d", [position.pricePaid.amount intValue]];
        
        label = (UILabel *)[cell viewWithTag:8];
        label.text = [NSString stringWithFormat:@"$%d", [position.totalCost.amount intValue]];

        label = (UILabel *)[cell viewWithTag:9];
        label.text = [NSString stringWithFormat:@"$%d", [position.gain.amount intValue]];

        label = (UILabel *)[cell viewWithTag:10];
        label.text = [NSString stringWithFormat:@"%d%%", [position.gainPercent intValue]];
        
        tradePositionBTN *trade = (tradePositionBTN *)[cell viewWithTag:11]; // trade button
        [trade addTarget:self action:@selector(tradePosition:) forControlEvents:UIControlEventTouchUpInside];
        trade.position = position;
        
        if (indexPath.row == expandRow) {
            [expand setTitle:@"-" forState:UIControlStateNormal];

            CGRect frame = cell.frame;
            cell.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 44*(1+[position.children count]));
            
            UILabel *label;
            label = (UILabel *)[cell viewWithTag:2];
            CGRect nameFrame = label.frame;
            
            label = (UILabel *)[cell viewWithTag:4];
            CGRect quantityFrame = label.frame;
            
            label = (UILabel *)[cell viewWithTag:5];
            CGRect lastTradeFrame = label.frame;
            
            label = (UILabel *)[cell viewWithTag:6];
            CGRect marketValueFrame = label.frame;
            
            label = (UILabel *)[cell viewWithTag:7];
            CGRect pricePaidFrame = label.frame;

            label = (UILabel *)[cell viewWithTag:8];
            CGRect totalCostFrame = label.frame;

            label = (UILabel *)[cell viewWithTag:9];
            CGRect qainFrame = label.frame;
            
            label = (UILabel *)[cell viewWithTag:10];
            CGRect gainPercentFrame = label.frame;
            
            for (BFPosition *lot in position.children) {
                nameFrame.origin.y += 44;
                UILabel *label = [[UILabel alloc] initWithFrame:nameFrame];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
                [dateFormat setDateFormat:@"MM/dd/yyyy"];
                label.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:lot.lotCreationTime]];
                [cell addSubview:label];

                quantityFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:quantityFrame];
                label.text = [NSString stringWithFormat:@"%d", [lot.quantity intValue]];
                [cell addSubview:label];

                lastTradeFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:lastTradeFrame];
                label.font = [UIFont systemFontOfSize:13.0];
                label.text = [NSString stringWithFormat:@"$%d", [lot.lastTrade.amount intValue]];
                [cell addSubview:label];
                
                marketValueFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:marketValueFrame];
                label.font = [UIFont systemFontOfSize:13.0];
                label.text = [NSString stringWithFormat:@"$%d", [lot.marketValue.amount intValue]];
                [cell addSubview:label];
                
                pricePaidFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:pricePaidFrame];
                label.font = [UIFont systemFontOfSize:13.0];
                label.text = [NSString stringWithFormat:@"$%d", [lot.pricePaid.amount intValue]];
                [cell addSubview:label];

                totalCostFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:totalCostFrame];
                label.font = [UIFont systemFontOfSize:13.0];
                label.text = [NSString stringWithFormat:@"$%d", [lot.totalCost.amount intValue]];
                [cell addSubview:label];

                qainFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:qainFrame];
                label.font = [UIFont systemFontOfSize:13.0];
                label.text = [NSString stringWithFormat:@"$%d", [lot.gain.amount intValue]];
                [cell addSubview:label];
                
                gainPercentFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:gainPercentFrame];
                label.font = [UIFont systemFontOfSize:13.0];
                label.text = [NSString stringWithFormat:@"%d%%", [lot.gainPercent intValue]];
                [cell addSubview:label];
            }
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell;
        [[NSBundle mainBundle] loadNibNamed:@"PositionTableViewCell" owner:self options:nil];
        cell = positionCell;
        
        expandPositionBTN *expand = (expandPositionBTN *)[cell viewWithTag:1]; // expand button
        [expand addTarget:self action:@selector(expandPosition:) forControlEvents:UIControlEventTouchUpInside];
        expand.row = indexPath.row;
        [expand setTitle:@"+" forState:UIControlStateNormal];
        
        UILabel *label;
        label = (UILabel *)[cell viewWithTag:2];
        label.text = position.instrumentSymbol;
        
        label = (UILabel *)[cell viewWithTag:3];
        label.text = [NSString stringWithFormat:@"%d", [position.quantity intValue]];
        
        label = (UILabel *)[cell viewWithTag:4];
        label.text = [NSString stringWithFormat:@"$%d", [position.marketValue.amount intValue]];
        
        label = (UILabel *)[cell viewWithTag:5];
        label.text = [NSString stringWithFormat:@"$%d", [position.gain.amount intValue]];
        
        label = (UILabel *)[cell viewWithTag:6];
        label.text = [NSString stringWithFormat:@"%d%%", [position.gainPercent intValue]];
        
        tradePositionBTN *trade = (tradePositionBTN *)[cell viewWithTag:7]; // trade button
        [trade addTarget:self action:@selector(tradePosition:) forControlEvents:UIControlEventTouchUpInside];
        trade.position = position;
        
        if (indexPath.row == expandRow) {
            [expand setTitle:@"-" forState:UIControlStateNormal];
            CGRect frame = cell.frame;
            cell.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 44*(1+[position.children count]));
            
            UILabel *label;
            label = (UILabel *)[cell viewWithTag:3];
            CGRect quantityFrame = label.frame;
            
            label = (UILabel *)[cell viewWithTag:4];
            CGRect marketValueFrame = label.frame;
            
            label = (UILabel *)[cell viewWithTag:5];
            CGRect qainFrame = label.frame;
            
            label = (UILabel *)[cell viewWithTag:6];
            CGRect gainPercentFrame = label.frame;
            
            for (BFPosition *lot in position.children) {
                quantityFrame.origin.y += 44;
                UILabel *label = [[UILabel alloc] initWithFrame:quantityFrame];
                label.text = [NSString stringWithFormat:@"%d", [lot.quantity intValue]];
                label.font = [UIFont systemFontOfSize:13.0];
                [cell addSubview:label];

                marketValueFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:marketValueFrame];
                label.text = [NSString stringWithFormat:@"$%d", [lot.marketValue.amount intValue]];
                label.font = [UIFont systemFontOfSize:13.0];
                [cell addSubview:label];
                
                qainFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:qainFrame];
                label.text = [NSString stringWithFormat:@"$%d", [lot.gain.amount intValue]];
                [cell addSubview:label];
                label.font = [UIFont systemFontOfSize:13.0];

                gainPercentFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:gainPercentFrame];
                label.text = [NSString stringWithFormat:@"%d%%", [lot.gainPercent intValue]];
                label.font = [UIFont systemFontOfSize:13.0];
                [cell addSubview:label];
            }
        }
        
        return cell;
    }
    
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

-(void)expandPosition:(id)sender
{
    expandPositionBTN *button = (expandPositionBTN *)sender;
    
    if (button.row == expandRow) {
        expandRow = -1;
    } else {
        expandRow = button.row;
    }
    [positionTBL reloadData];
}

-(void)tradePosition:(id)sender
{
    tradePositionBTN *button = (tradePositionBTN *)sender;
    
    TradeViewController *tradeController = [[TradeViewController alloc] initWithNibName:@"TradeViewController" bundle:nil position:button.position];    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:tradeController];
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentModalViewController:controller animated:YES];
}

@end
