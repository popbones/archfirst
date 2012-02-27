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
#import "FilterViewController.h"
#import "OrderBTN.h"
#import "DatePickerViewController.h"
#import "DropdownViewController.h"
#import "BFBrokerageAccountStore.h"
#import "BFBrokerageAccount.h"

@implementation OrdersViewController
@synthesize fromDateLabel;
@synthesize toDateLabel;
@synthesize resetBTN;
@synthesize applyBTN;
@synthesize accountLabel;
@synthesize orderLabel;
@synthesize orderStatusLabel;
@synthesize orderId;
@synthesize symbod;
@synthesize orderTBL;
@synthesize orderTableViewCell;
@synthesize orderFilterView;
@synthesize portraitTitleBar;
@synthesize landscrapeTitleBar;
@synthesize orders;
@synthesize datedropdown;
@synthesize dropdown;
@synthesize fromDate;
@synthesize toDate;
@synthesize accountSelected;
@synthesize orderType;
@synthesize orderStatus;

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
    self.navigationItem.titleView = label;
    label.text = @"Orders";
    label.textColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    [label sizeToFit];
    
    portraitTitleBar.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    landscrapeTitleBar.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBTNClicked:) name:@"TRADE_ORDER_SUBMITTED" object:nil];

    [self refreshBTNClicked:nil];
    [self resetBTNClicked:nil];
}

- (void)viewDidUnload
{
    [self setOrderTBL:nil];
    [self setPortraitTitleBar:nil];
    [self setLandscrapeTitleBar:nil];
    [self setOrderTableViewCell:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TRADE_ORDER_SUBMITTED" object:nil];
    [self setOrderFilterView:nil];
    [self setFromDateLabel:nil];
    [self setToDateLabel:nil];
    [self setResetBTN:nil];
    [self setApplyBTN:nil];
    [self setAccountLabel:nil];
    [self setOrderLabel:nil];
    [self setOrderStatusLabel:nil];
    [self setOrderId:nil];
    [self setSymbod:nil];
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

- (IBAction)dateDropdownClicked:(id)sender {
    UITapGestureRecognizer *tapGesture = sender;
    if (!datedropdown) {
        DatePickerViewController *controller = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
        
        datedropdown = [[UIPopoverController alloc] initWithContentViewController:controller];
        controller.popOver = datedropdown;
        controller.delegate = self;
    }
    if ([datedropdown isPopoverVisible]) {
        [datedropdown dismissPopoverAnimated:YES];
    } else {
        DatePickerViewController *controller = (DatePickerViewController*)datedropdown.contentViewController;
        controller.tag = tapGesture.view.tag;
        [datedropdown setPopoverContentSize:controller.view.frame.size];
        [datedropdown presentPopoverFromRect: tapGesture.view.frame  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (IBAction)resetBTNClicked:(id)sender {
    fromDate = [NSDate date];
    toDate = [NSDate date];
    accountSelected = @"All";
    orderType = @"All";
    orderStatus = @"All";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    fromDateLabel.text = [NSString stringWithFormat:@"From: %@", [dateFormat stringFromDate:fromDate]];
    toDateLabel.text = [NSString stringWithFormat:@"To: %@", [dateFormat stringFromDate:toDate]];
    accountLabel.text = [NSString stringWithFormat:@"Account: %@", accountSelected];
    orderLabel.text = [NSString stringWithFormat:@"Order: %@", orderType];
    orderStatusLabel.text = [NSString stringWithFormat:@"Order Status: %@", orderStatus];
}

- (IBAction)applyBTNClicked:(id)sender {
    
    NSString *brokerageAccountIDParam = @"";
    if ([accountSelected isEqualToString:@"All"] != YES) {
        NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
        for (BFBrokerageAccount *account in brokerageAccounts) {
            if ([accountSelected isEqualToString:account.name] == YES) {
                brokerageAccountIDParam = [NSString stringWithFormat:@"&accountId=%d", [account.brokerageAccountID intValue]];
                break;
            }
        }
    }

    NSString *symbodParam = @"";
    if ([symbod.text length]>0) {
        symbodParam = [NSString stringWithFormat:@"&symbol=%@",[symbod.text uppercaseString]];
    }
    
    NSString *orderIdParam = @"";
    if ([orderId.text length]>0) {
        orderIdParam = [NSString stringWithFormat:@"&orderId=%@",orderId.text];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    NSString *fromDateParam = [NSString stringWithFormat:@"&fromDate=%@",[dateFormat stringFromDate:fromDate]];

    NSString *toDateParam = [NSString stringWithFormat:@"&toDate=%@",[dateFormat stringFromDate:toDate]];

    NSString *orderTypeParam = @"";
    if ([orderType isEqualToString:@"All"] != YES) {
        orderTypeParam = [NSString stringWithFormat:@"&sides=%@",orderType];
    }

    NSString *orderStatusParam = @"";
    if ([orderStatus isEqualToString:@"All"] != YES) {
        orderTypeParam = [NSString stringWithFormat:@"&statuses=%@",orderStatus];
    }

    NSString *filter = [NSString stringWithFormat:@"http://archfirst.org/bfoms-javaee/rest/secure/orders?%@%@%@%@%@%@%@", fromDateParam, toDateParam, brokerageAccountIDParam, symbodParam, orderIdParam, orderTypeParam, orderStatusParam];
    BFDebugLog(@"filter = %@", filter);
    NSURL *url = [NSURL URLWithString:filter];
    [self.restServiceObject getRequestWithURL:url];    
}

- (IBAction)dropDownClicked:(id)sender {
    UITapGestureRecognizer *tapGesture = sender;
    NSArray *selections;
    CGSize size;
    switch (tapGesture.view.tag) {
        case 3: {
            NSMutableArray *accountName = [[NSMutableArray alloc] init];
            NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
            for (BFBrokerageAccount *account in brokerageAccounts) {
                [accountName addObject:account.name];
            }
            selections = [NSArray arrayWithArray:accountName];
            size.height = [selections count] * 44;
            if ([selections count] > 5) {
                size.height = 220;
            }
            size.width = 320;
            break;
        }
            
        case 4:
            selections = [NSArray arrayWithObjects:@"Buy", @"Sell", nil];
            size = [@"Buy" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]];
            size.height = [selections count] * 44;
            size.width += 20;
            
            break;
            
        case 5:
            selections = [NSArray arrayWithObjects:@"PendingNew", @"New", @"PartiallyFilled", @"Filled", @"PendingCancel", @"Canceled", @"DoneForDay", nil];
            size = [@"PartiallyFilled" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]];
            size.height = [selections count] * 44;
            size.width += 20;
            
            break;
            
        default:
            break;
    }
    
    if (!dropdown) {
        DropdownViewController *controller = [[DropdownViewController alloc] initWithNibName:@"DropdownViewController" bundle:nil];
        
        dropdown = [[UIPopoverController alloc] initWithContentViewController:controller];
        controller.popOver = dropdown;
        controller.selections = selections;
        controller.tag = tapGesture.view.tag;
        controller.delegate = self;
        [dropdown setPopoverContentSize:size];
    }
    if ([dropdown isPopoverVisible]) {
        [dropdown dismissPopoverAnimated:YES];
    } else {
        DropdownViewController *controller = dropdown.contentViewController;
        controller.tag = tapGesture.view.tag;
        controller.selections = selections;
        [controller.selectionsTBL reloadData];
        [dropdown setPopoverContentSize:size];
        [dropdown presentPopoverFromRect: tapGesture.view.frame  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (IBAction)cancelOrderBTNClicked:(id)sender {
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

        OrderBTN *cancelOrderBTN = (OrderBTN *)[cell viewWithTag:10]; // cancel button
        [cancelOrderBTN addTarget:self action:@selector(cancelOrderBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
        cancelOrderBTN.order = order;

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

        OrderBTN *cancelOrderBTN = (OrderBTN *)[cell viewWithTag:10]; // cancel button
        [cancelOrderBTN addTarget:self action:@selector(cancelOrderBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
        cancelOrderBTN.order = order;

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

#pragma mark - DatePickerViewController delegate methods

- (void)dateSelectionChanged:(DatePickerViewController *)controller
{
    NSDate* date = controller.datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    switch (controller.tag) {
        case 1:
            fromDateLabel.text = [NSString stringWithFormat:@"From: %@", [dateFormat stringFromDate:date]];
            fromDate = [date copy];
            break;
            
        case 2:
            toDateLabel.text = [NSString stringWithFormat:@"To: %@", [dateFormat stringFromDate:date]];
            toDate = [date copy];;
            break;
        default:
            break;
    }
}

- (void)selectionChanged:(DropdownViewController *)controller
{
    switch (controller.tag) {
        case 3: {
            accountLabel.text = [NSString stringWithFormat:@"Account: %@", controller.selected];
            accountSelected = [NSString stringWithString:controller.selected];
            break;
        }
        case 4:
            orderLabel.text = [NSString stringWithFormat:@"Order: %@", controller.selected];
            orderType = [NSString stringWithString:controller.selected];
            break;
            
        case 5:
            orderStatusLabel.text = [NSString stringWithFormat:@"Order Status: %@", controller.selected];
            orderStatus = [NSString stringWithString:controller.selected];
            break;
                        
        default:
            break;
    }
    
}


@end
