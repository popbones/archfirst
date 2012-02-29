//
//  TransferViewController.m
//  Bullsfirst
//
//  Created by Pong Choa on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferViewController.h"
#import "BFBrokerageAccountStore.h"
#import "BFBrokerageAccount.h"
#import "BFExternalAccountStore.h"
#import "BFExternalAccount.h"
#import "BFMoney.h"
#import "AddExternalAccountViewController.h"
#import "BFConstants.h"
@implementation TransferViewController
@synthesize segmentedControl,restServiceObject,symbol,amount,quantity,pricePaid;
@synthesize fromAccountBTN,toAccountBTN,dropdown,transferBTN;
@synthesize amountLBL,quantityLBL,pricePaidLBL,symbolLBL;
@synthesize scrollView;
@synthesize activeTextField,textFields;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    self.navigationItem.rightBarButtonItem=barButtonItem;
    
    barButtonItem = [[UIBarButtonItem alloc]
                     initWithTitle:@"Add Ext Account" style:UIBarButtonItemStylePlain target:self action:@selector(addExternalAccountBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"Transfer";
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
	self.navigationItem.backBarButtonItem = barButtonItem;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = label;
    label.text = @"Transfer";
    label.textColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    [label sizeToFit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    orientationChanged=YES;
}
-(void) keyBoardWillShow: (NSNotification*) notification
{
    UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
    if(UIDeviceOrientationIsLandscape(orientation))
    {
        CGRect  rect=self.view.frame;
        scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, rect.size.height-50);
        
    }
    else
    {
        CGRect  rect=self.view.frame;
        scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, rect.size.height-5);
    }
    
    
}
-(void) keyBoardWillHide:(NSNotification*) notification
{
    
    UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
    if(UIDeviceOrientationIsLandscape(orientation))
    {
        CGRect  rect=self.view.frame;
        scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, rect.size.height);
    }
    else
    {
        CGRect  rect=self.view.frame;
        scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, rect.size.height);
        
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    orientationChanged = YES;
    [activeTextField resignFirstResponder];
    return YES;
}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if(activeTextField!=nil)
    {
        UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
        if(UIDeviceOrientationIsLandscape(orientation))
        {
            CGRect  rect=self.view.frame;
            scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, rect.size.height-150);
            
        }
        else
        {
            CGRect  rect=self.view.frame;
            scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, rect.size.height-55);
        }
        [activeTextField becomeFirstResponder];
        
        
    }
    
}
-(void) doSecuritiesTransfer
{
    if(symbol.text==@""||fromAccountID==NULL||toAccountID==NULL||quantity.text==@""||pricePaid.text==@"")
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"All fields are necessary"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        return;        
    }
    [spinner startAnimating];
    NSString* urlString = [NSString stringWithFormat:@"http://archfirst.org/bfoms-javaee/rest/secure/accounts/%@/transfer_securities",fromAccountID];
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    NSMutableDictionary *amountDic = [[NSMutableDictionary alloc] init];    
    
    [amountDic setValue:[NSNumber numberWithInt:[pricePaid.text intValue]] forKey:kAmount];
    [amountDic setValue:@"USD" forKey:kCurrency];
    NSLog(@"%@",toAccountID);
    [jsonDic setValue:toAccountID forKey:kToAccountId];
    [jsonDic setValue:amountDic forKey:kPricePaidPerShare];
    [jsonDic setValue:[NSNumber numberWithInt:[quantity.text intValue]] forKey:kQuantity];
    [jsonDic setValue:symbol.text forKey:kSymbol];
    NSLog(@"%@",jsonDic);
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    NSURL *url= [NSURL URLWithString:urlString];
    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
  
    

}

-(void) doCashTransfer
{
    if([[amount text] isEqual:@""]||fromAccountID==NULL||toAccountID==NULL)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"All fields are necessary"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        return;        
    }
    
     [spinner startAnimating];
   
    
    NSString* urlString = [NSString stringWithFormat:@"http://archfirst.org/bfoms-javaee/rest/secure/accounts/%@/transfer_cash",fromAccountID];
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    NSMutableDictionary *amountDic = [[NSMutableDictionary alloc] init];    
    
    [amountDic setValue:[NSNumber numberWithInt:[amount.text intValue]] forKey:@"amount"];
    [amountDic setValue:@"USD" forKey:@"currency"];
    
    [jsonDic setValue:toAccountID forKey:@"toAccountId"];
    [jsonDic setValue:amountDic forKey:@"amount"];
    
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    NSURL *url= [NSURL URLWithString:urlString];
    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
}
- (IBAction)transferBTNClicked:(id)sender
{
    if(segmentedControl.selectedSegmentIndex==0)
    {
        restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceivedCashTransfer:) receiveDataSelector:@selector(receivedDataCashTransfer:) successSelector:@selector(requestSucceededCashTransfer:) errorSelector:@selector(requestFailedCashTransfer:)];
        [self doCashTransfer];
    }
    else
    {
        restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceivedSecuritiesTransfer:) receiveDataSelector:@selector(receivedDataSecuritiesTransfer:) successSelector:@selector(requestSucceededSecuritiesTransfer:) errorSelector:@selector(requestFailedSecuritiesTransfer:)];
        [self doSecuritiesTransfer];
    }
    
    [self dismissModalViewControllerAnimated:YES];   
}
#pragma mark - selectors for handling rest call callbacks for SecuritiesTransfer

-(void)receivedDataSecuritiesTransfer:(NSData *)data
{
    
}

-(void)responseReceivedSecuritiesTransfer:(NSURLResponse *)data
{
    
}

-(void)requestFailedSecuritiesTransfer:(NSError *)error
{       
    [spinner stopAnimating];
    NSString *errorString = [NSString stringWithString:@"Try Again!"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceededSecuritiesTransfer:(NSData *)data
{
    [spinner stopAnimating];
    [self dismissModalViewControllerAnimated:YES];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];

}


#pragma mark - selectors for handling rest call callbacks for CashTransfer

-(void)receivedDataCashTransfer:(NSData *)data
{
    
}

-(void)responseReceivedCashTransfer:(NSURLResponse *)data
{
    
}

-(void)requestFailedCashTransfer:(NSError *)error
{    
    [spinner stopAnimating];
    NSString *errorString = [NSString stringWithString:@"Try Again!"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceededCashTransfer:(NSData *)data
{
    [spinner stopAnimating];
    [self dismissModalViewControllerAnimated:YES];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];

}
-(IBAction)cancelBTNClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];  
}
#pragma mark - dropdown lifecycle

- (void)selectionChanged:(DropdownViewController *)controller
{
    NSArray *brokerageAccounts;
    switch (controller.tag) {
        case 1:
            fromAccountBTN.titleLabel.text = controller.selected;
             brokerageAccounts= [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];

            if(controller.selectedIndex<=brokerageAccounts.count-1)
            {
            BFBrokerageAccount *account= [brokerageAccounts objectAtIndex:controller.selectedIndex];
                fromAccountID=account.brokerageAccountID;            
            }
            else
            {
                 NSArray *externalAccounts = [[BFExternalAccountStore defaultStore] allExternalAccounts];
                BFExternalAccount *account= [externalAccounts objectAtIndex:(controller.selectedIndex-brokerageAccounts.count)];
                fromAccountID=account.externalAccountID;       
            }
            break;
        
        case 2:
            toAccountBTN.titleLabel.text = controller.selected;
            brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
            
            if(controller.selectedIndex<=brokerageAccounts.count-1)
            {
                BFBrokerageAccount *account= [brokerageAccounts objectAtIndex:controller.selectedIndex];
                toAccountID=account.brokerageAccountID;            
            }
            else
            {
                NSArray *externalAccounts = [[BFExternalAccountStore defaultStore] allExternalAccounts];
                BFExternalAccount *account= [externalAccounts objectAtIndex:(controller.selectedIndex-brokerageAccounts.count)];
                toAccountID=account.externalAccountID;       
            }
            break;
        default:
            break;
    }
    
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
            NSArray *externalAccounts = [[BFExternalAccountStore defaultStore] allExternalAccounts];
            for (BFExternalAccount *account in externalAccounts) {
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
        {
            NSMutableArray *accountName = [[NSMutableArray alloc] init];
            NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
            for (BFBrokerageAccount *account in brokerageAccounts) {
                [accountName addObject:account.name];
            }
            NSArray *externalAccounts = [[BFExternalAccountStore defaultStore] allExternalAccounts];
            for (BFExternalAccount *account in externalAccounts) {
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
- (IBAction)segmentedControlValueChanged:(id)sender
{
    if(segmentedControl.selectedSegmentIndex==0)
    {
        symbolLBL.hidden=YES;
        symbol.hidden=YES;
        quantityLBL.hidden=YES;
        quantity.hidden=YES;
        pricePaidLBL.hidden=YES;
        pricePaid.hidden=YES;
        amountLBL.hidden=NO;
        amount.hidden=NO;
        CGRect rect=transferBTN.frame;
        transferBTN.frame=CGRectMake(rect.origin.x, rect.origin.y-100, rect.size.width, rect.size.height);
        rect=spinner.frame;
        spinner.frame=CGRectMake(rect.origin.x, rect.origin.y-100, rect.size.width, rect.size.height);
    }
    else
    {
        symbolLBL.hidden=NO;
        symbol.hidden=NO;
        quantityLBL.hidden=NO;
        quantity.hidden=NO;
        pricePaidLBL.hidden=NO;
        pricePaid.hidden=NO;
        amountLBL.hidden=YES;
        amount.hidden=YES;
        CGRect rect=transferBTN.frame;
        transferBTN.frame=CGRectMake(rect.origin.x, rect.origin.y+100, rect.size.width, rect.size.height);
        rect=spinner.frame;
        spinner.frame=CGRectMake(rect.origin.x, rect.origin.y+100, rect.size.width, rect.size.height);
    }
}

- (void)addExternalAccountBTNClicked:(id)sender
{
    AddExternalAccountViewController *controller= [[AddExternalAccountViewController alloc] initWithNibName:@"AddExternalAccountViewController" bundle:nil];
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
    [textField resignFirstResponder];
    
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:self action:@selector(previousBTNClicked:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextBTNClicked:)];    
    NSArray *itemsArray = [NSArray arrayWithObjects:previousButton, nextButton, nil];
    [toolbar setItems:itemsArray];
    
    [textField setInputAccessoryView:toolbar];
    if(orientationChanged)
    {
        UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
        if(UIDeviceOrientationIsLandscape(orientation))
        {
            CGRect  rect=self.view.frame;
            scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, rect.size.height-150);
            
        }
        else
        {
            CGRect  rect=self.view.frame;
            scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, rect.size.height-55);
        }
        
        orientationChanged = NO;
    }
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    // Set the active field. We' ll need that if we want to move properly
    // between our textfields.
    activeTextField = textField;
}



@end
