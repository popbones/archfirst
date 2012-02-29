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

@implementation TradeViewController
@synthesize position;
@synthesize cusipText;
@synthesize quantity;
@synthesize limit;
@synthesize accountBTN;
@synthesize orderBTN;
@synthesize priceBTN;
@synthesize goodForDayBTN;
@synthesize allOrNone;
@synthesize allOrNoneLabel;
@synthesize activeTextField;
@synthesize textFields;
@synthesize dropdown;
@synthesize order;
@synthesize accountDropdown;
@synthesize accountLabel;

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
    barButtonItem.title = @"Trade";
	self.navigationItem.backBarButtonItem = barButtonItem;

    textFields = [NSArray arrayWithObjects:quantity, cusipText, limit, nil];
    order = [[BFOrder alloc] init];
    order.allOrNone = YES;
    order.term = [NSString stringWithString:@"Good for day"];
    accountBTN.titleLabel.text = @"Accounts";
   
    if (self.position != nil) {
        cusipText.text = self.position.instrumentSymbol;
        accountBTN.titleLabel.text = self.position.accountName;
        quantity.text = [NSString stringWithFormat:@"%d", [self.position.quantity intValue]];
        
        accountLabel.text = self.position.accountName;
    } 
    accountLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ModalView_TitleBar_BackgroundGradient.jpg"]];
    accountLabel.text = @"Accounts";
}

- (void)viewDidUnload
{
    [self setCusipText:nil];
    [self setQuantity:nil];
    [self setLimit:nil];
    [self setAccountBTN:nil];
    [self setOrderBTN:nil];
    [self setPriceBTN:nil];
    [self setGoodForDayBTN:nil];
    [self setAllOrNone:nil];
    [self setAllOrNoneLabel:nil];
    [self setAccountLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)showAccountDropdown:(id)sender {
    UIButton *button = sender;
    CGSize size;
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    size.height = [brokerageAccounts count] * 44;
    if ([brokerageAccounts count] > 5) {
        size.height = 220;
    }
    size.width = 320;
    
    if (!accountDropdown) {
        AccountDropDownViewControiller *controller = [[AccountDropDownViewControiller alloc] initWithNibName:@"DropdownViewController" bundle:nil];
        
        accountDropdown = [[UIPopoverController alloc] initWithContentViewController:controller];
        controller.popOver = accountDropdown;
        controller.selections = brokerageAccounts;
        controller.tag = button.tag;
        controller.accountDelegate = self;
        [accountDropdown setPopoverContentSize:size];
    }
    if ([accountDropdown isPopoverVisible]) {
        [accountDropdown dismissPopoverAnimated:YES];
    } else {
        AccountDropDownViewControiller *controller = (AccountDropDownViewControiller *) accountDropdown.contentViewController;
        controller.tag = button.tag;
        controller.selections = brokerageAccounts;
        [controller.selectionsTBL reloadData];
        [accountDropdown setPopoverContentSize:size];
        [accountDropdown presentPopoverFromRect: button.frame  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
}


- (IBAction)showDropdown:(id)sender {
    UIButton *button = sender;
    NSArray *selections;
    CGSize size;
    switch (button.tag) {            
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
            selections = [NSArray arrayWithObjects:@"Good for day", @"Good til cancel", nil];
            size = [@"Good til cancel" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]];
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
        controller.tag = button.tag;
        controller.delegate = self;
        [dropdown setPopoverContentSize:size];
    }
    if ([dropdown isPopoverVisible]) {
        [dropdown dismissPopoverAnimated:YES];
    } else {
        DropdownViewController *controller = (DropdownViewController *)dropdown.contentViewController;
        controller.tag = button.tag;
        controller.selections = selections;
        [controller.selectionsTBL reloadData];
        [dropdown setPopoverContentSize:size];
        [dropdown presentPopoverFromRect: button.frame  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
}

- (IBAction)allOrNoneClicked:(id)sender {
    UIButton *button = sender;
    if (order.allOrNone == YES) {
        [button setImage:[UIImage imageNamed:@"img_bg_login.png"] forState:UIControlStateNormal];
        order.allOrNone = NO;
    } else {
        [button setImage:[UIImage imageNamed:@"img_bg_yellow.png"] forState:UIControlStateNormal];
        order.allOrNone = YES;
    }
}


- (IBAction)cancelBTNClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    [activeTextField resignFirstResponder];
}

- (IBAction)okBTNClicked:(id)sender {
    [activeTextField resignFirstResponder];
    order.instrumentSymbol = [NSString stringWithString:self.cusipText.text];
    order.quantity = [NSString stringWithString:self.quantity.text];
    order.limitPrice = [BFMoney moneyWithAmount:[NSNumber numberWithInt:[self.limit.text intValue]] currency:@"USD"];

    PreviewTradeViewController *controller = [[PreviewTradeViewController alloc] initWithNibName:@"PreviewTradeViewController" bundle:nil order:order];    
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
}

#pragma mark - dropdown lifecycle

- (void)selectionChanged:(DropdownViewController *)controller
{
    switch (controller.tag) {
        case 2:
            orderBTN.titleLabel.text = controller.selected;
            order.side = controller.selected;
            break;
            
        case 3:
            priceBTN.titleLabel.text = controller.selected;
            order.type = controller.selected;
            break;
            
        case 4:
            goodForDayBTN.titleLabel.text = controller.selected;
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
            accountBTN.titleLabel.text = account.name;
            break;
        }
            
        default:
            break;
    }
    
}

@end
