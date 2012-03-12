//
//  TradeViewController.m
//  Bullsfirst
//
//  Created by Pong Choa on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TradeViewController.h"
#import "BFBrokerageAccountStore.h"
#import "BFBrokerageAccount.h"
#import "PreviewTradeViewController.h"
#import "BFInstrument.h"

@implementation TradeViewController
@synthesize position;
@synthesize cusipText;
@synthesize quantity;
@synthesize limit;
@synthesize allOrNone;
@synthesize allOrNoneLabel;
@synthesize actionDropDownView;
@synthesize activeTextField;
@synthesize textFields;
@synthesize dropdown;
@synthesize order;
@synthesize accountDropdown;
@synthesize accountDropDownView;
@synthesize accountDropDownCTL;
@synthesize priceDropDownView;
@synthesize goodForDayDropDownView;
@synthesize actionDropDownCTL;
@synthesize priceDropDownCTL;
@synthesize goodForDayDropDownCTL;
@synthesize restServiceObject;
@synthesize instrumentDropdown;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil position:(BFPosition *)aPosition
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.position = aPosition;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ModalView_TitleBar_BackgroundGradient.jpg"] forBarMetrics:UIBarMetricsDefault];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = barButtonItem;

    barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"Edit Order";
	self.navigationItem.backBarButtonItem = barButtonItem;
    self.navigationItem.title = @"Trade";
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];

    textFields = [NSArray arrayWithObjects:cusipText, quantity, limit, nil];
    order = [[BFOrder alloc] init];
    order.allOrNone = NO;
    order.term = [NSString stringWithString:@"Good for the day"];

    accountDropDownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0, accountDropDownView.frame.size.width, accountDropDownView.frame.size.height)
                                                        target:self
                                                        action:@selector(showAccountDropdownMenu:)];
    accountDropDownCTL.label.text = @"Accounts";
    accountDropDownCTL.label.font = [UIFont systemFontOfSize:13.0];
    accountDropDownCTL.tag = 1;
    [accountDropDownView addSubview:accountDropDownCTL];

    actionDropDownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0, actionDropDownView.frame.size.width, actionDropDownView.frame.size.height)
                                                         target:self
                                                         action:@selector(showDropdown:)];
    actionDropDownCTL.label.text = @"Action";
    actionDropDownCTL.label.font = [UIFont systemFontOfSize:13.0];
    actionDropDownCTL.tag = 2;
    [actionDropDownView addSubview:actionDropDownCTL];

    priceDropDownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0, priceDropDownView.frame.size.width, priceDropDownView.frame.size.height)
                                                        target:self
                                                        action:@selector(showDropdown:)];
    priceDropDownCTL.label.text = @"Order Type";
    priceDropDownCTL.label.font = [UIFont systemFontOfSize:13.0];
    priceDropDownCTL.tag = 3;
    [priceDropDownView addSubview:priceDropDownCTL];
    
    goodForDayDropDownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0, goodForDayDropDownView.frame.size.width, goodForDayDropDownView.frame.size.height)
                                                       target:self
                                                       action:@selector(showDropdown:)];
    goodForDayDropDownCTL.label.text = order.term;
    goodForDayDropDownCTL.label.font = [UIFont systemFontOfSize:13.0];
    goodForDayDropDownCTL.tag = 4;
    [goodForDayDropDownView addSubview:goodForDayDropDownCTL];
    
    if (self.position != nil) {
        order.accountName = self.position.accountName;
        order.brokerageAccountID = self.position.accountID;
        accountDropDownCTL.label.text = self.position.accountName;
        
        order.instrumentSymbol = self.position.instrumentSymbol;
        cusipText.text = self.position.instrumentSymbol;
        
        order.quantity = self.position.quantity;
        quantity.text = [NSString stringWithFormat:@"%d", [self.position.quantity intValue]];
    }
    
    self.limit.hidden = YES;

    restServiceObject = [[BullFirstWebServiceObject alloc] initWithObject:self 
                                                         responseSelector:@selector(responseReceived:) 
                                                      receiveDataSelector:@selector(receivedData:) 
                                                          successSelector:@selector(requestSucceeded:) 
                                                            errorSelector:@selector(requestFailed:)];

    NSArray *instruments = [BFInstrument getAllInstruments];
    if (instruments == nil) {
        NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfexch-javaee/rest/instruments"];        
        [restServiceObject getRequestWithURL:url];
    }
    
}

- (void)viewDidUnload
{
    [self setCusipText:nil];
    [self setQuantity:nil];
    [self setLimit:nil];
    [self setAllOrNone:nil];
    [self setAllOrNoneLabel:nil];
    [self setAccountDropDownView:nil];
    [self setActionDropDownView:nil];
    [self setPriceDropDownView:nil];
    [self setGoodForDayDropDownView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([instrumentDropdown isPopoverVisible])
        [instrumentDropdown dismissPopoverAnimated:YES];
    if ([dropdown isPopoverVisible])
        [dropdown dismissPopoverAnimated:YES];
    if ([accountDropdown isPopoverVisible])
        [accountDropdown dismissPopoverAnimated:YES];
	return YES;
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
    NSArray *instruments = [BFInstrument instrumentsFromJSONData:data];
    [BFInstrument setAllInstruments:instruments];
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
        UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
        {
            [instrumentDropdown presentPopoverFromRect:self.cusipText.frame  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        } else {
            [instrumentDropdown presentPopoverFromRect:self.cusipText.frame  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }
}

- (IBAction)showAccountDropdownMenu:(id)sender {
    DropDownControl *dropdownCTL = (DropDownControl *)sender;
    CGSize size;
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    size.height = [brokerageAccounts count] * 44;
    if ([brokerageAccounts count] > 5) {
        size.height = 220;
    }
    size.width = 320;
    
    CGPoint origin = [self.view convertPoint:dropdownCTL.arrowRect.origin fromView:dropdownCTL];
    CGRect dropdownRect = CGRectMake(origin.x, origin.y, dropdownCTL.arrowRect.size.width, dropdownCTL.arrowRect.size.height);
    
    if (!accountDropdown) {
        AccountDropDownViewControiller *controller = [[AccountDropDownViewControiller alloc] initWithNibName:@"DropdownViewController" bundle:nil];
        
        accountDropdown = [[UIPopoverController alloc] initWithContentViewController:controller];
        controller.popOver = accountDropdown;
        controller.selections = brokerageAccounts;
        controller.tag = dropdownCTL.tag;
        controller.accountDelegate = self;
        [accountDropdown setPopoverContentSize:size];
    }
    if ([accountDropdown isPopoverVisible]) {
        [accountDropdown dismissPopoverAnimated:YES];
    } else {
        AccountDropDownViewControiller *controller = (AccountDropDownViewControiller *) accountDropdown.contentViewController;
        controller.tag = dropdownCTL.tag;
        controller.selections = brokerageAccounts;
        [controller.selectionsTBL reloadData];
        [accountDropdown setPopoverContentSize:size];
        [accountDropdown presentPopoverFromRect: dropdownRect  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (IBAction)showDropdown:(id)sender {
    DropDownControl *dropdownCTL = (DropDownControl *)sender;
    NSArray *selections;
    CGSize size;
    switch (dropdownCTL.tag) {            
        case 2:
            selections = [NSArray arrayWithObjects:@"Buy", @"Sell", nil];
            size = [@"Buy" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]];
            size.height = [selections count] * 44;
            size.width += 20;
            break;
            
        case 3:
            selections = [NSArray arrayWithObjects:@"Market", @"Limit", nil];
            size = [@"Limited" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]];
            size.height = [selections count] * 44;
            size.width += 20;

            break;
            
        case 4:
            selections = [NSArray arrayWithObjects:@"Good for the day", @"Good till cancel", nil];
            size = [@"Good til cancel" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]];
            size.height = [selections count] * 44;
            size.width += 60;
            break;
            
        default:
            break;
    }

    CGPoint origin = [self.view convertPoint:dropdownCTL.arrowRect.origin fromView:dropdownCTL];
    CGRect dropdownRect = CGRectMake(origin.x, origin.y, dropdownCTL.arrowRect.size.width, dropdownCTL.arrowRect.size.height);

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
        DropdownViewController *controller = (DropdownViewController *)dropdown.contentViewController;
        controller.tag = dropdownCTL.tag;
        controller.selections = selections;
        [controller.selectionsTBL reloadData];
        [dropdown setPopoverContentSize:size];
        UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
        {
            [dropdown presentPopoverFromRect: dropdownRect  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        } else {
            [dropdown presentPopoverFromRect: dropdownRect  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }
}

- (IBAction)allOrNoneClicked:(id)sender {
    UIButton *button = sender;
    if (order.allOrNone == YES) {
        [button setImage:[UIImage imageNamed:@"CheckBox-Unchecked.png"] forState:UIControlStateNormal];
        order.allOrNone = NO;
    } else {
        [button setImage:[UIImage imageNamed:@"CheckBox-Checked.png"] forState:UIControlStateNormal];
        order.allOrNone = YES;
    }
}


- (IBAction)cancelBTNClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    [activeTextField resignFirstResponder];
}

- (IBAction)okBTNClicked:(id)sender {
    if ([order.accountName length] < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account" message:@"Account field is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    if ([order.side length] < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Action" message:@"Need to chose an action." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.cusipText.text length] < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Symbol" message:@"Need to enter a security symbol." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    order.instrumentSymbol = [NSString stringWithString:self.cusipText.text];

    if ([order.type length] < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Order" message:@"Need to chose an order type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    if ([self.quantity.text length] < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quanity" message:@"Need to enter a quantity." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    order.quantity = [NSNumber numberWithInt:[[NSString stringWithString:self.quantity.text] intValue]];
    
    if ([self.limit.text length] < 1 && [order.type isEqualToString:@"Limit"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Limited Price" message:@"Need to enter a limited price." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    order.limitPrice = [BFMoney moneyWithAmount:[NSNumber numberWithFloat:[self.limit.text floatValue]] currency:@"USD"];

    PreviewTradeViewController *controller = [[PreviewTradeViewController alloc] initWithNibName:@"PreviewTradeViewController" bundle:nil order:order];    
    [activeTextField resignFirstResponder];
    [self.navigationController pushViewController:controller animated:YES];

}

#pragma mark - text field lifecycle
- (void)previousBTNClicked:(id)sender {
    NSUInteger currentTextField = [textFields indexOfObject:activeTextField];
    if (currentTextField == 0)
        currentTextField = [textFields count] -1;
    else
        currentTextField--;
    activeTextField = [textFields objectAtIndex:currentTextField];
    [activeTextField becomeFirstResponder];
}

- (void)nextBTNClicked:(id)sender {
    NSUInteger currentTextField = [textFields indexOfObject:activeTextField];
    if (currentTextField < [textFields count]-1)
        currentTextField++;
    else
        currentTextField = 0;
    activeTextField = [textFields objectAtIndex:currentTextField];
    [activeTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self okBTNClicked:nil];
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:self action:@selector(previousBTNClicked:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextBTNClicked:)];    
    NSArray *itemsArray = [NSArray arrayWithObjects:previousButton, nextButton, nil];
    [toolbar setItems:itemsArray];
    
    [textField setInputAccessoryView:toolbar];
    
    // Set the active field. We' ll need that if we want to move properly
    // between our textfields.
    activeTextField = textField;
    
    if (activeTextField == self.cusipText)
        [self showInstrumentDropdownMenu];
    else {
        if (instrumentDropdown.popoverVisible == YES)
            [instrumentDropdown dismissPopoverAnimated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet* cs;
    NSString* filtered;
    
    
    if(textField == limit)
    {
        
        if ([textField.text rangeOfString:@"."].location == NSNotFound)
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
            filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            return [string isEqualToString:filtered];
        }
        
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
        
    }
    
    if(textField == quantity)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
        
    }
    if (instrumentDropdown.popoverVisible == YES) {
        InstrumentsDropdownViewController *controller = (InstrumentsDropdownViewController *) instrumentDropdown.contentViewController;
        [controller filterInstrumentsWithString:[textField.text stringByAppendingString:string]];
    }
    return YES;
}

#pragma mark - dropdown lifecycle

- (void)selectionChanged:(DropdownViewController *)controller
{
    switch (controller.tag) {
        case 2:
            actionDropDownCTL.label.text = controller.selected;
            order.side = controller.selected;
            break;
            
        case 3:
            priceDropDownCTL.label.text = controller.selected;
            order.type = controller.selected;
            self.limit.hidden = YES;
            if ([order.type isEqualToString:@"Limit"] == YES)
                self.limit.hidden = NO;
            break;
            
        case 4:
            goodForDayDropDownCTL.label.text = controller.selected;
            order.term = controller.selected;
            break;
            
        default:
            break;
    }
    
}

- (void)accountSelectionChanged:(AccountDropDownViewControiller *)controller
{
    switch (controller.tag) {
        case 1: {
            NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
            BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:controller.selectedIndex];
            order.brokerageAccountID = account.brokerageAccountID;
            order.accountName = account.name;
            accountDropDownCTL.label.text = [NSString stringWithFormat:@"%@ - $%d", account.name, [account.cashPosition.amount intValue]];
            break;
        }
            
        default:
            break;
    }
    
}

- (void)allAccountsClicked:(AccountDropDownViewControiller*) controller
{
    
}

- (void)instrumentSelectionChanged:(InstrumentsDropdownViewController *)controller
{
    BFInstrument *instrument = controller.selectedInstrument;
    self.cusipText.text = instrument.symbol;
    [self nextBTNClicked:nil];
}
@end
