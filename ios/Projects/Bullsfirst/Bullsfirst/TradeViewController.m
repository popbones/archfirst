//
//  TradeViewController.m
//  Bullsfirst
//
//  Created by Pong Choa on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TradeViewController.h"
#import "DropdownViewController.h"
#import "BFBrokerageAccountStore.h"
#import "BFBrokerageAccount.h"

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
@synthesize allOrNoneBOOL;

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
    // Do any additional setup after loading the view from its nib.
    textFields = [NSArray arrayWithObjects:cusipText, quantity, limit, nil];
    allOrNoneBOOL = YES;
    [allOrNone setImage:[UIImage imageNamed:@"img_bg_yellow.png"] forState:UIControlStateNormal];
    
    if (self.position != nil) {
        cusipText.text = self.position.instrumentSymbol;
        accountBTN.titleLabel.text = self.position.accountName;
    }
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)showDropdown:(id)sender {
    UIButton *button = sender;
    NSArray *selections;
    CGSize size;
    switch (button.tag) {
        case 1: {
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
            
        case 2:
            selections = [NSArray arrayWithObjects:@"Buy", @"Sell", nil];
            size = [@"Buy" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]];
            size.height = [selections count] * 44;
            size.width += 20;

            break;
            
        case 3:
            selections = [NSArray arrayWithObjects:@"Market", @"Limited", nil];
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
        DropdownViewController *controller = dropdown.contentViewController;
        controller.tag = button.tag;
        controller.selections = selections;
        [controller.selectionsTBL reloadData];
        [dropdown setPopoverContentSize:size];
        [dropdown presentPopoverFromRect: button.frame  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
}

- (IBAction)allOrNoneClicked:(id)sender {
    UIButton *button = sender;
    if (allOrNoneBOOL == YES) {
        [button setImage:[UIImage imageNamed:@"img_bg_login.png"] forState:UIControlStateNormal];
        allOrNoneBOOL = NO;
    } else {
        [button setImage:[UIImage imageNamed:@"img_bg_yellow.png"] forState:UIControlStateNormal];
        allOrNoneBOOL = YES;
    }
}


- (IBAction)cancelBTNClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    [activeTextField resignFirstResponder];
}

- (IBAction)okBTNClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    [activeTextField resignFirstResponder];
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
        case 1:
            accountBTN.titleLabel.text = controller.selected;
            break;
            
        case 2:
            orderBTN.titleLabel.text = controller.selected;
            break;
            
        case 3:
            priceBTN.titleLabel.text = controller.selected;
            break;
            
        case 4:
            goodForDayBTN.titleLabel.text = controller.selected;
            break;
            
        default:
            break;
    }
    
}
@end
