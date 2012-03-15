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
#import "OrderBTN.h"
#import "DatePickerViewController.h"
#import "BFBrokerageAccountStore.h"
#import "BFBrokerageAccount.h"
#import "expandPositionBTN.h"
#import "MultiSelectDropdownViewController.h"

@implementation OrdersViewController
@synthesize resetBTN;
@synthesize applyBTN;
@synthesize orderStatusLabel;
@synthesize orderId;
@synthesize symbol;
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
@synthesize cancelOrderServiceObject;
@synthesize accountDropdownView;
@synthesize fromDateDropdownView;
@synthesize fromDateDropdownCTL;
@synthesize toDateDropdownView;
@synthesize toDateDropdownCTL;
@synthesize orderDropdownView;
@synthesize accountDropdownCTL;
@synthesize orderDropdownCTL;
@synthesize orderStatusDropdownView;
@synthesize orderStatusDropdownCTL;
@synthesize expanedRowSet;
@synthesize multiSelectdropdown;
@synthesize instrumentDropdown;
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
    
    cancelOrderServiceObject = [[BullFirstWebServiceObject alloc] initWithObject:self 
                                                                responseSelector:nil 
                                                             receiveDataSelector:nil
                                                                 successSelector:@selector(cancelRequestSucceeded:) 
                                                                   errorSelector:@selector(cancelRequestFailed:)];
    
    
    
    fromDateDropdownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0, fromDateDropdownView.frame.size.width, fromDateDropdownView.frame.size.height)
                                                          target:self
                                                          action:@selector(dateDropdownClicked:)];
    fromDateDropdownCTL.tag = 1;
    fromDateDropdownCTL.label.font = [UIFont systemFontOfSize:13];
    [fromDateDropdownView addSubview:fromDateDropdownCTL];
    
    toDateDropdownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0, toDateDropdownView.frame.size.width, toDateDropdownView.frame.size.height)
                                                        target:self
                                                        action:@selector(dateDropdownClicked:)];
    toDateDropdownCTL.tag = 2;
    toDateDropdownCTL.label.font = [UIFont systemFontOfSize:13];
    [toDateDropdownView addSubview:toDateDropdownCTL];
    
    accountDropdownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0, accountDropdownView.frame.size.width, accountDropdownView.frame.size.height)
                                                         target:self
                                                         action:@selector(dropDownClicked:)];
    accountDropdownCTL.tag = 3;
    accountDropdownCTL.label.font = [UIFont systemFontOfSize:13];
    [accountDropdownView addSubview:accountDropdownCTL];
    
    orderDropdownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0, orderDropdownView.frame.size.width, orderDropdownView.frame.size.height)
                                                       target:self
                                                       action:@selector(dropDownClicked:)];
    orderDropdownCTL.tag = 4;
    orderDropdownCTL.label.font = [UIFont systemFontOfSize:13];
    [orderDropdownView addSubview:orderDropdownCTL];
    
    orderStatusDropdownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0, orderStatusDropdownView.frame.size.width, orderStatusDropdownView.frame.size.height)
                                                             target:self
                                                             action:@selector(multSelectDropDownClicked:)];
    orderStatusDropdownCTL.tag = 5;
    orderStatusDropdownCTL.label.font = [UIFont systemFontOfSize:13];
    [orderStatusDropdownView addSubview:orderStatusDropdownCTL];
    symbol.delegate=self;
    [self resetBTNClicked:nil];
    [self applyBTNClicked:nil];
    [symbol addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];

}

- (void)viewDidUnload
{
    [self setOrderTBL:nil];
    [self setPortraitTitleBar:nil];
    [self setLandscrapeTitleBar:nil];
    [self setOrderTableViewCell:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TRADE_ORDER_SUBMITTED" object:nil];
    [self setOrderFilterView:nil];
    [self setResetBTN:nil];
    [self setApplyBTN:nil];
    [self setOrderStatusLabel:nil];
    [self setOrderId:nil];
    [self setSymbol:nil];
    [self setFromDateDropdownView:nil];
    [self setToDateDropdownView:nil];
    [self setAccountDropdownView:nil];
    [self setOrderDropdownView:nil];
    [super viewDidUnload];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect rect=orderFilterView.frame;
    if(toInterfaceOrientation==UIDeviceOrientationLandscapeRight||toInterfaceOrientation==UIDeviceOrientationLandscapeLeft)
    {
        rect=resetBTN.frame;
        resetBTN.frame = CGRectMake(885, rect.origin.y,rect.size.width, rect.size.height);
        rect=applyBTN.frame;
        applyBTN.frame = CGRectMake(885, rect.origin.y,rect.size.width, rect.size.height);
        rect=accountDropdownView.frame;
        accountDropdownView.frame = CGRectMake(204, rect.origin.y,rect.size.width, rect.size.height);
        rect=fromDateDropdownView.frame;
        fromDateDropdownView.frame = CGRectMake(475, rect.origin.y,rect.size.width, rect.size.height);
        rect=toDateDropdownView.frame;
        toDateDropdownView.frame = CGRectMake(655, rect.origin.y,rect.size.width, rect.size.height);
        rect=orderDropdownView.frame;
        orderDropdownView.frame = CGRectMake(204, rect.origin.y,rect.size.width, rect.size.height);
        rect=orderStatusDropdownView.frame;
        orderStatusDropdownView.frame = CGRectMake(475, rect.origin.y,rect.size.width, rect.size.height);
        orderTBL.tableHeaderView = landscrapeTitleBar;
    }
    else
    {        
        rect=resetBTN.frame;
        resetBTN.frame = CGRectMake(640, rect.origin.y,rect.size.width, rect.size.height);
        rect=applyBTN.frame;
        applyBTN.frame = CGRectMake(640, rect.origin.y,rect.size.width, rect.size.height);
        rect=accountDropdownView.frame;
        accountDropdownView.frame = CGRectMake(114, rect.origin.y,rect.size.width, rect.size.height);
        rect=fromDateDropdownView.frame;
        fromDateDropdownView.frame = CGRectMake(287, rect.origin.y,rect.size.width, rect.size.height);
        rect=toDateDropdownView.frame;
        toDateDropdownView.frame = CGRectMake(467, rect.origin.y,rect.size.width, rect.size.height);
        rect=orderDropdownView.frame;
        orderDropdownView.frame = CGRectMake(114, rect.origin.y,rect.size.width, rect.size.height);
        rect=orderStatusDropdownView.frame;
        orderStatusDropdownView.frame = CGRectMake(287, rect.origin.y,rect.size.width, rect.size.height);
        orderTBL.tableHeaderView = portraitTitleBar;
    }
    if ([datedropdown isPopoverVisible]) {
        [datedropdown dismissPopoverAnimated:NO];
       
    }
    if ([dropdown isPopoverVisible]) {
        [dropdown dismissPopoverAnimated:NO];
    }
    if ([multiSelectdropdown isPopoverVisible]) {
        [multiSelectdropdown dismissPopoverAnimated:NO];
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
    NSMutableArray* tempOrders = [BFOrder ordersFromJSONData:data];
    
    NSSortDescriptor* sortByAccountName=[[NSSortDescriptor alloc] initWithKey:@"accountName" ascending:YES];
    NSSortDescriptor* sortByAccountId = [[NSSortDescriptor alloc] initWithKey:@"brokerageAccountID" ascending:NO];
    
    [tempOrders sortUsingDescriptors:[NSArray arrayWithObjects:sortByAccountName,sortByAccountId, nil]];
    
    expanedRowSet = [[NSMutableArray alloc] init];
    orders = [[NSMutableArray alloc]init];
    NSNumber* currentAccountId;
    NSNumber* previousAccountId = [NSNumber numberWithInt:-1];
    NSMutableArray* subArray=[[NSMutableArray alloc] init];
    NSMutableArray* subExpandArray=[[NSMutableArray alloc] init];
    for (BFOrder *order in tempOrders) 
    {
        currentAccountId = order.brokerageAccountID;
        if(currentAccountId.intValue != previousAccountId.intValue)
        {
            if(subArray.count !=0)
            {
                [orders addObject:subArray];
                subArray=[[NSMutableArray alloc] init];
                [expanedRowSet addObject:subExpandArray];
                subExpandArray=[[NSMutableArray alloc] init];
            }
        }
        [subArray addObject:order];
        [subExpandArray addObject:[NSNumber numberWithBool:NO]];
        
        previousAccountId = order.brokerageAccountID;
    }
    if(subArray.count !=0)
    {
        [orders addObject:subArray];
        [expanedRowSet addObject:subExpandArray];
    }
    
    [orderTBL reloadData];
}

-(void)cancelRequestFailed:(NSError *)error
{       
    NSString *errorString = [NSString stringWithString:@"Can't cancel this order!"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)cancelRequestSucceeded:(NSData *)data
{    
    [self applyBTNClicked:nil];
}

#pragma mark - KVO lifecycle

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
}

#pragma mark - IBActions

-(void)expandPosition:(id)sender
{
    expandPositionBTN *button = (expandPositionBTN *)sender;
    
    NSNumber *expand_Row = [((NSArray*)[expanedRowSet objectAtIndex:button.indexPath.section]) objectAtIndex:button.indexPath.row];
    if (expand_Row != nil && [expand_Row boolValue] == YES) {
        NSMutableArray *tempArray =[expanedRowSet objectAtIndex:button.indexPath.section];
        [tempArray replaceObjectAtIndex:button.indexPath.row withObject:[NSNumber numberWithBool:NO]];
    } else {
        NSMutableArray *tempArray =[expanedRowSet objectAtIndex:button.indexPath.section];
        [tempArray replaceObjectAtIndex:button.indexPath.row withObject:[NSNumber numberWithBool:YES]];
    }
    [orderTBL reloadData];
}

- (IBAction)refreshBTNClicked:(id)sender { 
    [self applyBTNClicked:nil];
    //    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/orders"];
    //    [self.restServiceObject getRequestWithURL:url];    
}
- (void)showInstrumentDropdownMenu {
    NSArray *instruments = [BFInstrument getAllInstruments];
    if ([instruments count] < 1)
        return;
    
    CGSize size = CGSizeMake(320, 220);
    
    if (!instrumentDropdown) {
        InstrumentsDropdownViewController *controller = [[InstrumentsDropdownViewController alloc] initWithNibName:@"DropdownViewController" bundle:nil];
        
        instrumentDropdown = [[UIPopoverController alloc] initWithContentViewController:controller];
        controller.popOver = instrumentDropdown;
        controller.instrumentDelegate = self;
        [instrumentDropdown setPopoverContentSize:size];
    }
    if ([instrumentDropdown isPopoverVisible]) {
        [instrumentDropdown dismissPopoverAnimated:YES];
    } else {
        [instrumentDropdown presentPopoverFromRect:self.symbol.frame  inView: self.orderFilterView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}
- (void)instrumentSelectionChanged:(InstrumentsDropdownViewController *)controller
{
    BFInstrument *instrument = controller.selectedInstrument;
    self.symbol.text = instrument.symbol;
    if ([instrumentDropdown isPopoverVisible]) {
        [instrumentDropdown dismissPopoverAnimated:YES];
    } 
}
- (IBAction)dateDropdownClicked:(id)sender {
    DropDownControl *dropdownCTL = sender;
    
    if (!datedropdown) {
        DatePickerViewController *controller = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
        
        datedropdown = [[UIPopoverController alloc] initWithContentViewController:controller];
        controller.popOver = datedropdown;
        controller.delegate = self;
    }
    if ([datedropdown isPopoverVisible]) {
        [datedropdown dismissPopoverAnimated:YES];
    } else {
        CGPoint origin = [self.view convertPoint:dropdownCTL.arrowRect.origin fromView:dropdownCTL];
        CGRect dropdownRect = CGRectMake(origin.x, origin.y, dropdownCTL.arrowRect.size.width, dropdownCTL.arrowRect.size.height);
        
        DatePickerViewController *controller = (DatePickerViewController*)datedropdown.contentViewController;
        if(dropdownCTL.tag == 1)
        {
            if(fromDate == nil)
                [controller.datePicker setDate:[NSDate date]];
            else
                [controller.datePicker setDate:fromDate];
        }
        else if (dropdownCTL.tag == 2)
        {
            if(toDate == nil)
                [controller.datePicker setDate:[NSDate date]];
            else
                [controller.datePicker setDate:toDate];
        }
        controller.tag = dropdownCTL.tag;
        [datedropdown setPopoverContentSize:controller.view.frame.size];
        [datedropdown presentPopoverFromRect: dropdownRect  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
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
    
    fromDateDropdownCTL.label.text = [NSString stringWithFormat:@"From: %@",[dateFormat stringFromDate:fromDate]];
    toDateDropdownCTL.label.text = [NSString stringWithFormat:@"To: %@",[dateFormat stringFromDate:toDate]];
    accountDropdownCTL.label.text = [NSString stringWithFormat:@"Account: %@", accountSelected];
    orderDropdownCTL.label.text = [NSString stringWithFormat:@"Action: %@", orderType];
    orderStatusDropdownCTL.label.text = [NSString stringWithFormat:@"Order Status: %@", orderStatus];    
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
    
    NSString *symbolParam = @"";
    if ([symbol.text length]>0) {
        symbolParam = [NSString stringWithFormat:@"&symbol=%@",[symbol.text uppercaseString]];
    }
    
    NSString *orderIdParam = @"";
    if ([orderId.text length]>0) {
        orderIdParam = [NSString stringWithFormat:@"&orderId=%@",orderId.text];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *fromDateParam;
    if (fromDate !=nil)
        fromDateParam = [NSString stringWithFormat:@"&fromDate=%@",[dateFormat stringFromDate:fromDate]];
    
    NSString *toDateParam;
    if (toDate !=nil)
        toDateParam = [NSString stringWithFormat:@"&toDate=%@",[dateFormat stringFromDate:toDate]];
    
    NSString *orderTypeParam = @"";
    if ([orderType isEqualToString:@"All"] != YES) {
        orderTypeParam = [NSString stringWithFormat:@"&sides=%@",orderType];
    }
    
    NSString *orderStatusParam = @"";
    if ([orderStatus isEqualToString:@"All"] != YES) {
        orderTypeParam = [NSString stringWithFormat:@"&statuses=%@",orderStatus];
    }
    
    NSString *filter = [NSString stringWithFormat:@"http://archfirst.org/bfoms-javaee/rest/secure/orders?%@%@%@%@%@%@%@", fromDateParam, toDateParam, brokerageAccountIDParam, symbolParam, orderIdParam, orderTypeParam, orderStatusParam];
    BFDebugLog(@"filter = %@", filter);
    NSURL *url = [NSURL URLWithString:filter];
    [self.restServiceObject getRequestWithURL:url];    
}

- (IBAction)dropDownClicked:(id)sender {
    DropDownControl *dropdownCTL = sender;
    NSArray *selections;
    CGSize size;
    switch (dropdownCTL.tag) {
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
            selections = [NSArray arrayWithObjects:@"All", @"Buy", @"Sell", nil];
            size = [@"Buy" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]];
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
        controller.tag = dropdownCTL.tag;
        controller.delegate = self;
        [dropdown setPopoverContentSize:size];
    }
    if ([dropdown isPopoverVisible]) {
        [dropdown dismissPopoverAnimated:YES];
    } else {
        CGPoint origin = [self.view convertPoint:dropdownCTL.arrowRect.origin fromView:dropdownCTL];
        CGRect dropdownRect = CGRectMake(origin.x, origin.y, dropdownCTL.arrowRect.size.width, dropdownCTL.arrowRect.size.height);
        
        DropdownViewController *controller = (DropdownViewController *)dropdown.contentViewController;
        controller.tag = dropdownCTL.tag;
        controller.selections = selections;
        [controller.selectionsTBL reloadData];
        [dropdown setPopoverContentSize:size];
        [dropdown presentPopoverFromRect: dropdownRect  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (IBAction)multSelectDropDownClicked:(id)sender {
    DropDownControl *dropdownCTL = sender;
    NSArray *selections;
    CGSize size;
    switch (dropdownCTL.tag) {
        case 5:
            selections = [NSArray arrayWithObjects:@"All", @"PendingNew", @"New", @"PartiallyFilled", @"Filled", @"PendingCancel", @"Canceled", @"DoneForDay", nil];
            size = [@"PartiallyFilled" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]];
            size.height = [selections count] * 44;
            size.width += 70;
            
            break;
            
        default:
            break;
    }
    
    if (!multiSelectdropdown) {
        MultiSelectDropdownViewController *controller = [[MultiSelectDropdownViewController alloc] initWithNibName:@"DropdownViewController" bundle:nil];
        
        multiSelectdropdown = [[UIPopoverController alloc] initWithContentViewController:controller];
        controller.popOver = multiSelectdropdown;
        controller.selections = selections;
        controller.tag = dropdownCTL.tag;
        controller.delegate = self;
        [multiSelectdropdown setPopoverContentSize:size];
    }
    if ([multiSelectdropdown isPopoverVisible]) {
        [multiSelectdropdown dismissPopoverAnimated:YES];
    } else {
        CGPoint origin = [self.view convertPoint:dropdownCTL.arrowRect.origin fromView:dropdownCTL];
        CGRect dropdownRect = CGRectMake(origin.x, origin.y, dropdownCTL.arrowRect.size.width, dropdownCTL.arrowRect.size.height);
        
        MultiSelectDropdownViewController *controller = (MultiSelectDropdownViewController *)dropdown.contentViewController;
        controller.tag = dropdownCTL.tag;
        controller.selections = selections;
        [controller.selectionsTBL reloadData];
        [multiSelectdropdown setPopoverContentSize:size];
        [multiSelectdropdown presentPopoverFromRect: dropdownRect  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (IBAction)cancelOrderBTNClicked:(id)sender {
    OrderBTN *button = (OrderBTN *)sender;
    BFOrder *order = button.order;
    
    NSString *urlString = [NSString stringWithFormat:@"http://archfirst.org/bfoms-javaee/rest/secure/orders/%d/cancel", [order.orderId intValue]];
    BFDebugLog(@"cancel order = %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    [self.cancelOrderServiceObject postRequestWithURL:url body:nil contentType:@"application/json"];
}



#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{   
    UIView* sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 30)];
    sectionHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AccountDivider-Background.jpg"]];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 748, 22)];
    BFOrder *order = [[orders objectAtIndex:section] objectAtIndex:0];
    label.text = [NSString stringWithFormat:@"%@ - %d",order.accountName,order.brokerageAccountID.intValue];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = UITextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [sectionHeaderView addSubview:label];
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *expand = [((NSArray*)[expanedRowSet objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    if (expand == nil || [expand boolValue] == NO)
        return 44;
    
    BFOrder *order = [((NSArray*)[orders objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    return 44*(1+[order.executionsPrice count]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [orders count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return  ((NSArray*)[orders objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    BFOrder *order = [((NSArray*)[orders objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSNumberFormatter *decemalFormatter = [[NSNumberFormatter alloc] init];  
    [decemalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
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
        [dateFormat setDateFormat:@"MM-dd-yyyy"];
        label.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:order.creationTime]];
        
        label = (UILabel *)[cell viewWithTag:2];
        label.text = [NSString stringWithFormat:@"%d", [order.orderId intValue]];
        
        label = (UILabel *)[cell viewWithTag:3];
        label.text = order.type;
        
        label = (UILabel *)[cell viewWithTag:4];
        label.text = order.instrumentSymbol;
        
        label = (UILabel *)[cell viewWithTag:5];
        label.text = [decemalFormatter stringFromNumber:order.quantity];
        
        if (order.limitPrice != nil) {
            label = (UILabel *)[cell viewWithTag:6];
            label.text = [formatter stringFromNumber:order.limitPrice.amount];
        }
        
        expandPositionBTN *expand = (expandPositionBTN *)[cell viewWithTag:11]; // expand button
        if (order.executionPrice != nil) {
            label = (UILabel *)[cell viewWithTag:7];
            label.text = [formatter stringFromNumber:order.executionPrice.amount];
            [expand addTarget:self action:@selector(expandPosition:) forControlEvents:UIControlEventTouchUpInside];
            expand.indexPath = indexPath;
            [expand setImage:[UIImage imageNamed:@"Plus.png"] forState:UIControlStateNormal];
        } else {
            expand.hidden = YES;
        }
        
        label = (UILabel *)[cell viewWithTag:8];
        label.text = order.status;
        
        label = (UILabel *)[cell viewWithTag:9];
        label.text = order.side;
        
        OrderBTN *cancelOrderBTN = (OrderBTN *)[cell viewWithTag:10]; // cancel button
        if ([order.status isEqualToString:@"New"] == YES ||
            [order.status isEqualToString:@"PendingNew"] == YES ||
            [order.status isEqualToString:@"PartiallyFilled"] == YES) {
            [cancelOrderBTN addTarget:self action:@selector(cancelOrderBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
            cancelOrderBTN.order = order;
        } else {
            cancelOrderBTN.hidden = YES;
        }
        
        NSNumber *expand_Row = [((NSArray*)[expanedRowSet objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
        if (expand_Row != nil && [expand_Row boolValue] == YES) {
            [expand setImage:[UIImage imageNamed:@"Minus.png"] forState:UIControlStateNormal];
            CGRect frame = cell.frame;
            cell.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 44*(1+[order.executionsPrice count]));
            
            UILabel *label;
            label = (UILabel *)[cell viewWithTag:5];
            CGRect quantityFrame = CGRectMake(label.frame.origin.x, label.frame.origin.y+44 ,label.frame.size.width, label.frame.size.height);
            label = (UILabel *)[cell viewWithTag:7];
            CGRect priceFrame = CGRectMake(label.frame.origin.x, label.frame.origin.y+44 ,label.frame.size.width, label.frame.size.height);
            
            for (NSDictionary *execution in order.executionsPrice) {
                NSDictionary *priceDic = [execution objectForKey:@"price"];
                UILabel *label = [[UILabel alloc] initWithFrame:priceFrame];
                NSNumber *amount = [NSNumber numberWithFloat:[[priceDic valueForKey:@"amount"] floatValue]];
                label.text = [formatter stringFromNumber:amount];
                label.font = [UIFont systemFontOfSize:13.0];
                label.textAlignment = UITextAlignmentRight;
                [cell addSubview:label];
                priceFrame.origin.y += 44;
                
                NSNumber *quantity = [NSNumber numberWithFloat:[[execution valueForKey:@"quantity"] intValue]];
                label = [[UILabel alloc] initWithFrame:quantityFrame];
                label.text = [decemalFormatter stringFromNumber:quantity];
                label.font = [UIFont systemFontOfSize:13.0];
                label.textAlignment = UITextAlignmentRight;
                [cell addSubview:label];
                quantityFrame.origin.y += 44;
            }
        }
        
        UIView *selected = [[UIView alloc] initWithFrame:cell.contentView.frame];
        selected.backgroundColor=[UIColor colorWithRed:255/255.0 green:237/255.0 blue:184/255.0 alpha:1];
        cell.selectedBackgroundView = selected;
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
        [dateFormat setDateFormat:@"MM-dd-yyyy"];
        label.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:order.creationTime]];
        
        label = (UILabel *)[cell viewWithTag:2];
        label.text = [NSString stringWithFormat:@"%d", [order.orderId intValue]];
        
        label = (UILabel *)[cell viewWithTag:3];
        label.text = order.type;
        
        label = (UILabel *)[cell viewWithTag:4];
        label.text = order.instrumentSymbol;
        
        label = (UILabel *)[cell viewWithTag:5];
        label.text = [decemalFormatter stringFromNumber:order.quantity];
        
        if (order.limitPrice != nil) {
            label = (UILabel *)[cell viewWithTag:6];
            label.text = [formatter stringFromNumber:order.limitPrice.amount];
        }
        
        expandPositionBTN *expand = (expandPositionBTN *)[cell viewWithTag:11]; // expand button
        if (order.executionPrice != nil) {
            label = (UILabel *)[cell viewWithTag:7];
            label.text = [formatter stringFromNumber:order.executionPrice.amount];
            [expand addTarget:self action:@selector(expandPosition:) forControlEvents:UIControlEventTouchUpInside];
            expand.indexPath = indexPath;
            [expand setImage:[UIImage imageNamed:@"Plus.png"] forState:UIControlStateNormal];
        } else {
            expand.hidden = YES;
        }
        
        label = (UILabel *)[cell viewWithTag:8];
        label.text = order.status;
        
        label = (UILabel *)[cell viewWithTag:9];
        label.text = order.side;
        
        OrderBTN *cancelOrderBTN = (OrderBTN *)[cell viewWithTag:10]; // cancel button
        if ([order.status isEqualToString:@"New"] == YES ||
            [order.status isEqualToString:@"PendingNew"] == YES ||
            [order.status isEqualToString:@"PartiallyFilled"] == YES) {
            [cancelOrderBTN addTarget:self action:@selector(cancelOrderBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
            cancelOrderBTN.order = order;
        } else {
            cancelOrderBTN.hidden = YES;
        }
        
        
        NSNumber *expand_Row = [((NSArray*)[expanedRowSet objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
        if (expand_Row != nil && [expand_Row boolValue] == YES) {
            [expand setImage:[UIImage imageNamed:@"Minus.png"] forState:UIControlStateNormal];
            CGRect frame = cell.frame;
            cell.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 44*(1+[order.executionsPrice count]));
            
            UILabel *label;
            label = (UILabel *)[cell viewWithTag:5];
            CGRect quantityFrame = CGRectMake(label.frame.origin.x, label.frame.origin.y+44 ,label.frame.size.width, label.frame.size.height);
            label = (UILabel *)[cell viewWithTag:7];
            CGRect priceFrame = CGRectMake(label.frame.origin.x, label.frame.origin.y+44 ,label.frame.size.width, label.frame.size.height);
            
            for (NSDictionary *execution in order.executionsPrice) {
                NSDictionary *priceDic = [execution objectForKey:@"price"];
                UILabel *label = [[UILabel alloc] initWithFrame:priceFrame];
                NSNumber *amount = [NSNumber numberWithFloat:[[priceDic valueForKey:@"amount"] floatValue]];
                label.text = [formatter stringFromNumber:amount];
                label.font = [UIFont systemFontOfSize:13.0];
                label.textAlignment = UITextAlignmentRight;
                [cell addSubview:label];
                priceFrame.origin.y += 44;
                
                NSNumber *quantity = [NSNumber numberWithFloat:[[execution valueForKey:@"quantity"] intValue]];
                label = [[UILabel alloc] initWithFrame:quantityFrame];
                label.text = [decemalFormatter stringFromNumber:quantity];
                label.font = [UIFont systemFontOfSize:13.0];
                label.textAlignment = UITextAlignmentRight;
                [cell addSubview:label];
                quantityFrame.origin.y += 44;
            }
        }
        
        UIView *selected = [[UIView alloc] initWithFrame:cell.contentView.frame];
        selected.backgroundColor=[UIColor colorWithRed:255/255.0 green:237/255.0 blue:184/255.0 alpha:1];
        cell.selectedBackgroundView = selected;
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
            fromDateDropdownCTL.label.text = [NSString stringWithFormat:@"From: %@", [dateFormat stringFromDate:date]];
            fromDate = [date copy];
            
//            if (toDate == nil) {
//                toDate = [fromDate copy];
//                toDateDropdownCTL.label.text = [NSString stringWithFormat:@"To: %@", [dateFormat stringFromDate:toDate]];
//            }
            break;
            
        case 2:
            toDateDropdownCTL.label.text = [NSString stringWithFormat:@"To: %@", [dateFormat stringFromDate:date]];
            toDate = [date copy];;
//            if (fromDate == nil) {
//                fromDate = [toDate copy];
//                fromDateDropdownCTL.label.text = [NSString stringWithFormat:@"From: %@", [dateFormat stringFromDate:fromDate]];
//            }
            break;
        default:
            break;
    }
}

- (void)datePickerCleared
{
    
}

- (void)selectionChanged:(DropdownViewController *)controller
{
    // Make sure this test happen first becasue MultiSelectDropdownViewController is a subclass of DropdownViewController
    if ([controller isKindOfClass:[MultiSelectDropdownViewController class]]){
        
        switch (controller.tag) {
            case 5: {
                MultiSelectDropdownViewController *multiSelect = (MultiSelectDropdownViewController *)controller;
                orderStatus = @"";
                for (NSString *tmp in multiSelect.selectedSet) {
                    orderStatus = [orderStatus stringByAppendingFormat:@"%@,", tmp]; 
                }
                NSRange zoneRange = {[orderStatus length]-1, 1};
                orderStatus = [orderStatus stringByReplacingOccurrencesOfString:@","
                                                                     withString:@""
                                                                        options:0
                                                                          range:zoneRange];
                orderStatusDropdownCTL.label.text = [NSString stringWithFormat:@"Order Status: %@", orderStatus];
                break;
            } 
            default:
                break;
        }
        return;
    }
    
    if ([controller isKindOfClass:[DropdownViewController class]]){
        
        switch (controller.tag) {
            case 3: {
                accountDropdownCTL.label.text = [NSString stringWithFormat:@"Account: %@", controller.selected];
                accountSelected = [NSString stringWithString:controller.selected];
                break;
            }
            case 4:
                orderDropdownCTL.label.text = [NSString stringWithFormat:@"Action: %@", controller.selected];
                orderType = [NSString stringWithString:controller.selected];
                break;
                
            default:
                break;
        }
        return;
    }
 
}

-(void) datePickerCleared:(DatePickerViewController *) controller
{
    if(controller.tag == 1)
    {
        fromDate = nil;
        fromDateDropdownCTL.label.text = [NSString stringWithString:@"From: "];
    }
    else if (controller.tag == 2)
    {
        toDate = nil;
        toDateDropdownCTL.label.text = [NSString stringWithString:@"To: "];
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
    if (activeTextField == self.symbol)
        [self showInstrumentDropdownMenu];
    else {
        if (instrumentDropdown.popoverVisible == YES)
            [instrumentDropdown dismissPopoverAnimated:YES];
    }
}
-(void) textChanged:(UITextField*) textField
{
    if (instrumentDropdown.popoverVisible == YES) {
        InstrumentsDropdownViewController *controller = (InstrumentsDropdownViewController *) instrumentDropdown.contentViewController;
        [controller filterInstrumentsWithString:textField.text];
    }
    else
    {
        [self showInstrumentDropdownMenu];
        InstrumentsDropdownViewController *controller = (InstrumentsDropdownViewController *) instrumentDropdown.contentViewController;
        [controller filterInstrumentsWithString:textField.text];
    }
}
@end
