//
//  TransactionsViewController.m
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

#import "TransactionsViewController.h"
#import "AppDelegate.h"
#import "FilterViewController.h"
#import "BFTransaction.h"

@implementation TransactionsViewController
@synthesize transectionTBL,portraitTitleBar,landscrapeTitleBar,transactions;

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
        [tbi setTitle:@"Transactions"];
        UIImage *i = [UIImage imageNamed:@"TabBar_Transactions.png"];
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
    label.text = @"Transactions";
    label.textColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    
    portraitTitleBar.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    landscrapeTitleBar.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    [label sizeToFit];
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
}


-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.transectionTBL reloadData];
}

#pragma mark - KVO lifecycle

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
}

#pragma mark - IBActions
- (IBAction)refreshBTNClicked:(id)sender {
    
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
    return transactions.count;
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIInterfaceOrientation toOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    BFTransaction* transaction = [transactions objectAtIndex:indexPath.row];
    UITableViewCell* cell = transactionCell;
    if(toOrientation ==UIInterfaceOrientationLandscapeLeft || toOrientation ==UIInterfaceOrientationLandscapeRight)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TransactionsLandscapeTableViewCell" owner:self options:nil];
        cell = transactionCell;
        
        UILabel* label = (UILabel*) [cell viewWithTag:1];
        label.text = @"date";
        //label.text = transaction.creationTime;
        label = (UILabel*) [cell viewWithTag:2];
        label.text = transaction.transactionType;
        label = (UILabel*) [cell viewWithTag:3];
        label.text = transaction.accountName;
        label = (UILabel*) [cell viewWithTag:4];
        label.text = transaction.description;
        label = (UILabel*) [cell viewWithTag:5];
        label.text = [transaction.amount.amount stringValue];
        
    }
    else
    {
        [[NSBundle mainBundle] loadNibNamed:@"TransactionsTableViewCell" owner:self options:nil];
        cell = transactionCell;
        
        UILabel* label = (UILabel*) [cell viewWithTag:1];
        label.text = @"date";
        //label.text = transaction.creationTime;
        label = (UILabel*) [cell viewWithTag:2];
        label.text = transaction.transactionType;
        label = (UILabel*) [cell viewWithTag:3];
        label.text = transaction.accountName;
        label = (UILabel*) [cell viewWithTag:4];
        label.text = transaction.description;
        label = (UILabel*) [cell viewWithTag:5];
        label.text = [transaction.amount.amount stringValue];
    }
    return  cell;
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

#pragma mark - helper methods

-(NSString*) convertDateToRequiredFormat:(NSDate*) date
{
    if(date)
    {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents* dateComponents = [gregorianCalendar components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date];
        BFDebugLog(@"DATE:%@",[NSString stringWithFormat:@"%d-%d-%d",[dateComponents year],[dateComponents month],[dateComponents day]]);
        return [NSString stringWithFormat:@"%d-%d-%d",[dateComponents year],[dateComponents month],[dateComponents day]];
    }
    else
        return  nil;
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
    
    NSString *errorString = [NSString stringWithString:@"Try Again!"];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceeded:(NSData *)data
{
    transactions = [BFTransaction transactionsFromJSONData:data];
    [transectionTBL reloadData];
}




#pragma mark - handling the filter view click events

-(IBAction)dateBTNClicked:(id)sender
{
    UIButton *button = sender;
    if(button == toDateBTN)
    {
        currentSelectedDateType = ToDate;
    }
    else
    {
        currentSelectedDateType = FromDate;
    }
    if (!datedropdown) {
        DatePickerViewController *controller = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
        
        datedropdown = [[UIPopoverController alloc] initWithContentViewController:controller];
        controller.popOver = datedropdown;
        controller.delegate = self;
        [datedropdown setPopoverContentSize:controller.view.frame.size];
    }
    if ([datedropdown isPopoverVisible]) {
        [datedropdown dismissPopoverAnimated:YES];
    } else {
        DatePickerViewController *controller = (DatePickerViewController*)datedropdown.contentViewController;
        [datedropdown setPopoverContentSize:controller.view.frame.size];
        [datedropdown presentPopoverFromRect: button.frame  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}


-(IBAction)accountsBTNClicked:(id)sender
{
    
}

-(IBAction)clearBTNClicked:(id)sender
{
    
}

-(IBAction)applyBTNClicked:(id)sender
{
    NSString* urlString = [NSString stringWithFormat:@"http://archfirst.org/bfoms-javaee/rest/secure/transactions?fromDate=%@&toDate=%@",[self convertDateToRequiredFormat:fromDate],[self convertDateToRequiredFormat:toDate]];
    BFDebugLog(@"url string: %@",urlString);
    [self.restServiceObject getRequestWithURL:[NSURL URLWithString:urlString]];
}




#pragma mark - DatePickerViewController delegate methods

- (void)dateSelectionChanged:(DatePickerViewController *)controller
{
    if(currentSelectedDateType == ToDate)
    {
        toDate = controller.datePicker.date;
        
    }
    else
    {
        fromDate = controller.datePicker.date;
    }
}



@end
