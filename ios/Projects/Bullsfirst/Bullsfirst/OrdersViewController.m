//
//  OrdersViewController.m
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

#import "OrdersViewController.h"
#import "AppDelegate.h"
#import "TradeViewController.h"
#import "TransferViewController.h"
#import "FilterViewController.h"

@implementation OrdersViewController
@synthesize orderTBL;
@synthesize portraitTitleBar;
@synthesize landscrapeTitleBar;
@synthesize filterBTN;
@synthesize transferBTN;
@synthesize tradeBTN;
@synthesize refreshBTN;
@synthesize restServiceObject;
@synthesize orders;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Orders"];
        UIImage *i = [UIImage imageNamed:@"iconOrders.png"];
        [tbi setImage:i];        
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Bullsfirst";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate addObserver:self forKeyPath:@"currentUser" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    if (appDelegate.currentUser != nil) {
        NSString* fullName=[appDelegate.currentUser.firstName stringByAppendingString:@" "];
        fullName=[fullName stringByAppendingString:appDelegate.currentUser.lastName];
        fullName=[fullName uppercaseString];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:fullName style:UIBarButtonItemStylePlain target:self action:@selector(userProfile)];
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }

    restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];

}

- (void)viewDidUnload
{
    [self setOrderTBL:nil];
    [self setPortraitTitleBar:nil];
    [self setLandscrapeTitleBar:nil];
    [self setFilterBTN:nil];
    [self setTransferBTN:nil];
    [self setTradeBTN:nil];
    [self setRefreshBTN:nil];
    [super viewDidUnload];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate removeObserver:self forKeyPath:@"currentUser"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice].systemVersion intValue] >= 5) {
        [self willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:0.1];
    }
    
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        CGRect rect = filterBTN.frame;
        filterBTN.frame = CGRectMake(610, rect.origin.y, rect.size.width, rect.size.height);
        rect = transferBTN.frame;
        transferBTN.frame = CGRectMake(755, rect.origin.y, rect.size.width, rect.size.height);
        rect = tradeBTN.frame;
        tradeBTN.frame = CGRectMake(850, rect.origin.y, rect.size.width, rect.size.height);
        rect = refreshBTN.frame;
        refreshBTN.frame = CGRectMake(933, rect.origin.y, rect.size.width, rect.size.height);
    }
    else
    {
        CGRect rect = filterBTN.frame;
        filterBTN.frame = CGRectMake(360, rect.origin.y, rect.size.width, rect.size.height);
        rect = transferBTN.frame;
        transferBTN.frame = CGRectMake(505, rect.origin.y, rect.size.width, rect.size.height);
        rect = tradeBTN.frame;
        tradeBTN.frame = CGRectMake(600, rect.origin.y, rect.size.width, rect.size.height);
        rect = refreshBTN.frame;
        refreshBTN.frame = CGRectMake(683, rect.origin.y, rect.size.width, rect.size.height);
    }
    [orderTBL reloadData];
    
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
    NSString *errorString = [NSString stringWithString:@"Try Refreshing!"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceeded:(NSData *)data
{
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    BFDebugLog(@"jsonObject = %@", jsonObject);
}

#pragma mark - KVO lifecycle

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
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

#pragma mark - IBActions

- (IBAction)logout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGOUT" object:nil];
}

- (IBAction)refreshBTNClicked:(id)sender {

    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    [jsonDic setValue:@"2012-01-01" forKey:@"fromDate"];
    [jsonDic setValue:@"2012-12-31" forKey:@"toDate"];
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];

    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/orders"];
    [restServiceObject getRequestWithURL:url body:jsonBodyData contentType:@"application/json"];    
}

- (IBAction)tradeBTNClicked:(id)sender {
    TradeViewController *controller = [[TradeViewController alloc] initWithNibName:@"TradeViewController" bundle:nil];    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)transferBTNClicked:(id)sender {
    TransferViewController *controller = [[TransferViewController alloc] initWithNibName:@"TransferViewController" bundle:nil];    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)filterBTNClicked:(id)sender {
    FilterViewController *controller = [[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:controller animated:YES];
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
    return [orders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
/*    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
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
                label.text = [NSString stringWithFormat:@"$%d", [lot.lastTrade.amount intValue]];
                [cell addSubview:label];
                
                marketValueFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:marketValueFrame];
                label.text = [NSString stringWithFormat:@"$%d", [lot.marketValue.amount intValue]];
                [cell addSubview:label];
                
                pricePaidFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:pricePaidFrame];
                label.text = [NSString stringWithFormat:@"$%d", [lot.pricePaid.amount intValue]];
                [cell addSubview:label];
                
                totalCostFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:totalCostFrame];
                label.text = [NSString stringWithFormat:@"$%d", [lot.totalCost.amount intValue]];
                [cell addSubview:label];
                
                qainFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:qainFrame];
                label.text = [NSString stringWithFormat:@"$%d", [lot.gain.amount intValue]];
                [cell addSubview:label];
                
                gainPercentFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:gainPercentFrame];
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
                [cell addSubview:label];
                
                marketValueFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:marketValueFrame];
                label.text = [NSString stringWithFormat:@"$%d", [lot.marketValue.amount intValue]];
                [cell addSubview:label];
                
                qainFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:qainFrame];
                label.text = [NSString stringWithFormat:@"$%d", [lot.gain.amount intValue]];
                [cell addSubview:label];
                
                gainPercentFrame.origin.y += 44;
                label = [[UILabel alloc] initWithFrame:gainPercentFrame];
                label.text = [NSString stringWithFormat:@"%d%%", [lot.gainPercent intValue]];
                [cell addSubview:label];
            }
        }
        
        return cell;
    }
    */
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




@end
