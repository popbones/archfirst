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
#import "BFTransaction.h"
#import "BFBrokerageAccount.h"
#import "BFBrokerageAccountStore.h"
#import <QuartzCore/QuartzCore.h>

@implementation TransactionsViewController
@synthesize transectionTBL,portraitTableHeaderView,landscrapeTableHeaderView,transactions,datedropdown,dropdown,toDateDropDownCTL,toDateDropDownView,fromDateDropDownCTL,fromDateDropDownView,accountDropDownCTL,accountDropDownView;
@synthesize accName, accountOptions, actionSheet;
@synthesize accNamePickerList, textPlace;

#pragma  mark - view controller life cycle

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
    [self sync];
    
    //NSArray *accountList = [[NSArray alloc] initWithObjects:@"one",@"two" nil];
    // define list options
    
    //accountOptions = [[NSMutableArray alloc] init];
    
    //[accountOptions addObject:@"All Accounts"];
    
    //[accountOptions addObject:@"Account 1"];
    
    //[accountOptions addObject:@"Account 2"];
    //NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    //NSArray *list = [NSArray arrayWithArray:<#(NSArray *)#>]
    //accountOptions = [[NSMutableArray alloc]initWithArray:brokerageAccounts];
    //accountOptions = [NSArray arrayWithArray:brokerageAccounts];
    // default list option to select
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    //accountOptions = [NSArray arrayWithArray:brokerageAccounts];
    accountOptions = [[NSArray alloc]initWithArray:brokerageAccounts];
    selectedAccountId = 0;
    
    
    
    toDate = [NSDate date];
    fromDate = [NSDate date];
    
    accountDropDownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0, accountDropDownView.frame.size.width, accountDropDownView.frame.size.height)
                                                         target:self
                                                         action:@selector(showAccountDropdownMenu:)];
    accountDropDownCTL.label.text = @"All Accounts";
    accountDropDownCTL.label.font = [UIFont systemFontOfSize:13.0];
    [accountDropDownView addSubview:accountDropDownCTL];
    
    fromDateDropDownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0, fromDateDropDownView.frame.size.width, fromDateDropDownView.frame.size.height)
                                                         target:self
                                                         action:@selector(showDateDropdownMenu:)];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    fromDateDropDownCTL.label.text = [NSString stringWithFormat:@"From: %@",[dateFormat stringFromDate:fromDate]];
    fromDateDropDownCTL.label.font = [UIFont systemFontOfSize:13.0];
    [fromDateDropDownView addSubview:fromDateDropDownCTL];
    
    toDateDropDownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0, toDateDropDownView.frame.size.width, toDateDropDownView.frame.size.height)
                                                          target:self
                                                          action:@selector(showDateDropdownMenu:)];
    toDateDropDownCTL.label.text = [NSString stringWithFormat:@"To: %@",[dateFormat stringFromDate:toDate]];
    toDateDropDownCTL.label.font = [UIFont systemFontOfSize:13.0];
    [toDateDropDownView addSubview:toDateDropDownCTL];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    //label.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = label;
    label.text = @"Transactions";
    label.textColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    [label sizeToFit];
    portraitTableHeaderView.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    landscrapeTableHeaderView.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:@"USER_LOGOUT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin:) name:@"USER_LOGIN" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBTNClicked:) name:@"REFRESH_TRANSACTIONS" object:nil];
    
    selectedAccountId = -1;
}

-(void) viewDidAppear:(BOOL)animated
{
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        transectionTBL.tableHeaderView = landscrapeTableHeaderView;
    } 
    else 
    {
        transectionTBL.tableHeaderView = portraitTableHeaderView;
    }
    
    
    //populating the table with data for the last two months for all accounts
    [self applyBTNClicked:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    
}


-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        transectionTBL.tableHeaderView = landscrapeTableHeaderView;
    } 
    else 
    {
        transectionTBL.tableHeaderView = portraitTableHeaderView;
    }
    [self.transectionTBL reloadData];
}

#pragma mark - KVO lifecycle

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
}

#pragma mark - IBActions
- (IBAction)refreshBTNClicked:(id)sender 
{
    [self applyBTNClicked:nil];
}

#pragma mark - Table view data source

-(UIView *) tableView:(UITableView*) tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 30)];
    sectionHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AccountDivider-Background.jpg"]];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 748, 22)];
    BFTransaction* transaction = [[transactions objectAtIndex:section] objectAtIndex:0];
    label.text = [NSString stringWithFormat:@"%@ - %d",transaction.accountName,transaction.accountId.intValue];
    label.font = [UIFont systemFontOfSize:13];
    //label.textAlignment = UITextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [sectionHeaderView addSubview:label];
    return sectionHeaderView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return transactions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ((NSArray*)[transactions objectAtIndex:section]).count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIInterfaceOrientation toOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    BFTransaction* transaction = [((NSArray*)[transactions objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy/MM/dd hh:mm a"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    UITableViewCell* cell = transactionCell;
    if(toOrientation ==UIInterfaceOrientationLandscapeLeft || toOrientation ==UIInterfaceOrientationLandscapeRight)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TransactionsLandscapeTableViewCell" owner:self options:nil];
        cell = transactionCell;
        
        UILabel* label = (UILabel*) [cell viewWithTag:1];
        label.text = [dateFormat stringFromDate:transaction.creationTime];
        //label.text = transaction.creationTime;
        label = (UILabel*) [cell viewWithTag:2];
        label.text = transaction.transactionType;
        label = (UILabel*) [cell viewWithTag:3];
        label.text = transaction.description;
        label = (UILabel*) [cell viewWithTag:4];
        label.text = [formatter stringFromNumber:transaction.amount.amount];
        UIView *selected = [[UIView alloc] initWithFrame:cell.contentView.frame];
        selected.backgroundColor=[UIColor colorWithRed:255/255.0 green:237/255.0 blue:184/255.0 alpha:1];
        cell.selectedBackgroundView = selected;
        
        
    }
    else
    {
        [[NSBundle mainBundle] loadNibNamed:@"TransactionsTableViewCell" owner:self options:nil];
        cell = transactionCell;
        
        UILabel* label = (UILabel*) [cell viewWithTag:1];
        label.text = [dateFormat stringFromDate:transaction.creationTime];
        //label.text = transaction.creationTime;
        label = (UILabel*) [cell viewWithTag:2];
        label.text = transaction.transactionType;
        label = (UILabel*) [cell viewWithTag:3];
        label.text = transaction.description;
        label = (UILabel*) [cell viewWithTag:4];
        label.text = [formatter stringFromNumber:transaction.amount.amount];
        UIView *selected = [[UIView alloc] initWithFrame:cell.contentView.frame];
        selected.backgroundColor=[UIColor colorWithRed:255/255.0 green:237/255.0 blue:184/255.0 alpha:1];
        cell.selectedBackgroundView = selected;
    }
    
    return  cell;
        
    }
    else {
        static NSString *CellIdentifier = @"AccountNameCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = transaction.description;
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


#pragma mark - selectors for handling rest call callbacks

-(void)receivedData:(NSData *)data
{
    
}

-(void)responseReceived:(NSURLResponse *)data
{
    
}

-(void)requestFailed:(NSError *)error
{   
    
    NSString *errorString = @"Try Again!";
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceeded:(NSData *)data
{
    NSMutableArray* tempTransactions = [BFTransaction transactionsFromJSONData:data];
    
    NSSortDescriptor* sortByAccountName=[[NSSortDescriptor alloc] initWithKey:@"accountName" ascending:YES];
    NSSortDescriptor* sortByAccountId = [[NSSortDescriptor alloc] initWithKey:@"accountId" ascending:NO];
    
    [tempTransactions sortUsingDescriptors:[NSArray arrayWithObjects:sortByAccountName,sortByAccountId, nil]];
    
    transactions = [[NSMutableArray alloc]init];
    NSNumber* currentAccountId;
    NSNumber* previousAccountId = [NSNumber numberWithInt:-1];
    NSMutableArray* subArray=[[NSMutableArray alloc] init];
    for (BFTransaction *tempTransaction in tempTransactions) 
    {
        currentAccountId = tempTransaction.accountId;
        if(currentAccountId.intValue != previousAccountId.intValue)
        {
            if(subArray.count !=0)
            {
                [transactions addObject:subArray];
                subArray=[[NSMutableArray alloc] init];
            }
        }
        [subArray addObject:tempTransaction];
        
        previousAccountId = tempTransaction.accountId;
    }
    if(subArray.count !=0)
    {
        [transactions addObject:subArray];
    }
    
    
    [transectionTBL reloadData];
}




#pragma mark - handling the filter view click events

-(IBAction)showDateDropdownMenu:(id)sender
{
    
    DropDownControl *dropdownCTL = sender;
    if(dropdownCTL == toDateDropDownCTL)
    {
        currentSelectedDateType = ToDate;
    }
    else
    {
        currentSelectedDateType = FromDate;
    }
    
    CGPoint origin = [self.view convertPoint:dropdownCTL.arrowRect.origin fromView:dropdownCTL];
    CGRect dropdownRect = CGRectMake(origin.x, origin.y, dropdownCTL.arrowRect.size.width, dropdownCTL.arrowRect.size.height);
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
        if(currentSelectedDateType == ToDate)
        {
            if(toDate == nil)
                [controller.datePicker setDate:[NSDate date]];
            else
                [controller.datePicker setDate:toDate];
        }
        else
        {
            if(fromDate == nil)
                [controller.datePicker setDate:[NSDate date]];
            else
                [controller.datePicker setDate:fromDate];
        }
        
        [datedropdown setPopoverContentSize:controller.view.frame.size];
        [datedropdown presentPopoverFromRect: dropdownRect  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
   if(fromDate!=nil)
    fromDateDropDownCTL.label.text = [NSString stringWithFormat:@"From: %@",[dateFormat stringFromDate:fromDate]];
    if(toDate!=nil)
    toDateDropDownCTL.label.text = [NSString stringWithFormat:@"To: %@",[dateFormat stringFromDate:toDate]];
    
   
    
    
}


-(void)showAccountDropdownMenu:(id)sender
{
    DropDownControl* dropdownCTL = sender;
    NSArray *selections;
    CGSize size;
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    selections = [NSArray arrayWithArray:brokerageAccounts];
    size.height = [selections count] * 44;
    if ([selections count] > 5) {
        size.height = 220;
    }
    size.width = 320;
    
    CGPoint origin = [self.view convertPoint:dropdownCTL.arrowRect.origin fromView:dropdownCTL];
    CGRect dropdownRect = CGRectMake(origin.x, origin.y, dropdownCTL.arrowRect.size.width, dropdownCTL.arrowRect.size.height);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    if (!dropdown) {
        AccountDropDownViewControiller *controller = [[AccountDropDownViewControiller alloc] initWithNibName:@"DropdownViewController" bundle:nil];
        controller.allAccountsOption = YES;
        dropdown = [[UIPopoverController alloc] initWithContentViewController:controller];
        controller.popOver = dropdown;
        controller.selections = selections;
        controller.accountDelegate = self;
        [dropdown setPopoverContentSize:size];
    }
    if ([dropdown isPopoverVisible]) {
        [dropdown dismissPopoverAnimated:YES];
    } else {
        DropdownViewController *controller = (DropdownViewController *)dropdown.contentViewController;
        controller.selections = selections;
        [controller.selectionsTBL reloadData];
        [dropdown setPopoverContentSize:size];
        [dropdown presentPopoverFromRect: dropdownRect  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    }
    else{
        
        
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, dropdownCTL.arrowRect.size.width, dropdownCTL.arrowRect.size.height)]; //<- change to where you want it to show.
        
        customView.alpha = 0.0;
        customView.layer.cornerRadius = 5;
        customView.layer.borderWidth = 1.5f;
        //customView.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), YourColorValues);
        customView.layer.masksToBounds = YES;
        
        [self.view addSubview:customView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [customView setAlpha:1.0];
        [UIView commitAnimations];
        [UIView setAnimationDuration:0.0];
        
        /*
        //DropdownViewController *controller = (DropdownViewController *)dropdown.contentViewController;
        DropdownViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountsDropDownView"];
        controller.selections = selections;
        [controller.selectionsTBL reloadData];

        //DropdownViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountsDropDownView"];
        //[dvc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self addChildViewController: controller];
        //[self presentViewController:controller animated:NO completion:NULL];
        
        
        [controller didMoveToParentViewController:self];
         */
    }
    
}

-(IBAction)resetBTNClicked:(id)sender
{
    toDate = [NSDate date];
    fromDate= [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    fromDateDropDownCTL.label.text = [NSString stringWithFormat:@"From: %@",[dateFormat stringFromDate:fromDate]];
    toDateDropDownCTL.label.text = [NSString stringWithFormat:@"To: %@",[dateFormat stringFromDate:toDate]];
        
    accountDropDownCTL.label.text = @"All Accounts";
    selectedAccountId = -1;
}

-(IBAction)applyBTNClicked:(id)sender
{
    NSString* urlString;
    
    NSString* accountParam;
    NSString* fromDateParam;
    NSString* toDateParam;
    
    if(selectedAccountId == -1)
    {
        accountParam = @"";
    }
    else
    {
        accountParam = [NSString stringWithFormat:@"&accountId=%d",selectedAccountId];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    if(fromDate == nil)
    {
        fromDateParam = @"";
    }
    else
    {
        fromDateParam = [NSString stringWithFormat:@"&fromDate=%@",[dateFormat stringFromDate:fromDate]];
    }
    
    if(toDate == nil)
    {
        toDateParam = @"";
    }
    else
    {
        toDateParam = [NSString stringWithFormat:@"&toDate=%@",[dateFormat stringFromDate:toDate]];
    }
    
    
    BFDebugLog(@"ACC ID %d",selectedAccountId);
    
    urlString= [NSString stringWithFormat:@"http://archfirst.org/bfoms-javaee/rest/secure/transactions?%@%@%@",accountParam,fromDateParam,toDateParam];
    BFDebugLog(@"url string: %@",urlString);
    [self.restServiceObject getRequestWithURL:[NSURL URLWithString:urlString]];
}




#pragma mark - DatePickerViewController delegate methods

- (void)dateSelectionChanged:(DatePickerViewController *)controller
{
    NSDate* date = controller.datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    if(currentSelectedDateType == ToDate)
    {
        toDateDropDownCTL.label.text = [NSString stringWithFormat:@"To: %@", [dateFormat stringFromDate:date]];
        toDate = [date copy];
    }
    else
    {
        fromDateDropDownCTL.label.text = [NSString stringWithFormat:@"From: %@", [dateFormat stringFromDate:date]];
        fromDate = [date copy];
    }

}

-(void) datePickerCleared:(DatePickerViewController *) controller
{
    if(currentSelectedDateType == ToDate)
    {
        toDate = nil;
        toDateDropDownCTL.label.text = [NSString stringWithFormat:@"To: "];
    }
    else if (currentSelectedDateType == FromDate)
    {
        fromDate = nil;
        fromDateDropDownCTL.label.text = [NSString stringWithFormat:@"From: "];
        
    }
}

#pragma mark - DropDownViewController delegate methods

-(void) accountSelectionChanged:(AccountDropDownViewControiller *)controller
{
        BFBrokerageAccount* brokerageAccount =  [[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts] objectAtIndex:controller.selectedIndex];
        selectedAccountId = [brokerageAccount.brokerageAccountID intValue];
        accountDropDownCTL.label.text = brokerageAccount.name;
}

- (void)allAccountsClicked:(AccountDropDownViewControiller*) controller
{
    selectedAccountId = -1;
    accountDropDownCTL.label.text = @"All Accounts";
}

#pragma mark MVC Delegate methods

-(void)userLogout:(NSNotification*)notification
{
    [transactions removeAllObjects];
    [transectionTBL reloadData];
    selectedAccountId = -1;
    toDate = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    fromDate = [NSDate date];
    fromDateDropDownCTL.label.text = [NSString stringWithFormat:@"From: %@",[dateFormat stringFromDate:fromDate]];
    toDateDropDownCTL.label.text = [NSString stringWithFormat:@"To: %@",[dateFormat stringFromDate:toDate]];
    
    
    accountDropDownCTL.label.text = @"All Accounts";
}

-(void)userLogin:(NSNotification*)notification
{
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [accountOptions count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [accountOptions objectAtIndex:row];
    
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 120, 22);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        //s[pickerLabel setTextAlignment:UITextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:12]];
    }
    BFBrokerageAccount *account = [accountOptions objectAtIndex:row];
    [pickerLabel setText:[NSString stringWithFormat:@"%@", account.name]];
    //[pickerLabel setText:[accountOptions objectAtIndex:row]];
    return pickerLabel;
}
// this method runs whenever the user changes the selected list option

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // update label text to show selected option
    
    accName.text = [accountOptions objectAtIndex:row];
    
    // keep track of selected option (for next time we open the picker)
    
    selectedAccountId = row;
    
}
-(IBAction)showAccountOptions:(id)sender
{
    accNamePickerList.dataSource = self;
    
    accNamePickerList.delegate = self;
    accNamePickerList.showsSelectionIndicator = YES;
    [accNamePickerList selectRow:selectedAccountId inComponent:0 animated:NO];
    if(accNamePickerList.alpha == 0)
        accNamePickerList.alpha = 1;
    else accNamePickerList.alpha = 0;
    
    /*
    // create action sheet
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    // create frame for picker view
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    // create picker view
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    
    pickerView.showsSelectionIndicator = YES;
    
    pickerView.dataSource = self;
    
    pickerView.delegate = self;
    
    // set selected option to what was previously selected
    
    [pickerView selectRow:selectedAccountId inComponent:0 animated:NO];
    
    // add picker view to action sheet
    
    [actionSheet addSubview:pickerView];
    
    
    
    // create close button to hide action sheet
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    
    closeButton.momentary = YES;
    
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    
    closeButton.tintColor = [UIColor blackColor];
    
    // link close button to our dismissActionSheet method
    
    [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
    
   // [actionSheet addSubview:closeButton];
    
    
    
    // show action sheet
    
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
     */
}
- (IBAction)saveAccName:(id)sender
{
    
    [self sync];
    accNamePickerList.alpha = 0;
}
- (void) dismissActionSheet {
    
    // hide action sheet
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
}


-(void) sync
{
    if([accNamePickerList selectedRowInComponent:0] >= 0)
    {
        BFBrokerageAccount *account = [accountOptions objectAtIndex:[accNamePickerList selectedRowInComponent:0]];
        [textPlace setText:[NSString stringWithFormat:@"%@", account.name]];
    }
       // [textPlace setText:[accountOptions objectAtIndex:[accNamePickerList selectedRowInComponent:0]]];
}

@end