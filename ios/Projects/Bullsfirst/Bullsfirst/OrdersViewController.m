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
#import "TradeViewController.h"
#import "TransferViewController.h"
#import "FilterViewController.h"
#import "UserViewController.h"
#import "OrderBTN.h"

@implementation OrdersViewController
@synthesize orderTBL;
@synthesize orderTableViewCell;
@synthesize portraitTitleBar;
@synthesize landscrapeTitleBar;
@synthesize orders;

- (id)init
{
    self = [super init];
    
    if(self)
    {
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Orders"];
        UIImage *i = [UIImage imageNamed:@"TabBar_Orders.png"];
        [tbi setImage:i];        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = @"Orders";
    [label sizeToFit];
    
    portraitTitleBar.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    landscrapeTitleBar.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    [self refreshBTNClicked:nil];
}

- (void)viewDidUnload
{
    [self setOrderTBL:nil];
    [self setPortraitTitleBar:nil];
    [self setLandscrapeTitleBar:nil];
    [self setOrderTableViewCell:nil];
    [super viewDidUnload];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
    }
    else
    {
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
    orders = [BFOrder ordersFromJSONData:data];
    [orderTBL reloadData];
}

#pragma mark - KVO lifecycle

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
}

#pragma mark - IBActions

- (IBAction)refreshBTNClicked:(id)sender {   
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/orders"];
    [self.restServiceObject getRequestWithURL:url];    
}

- (IBAction)filterBTNClicked:(id)sender {
    FilterViewController *controller = [[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)orderBTNClicked:(id)sender {   
    FilterViewController *controller = [[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
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
    BFOrder *order = [orders objectAtIndex:indexPath.row];
    
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        UITableViewCell *cell;
        [[NSBundle mainBundle] loadNibNamed:@"OrderLandscapeTableViewCell" owner:self options:nil];
        cell = orderTableViewCell;
 
        UILabel *label;
        label = (UILabel *)[cell viewWithTag:1];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        label.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:order.creationTime]];
        
        label = (UILabel *)[cell viewWithTag:2];
        label.text = [NSString stringWithFormat:@"%d", [order.orderId intValue]];
        
        label = (UILabel *)[cell viewWithTag:3];
        label.text = order.type;
        
        label = (UILabel *)[cell viewWithTag:4];
        label.text = order.instrumentSymbol;
        
        label = (UILabel *)[cell viewWithTag:5];
        label.text = [NSString stringWithFormat:@"%d", [order.quantity intValue]];
        
        label = (UILabel *)[cell viewWithTag:6];
        
        label = (UILabel *)[cell viewWithTag:7];
        
        label = (UILabel *)[cell viewWithTag:8];
        label.text = order.status;
        
        label = (UILabel *)[cell viewWithTag:9];
        label.text = order.side;

        OrderBTN *orderBTN = (OrderBTN *)[cell viewWithTag:10]; // cancel button
        [orderBTN addTarget:self action:@selector(orderBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
        orderBTN.order = order;

        return cell;
    }
    else
    {
        UITableViewCell *cell;
        [[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil];
        cell = orderTableViewCell;
        
        UILabel *label;
        label = (UILabel *)[cell viewWithTag:1];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        label.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:order.creationTime]];
        
        label = (UILabel *)[cell viewWithTag:2];
        label.text = [NSString stringWithFormat:@"%d", [order.orderId intValue]];

        label = (UILabel *)[cell viewWithTag:3];
        label.text = order.type;
        
        label = (UILabel *)[cell viewWithTag:4];
        label.text = order.instrumentSymbol;
        
        label = (UILabel *)[cell viewWithTag:5];
        label.text = [NSString stringWithFormat:@"%d", [order.quantity intValue]];
        
        label = (UILabel *)[cell viewWithTag:6];

        label = (UILabel *)[cell viewWithTag:7];

        label = (UILabel *)[cell viewWithTag:8];
        label.text = order.status;
        
        label = (UILabel *)[cell viewWithTag:9];
        label.text = order.side;

        OrderBTN *orderBTN = (OrderBTN *)[cell viewWithTag:10]; // cancel button
        [orderBTN addTarget:self action:@selector(orderBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
        orderBTN.order = order;

        return cell;
    }
}


 // Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
 

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
