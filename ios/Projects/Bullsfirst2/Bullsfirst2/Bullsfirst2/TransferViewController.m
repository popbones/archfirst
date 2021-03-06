//
//  TransferViewController.m
//  Bullsfirst
//
//  Created by Pong Choa
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

#import "TransferViewController.h"
#import "BFBrokerageAccountStore.h"
#import "BFBrokerageAccount.h"
#import "BFExternalAccountStore.h"
#import "BFExternalAccount.h"
#import "BFMoney.h"
#import "AddExternalAccountViewController.h"
#import "BFConstants.h"
#import "AppDelegate.h"
#import "BFInstrument.h"
#import "AccountDropDownViewControiller.h"
@implementation TransferViewController
@synthesize segmentedControl,restServiceObject,symbol,amount,quantity,pricePaid;
@synthesize fromAccountDropDownCTL,toAccountDropDownCTL,dropdown,transferBTN;
@synthesize fromAccountDropDownView,toAccountDropDownView;
@synthesize amountLBL,quantityLBL,pricePaidLBL,symbolLBL,instrumentDropdown;
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
    
    spinner.hidden = YES;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ModalView_TitleBar_BackgroundGradient.jpg"] forBarMetrics:UIBarMetricsDefault];

     
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    barButtonItem = [[UIBarButtonItem alloc]
                     initWithTitle:@"Add External Account" style:UIBarButtonItemStylePlain target:self action:@selector(addExternalAccountBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"Transfer";
	self.navigationItem.backBarButtonItem = barButtonItem;
	self.navigationItem.title = @"Transfer";
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];
    isKeyBoardVisible=false;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    orientationChanged=YES;
    
    CGRect rect=segmentedControl.frame;
    segmentedControl.frame=CGRectMake(rect.origin.x, rect.origin.y, 199, 31);
    [segmentedControl setImage:[UIImage imageNamed:@"SegmentControl-CashSelected-Cash.png"] forSegmentAtIndex:0];
    [segmentedControl setImage:[UIImage imageNamed:@"SegmentControl-CashSelected-Securities.png"] forSegmentAtIndex:1];
    segmentedControl.segmentedControlStyle=UISegmentedControlStylePlain;
    
    [segmentedControl setDividerImage:[UIImage imageNamed:@"SegmentedControl_Divider.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmentedControl setDividerImage:[UIImage imageNamed:@"SegmentedControl_Divider.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    fromAccountDropDownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0,fromAccountDropDownView.frame.size.width, fromAccountDropDownView.frame.size.height)
                                                       target:self
                                                       action:@selector(showDropdown:)];
    fromAccountDropDownCTL.label.text = @"From Account";
    fromAccountDropDownCTL.label.font = [UIFont systemFontOfSize:13.0];
    fromAccountDropDownCTL.tag = 1;
    [fromAccountDropDownView addSubview:fromAccountDropDownCTL];
    
    toAccountDropDownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0,toAccountDropDownView.frame.size.width, toAccountDropDownView.frame.size.height)
                                                             target:self
                                                             action:@selector(showDropdown:)];
    toAccountDropDownCTL.label.text = @"To Account";
    toAccountDropDownCTL.label.font = [UIFont systemFontOfSize:13.0];
    toAccountDropDownCTL.tag = 2;
    [toAccountDropDownView addSubview:toAccountDropDownCTL];
    rect=self.view.frame;
     [symbol addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    activeTextField=nil;
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (instrumentDropdown.popoverVisible == YES)
        [instrumentDropdown dismissPopoverAnimated:NO];
    return YES;
}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
//    if(activeTextField!=nil)
//    {
//        UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
//        if(UIDeviceOrientationIsLandscape(orientation))
//        {
//            CGRect  rect=self.view.frame;
//            scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, rect.size.height-150);
//            
//        }
//        else
//        {
//            CGRect  rect=self.view.frame;
//            scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, rect.size.height-55);
//        }
//        [activeTextField becomeFirstResponder];
//        
//        
//    }
    
}
-(void) doSecuritiesTransfer
{
    if(fromAccountID==NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"From Account" message:@"Need to choose an account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }        
    if(toAccountID==NULL)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"To Account" message:@"Need to choose an account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if([symbol.text isEqual:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Symbol" message:@"Need to enter a security symbol." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    } 
    else
    {
        bool flag=false;
        NSArray *instruments= [BFInstrument getAllInstruments];
        for (BFInstrument *instrument in instruments )
        {
            if([symbol.text isEqual:instrument.symbol])
                flag=true;
        }
        if(!flag)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Symbol" message:@"Need to enter a valid security symbol." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
    }
    if([quantity.text isEqual:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quantity" message:@"Need to enter some quantity." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }                
                    
    if([pricePaid.text isEqual:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Price Paid Per Share" message:@"Need to enter some price." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;   
    }
    spinner.hidden = NO;
    [spinner startAnimating];
    NSString* urlString = [NSString stringWithFormat:@"http://archfirst.org/bfoms-javaee/rest/secure/accounts/%@/transfer_securities",fromAccountID];
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    NSMutableDictionary *amountDic = [[NSMutableDictionary alloc] init];    
    
    [amountDic setValue:[NSNumber numberWithInt:[pricePaid.text intValue]] forKey:kAmount];
    [amountDic setValue:@"USD" forKey:kCurrency];
    [jsonDic setValue:toAccountID forKey:kToAccountId];
    [jsonDic setValue:amountDic forKey:kPricePaidPerShare];
    [jsonDic setValue:[NSNumber numberWithInt:[quantity.text intValue]] forKey:kQuantity];
    [jsonDic setValue:symbol.text forKey:kSymbol];
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    NSURL *url= [NSURL URLWithString:urlString];
    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
  
    

}

-(void) doCashTransfer
{
    
    if(fromAccountID==NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"From Account" message:@"Need to choose an account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }        
    if(toAccountID==NULL)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"To Account" message:@"Need to choose an account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if([amount.text isEqual:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Amount" message:@"Need to enter some amount." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }           
    spinner.hidden = NO;
    
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
    spinner.hidden = YES;
    NSString *errorString = @"Try Again!";
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceededSecuritiesTransfer:(NSData *)data
{
    [spinner stopAnimating];
    spinner.hidden = YES;
    [self dismissModalViewControllerAnimated:YES];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.tabBarController.selectedIndex = 2;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_TRANSACTIONS" object:nil];

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
    spinner.hidden  = YES;
    NSString *errorString = @"Try Again!";
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceededCashTransfer:(NSData *)data
{
    [spinner stopAnimating];
    spinner.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:NULL];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.tabBarController.selectedIndex = 2;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_TRANSACTIONS" object:nil];

}
-(IBAction)cancelBTNClicked:(id)sender
{
    [activeTextField resignFirstResponder];
    activeTextField=nil;
    [self dismissModalViewControllerAnimated:YES];
    
}


#pragma mark - DropDownViewController delegate methods

-(void) accountSelectionChanged:(AccountDropDownViewControiller *)controller
{
    NSArray *brokerageAccounts;
    switch (controller.tag) {
        case 1:
            
            brokerageAccounts= [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
            
            if(controller.selectedIndex<=brokerageAccounts.count-1)
            {
                BFBrokerageAccount *account= [brokerageAccounts objectAtIndex:controller.selectedIndex];
                fromAccountID=account.brokerageAccountID; 
                fromAccountDropDownCTL.label.text = account.name;
            }
            else
            {
                NSArray *externalAccounts = [[BFExternalAccountStore defaultStore] allExternalAccounts];
                BFExternalAccount *account= [externalAccounts objectAtIndex:(controller.selectedIndex-brokerageAccounts.count)];
                fromAccountID=account.externalAccountID; 
                fromAccountDropDownCTL.label.text = account.name;
            }
            break;
            
        case 2:
            brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
            
            if(controller.selectedIndex<=brokerageAccounts.count-1)
            {
                BFBrokerageAccount *account= [brokerageAccounts objectAtIndex:controller.selectedIndex];
                toAccountID=account.brokerageAccountID;
                toAccountDropDownCTL.label.text = account.name;
            }
            else
            {
                NSArray *externalAccounts = [[BFExternalAccountStore defaultStore] allExternalAccounts];
                BFExternalAccount *account= [externalAccounts objectAtIndex:(controller.selectedIndex-brokerageAccounts.count)];
                toAccountID=account.externalAccountID; 
                toAccountDropDownCTL.label.text = account.name;
            }
            break;
        default:
            break;
    }
}


- (IBAction)showDropdown:(id)sender {
    DropDownControl* dropdownCTL = sender;
    NSArray *selections;
    CGSize size;
    NSMutableArray *accountName = [[NSMutableArray alloc] init];
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    for (BFBrokerageAccount *account in brokerageAccounts) {
        [accountName addObject:account];
    }
    NSArray *externalAccounts = [[BFExternalAccountStore defaultStore] allExternalAccounts];
    for (BFExternalAccount *account in externalAccounts) {
        [accountName addObject:account];
    }
    selections = [NSArray arrayWithArray:accountName];
    size.height = [selections count] * 44;
    if ([selections count] > 5) {
        size.height = 220;
    }
    size.width = 320;
    
    CGPoint origin = [self.view convertPoint:dropdownCTL.arrowRect.origin fromView:dropdownCTL];
    CGRect dropdownRect = CGRectMake(origin.x, origin.y, dropdownCTL.arrowRect.size.width, dropdownCTL.arrowRect.size.height);
    
    if (!dropdown) {
        AccountDropDownViewControiller *controller = [[AccountDropDownViewControiller alloc] initWithNibName:@"DropdownViewController" bundle:nil];
        dropdown = [[UIPopoverController alloc] initWithContentViewController:controller];
        controller.popOver = dropdown;
        controller.tag = dropdownCTL.tag;
        controller.selections = selections;
        controller.accountDelegate = self;
        [dropdown setPopoverContentSize:size];
    }
    if ([dropdown isPopoverVisible]) {
        [dropdown dismissPopoverAnimated:YES];
    } else {
        DropdownViewController *controller = (DropdownViewController *)dropdown.contentViewController;
        controller.selections = selections;
        controller.tag = dropdownCTL.tag;
        [controller.selectionsTBL reloadData];
        [dropdown setPopoverContentSize:size];
        [dropdown presentPopoverFromRect: dropdownRect  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }

    
    
    
//    CGPoint origin = [self.view convertPoint:dropdownCTL.arrowRect.origin fromView:dropdownCTL];
//    CGRect dropdownRect = CGRectMake(origin.x, origin.y, dropdownCTL.arrowRect.size.width, dropdownCTL.arrowRect.size.height);
//
//    if (!dropdown) {
//        DropdownViewController *controller = [[DropdownViewController alloc] initWithNibName:@"DropdownViewController" bundle:nil];
//        
//        dropdown = [[UIPopoverController alloc] initWithContentViewController:controller];
//        controller.popOver = dropdown;
//        controller.selections = selections;
//        controller.tag = button.tag;
//        controller.delegate = self;
//        [dropdown setPopoverContentSize:size];
//    }
//    if ([dropdown isPopoverVisible]) {
//        [dropdown dismissPopoverAnimated:YES];
//    } else {
//        DropdownViewController *controller = (DropdownViewController *)dropdown.contentViewController;
//        controller.tag = button.tag;
//        controller.selections = selections;
//        [controller.selectionsTBL reloadData];
//        [dropdown setPopoverContentSize:size];
//        [dropdown presentPopoverFromRect: dropdownRect  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//    }
}
- (IBAction)segmentedControlValueChanged:(id)sender
{
    if(segmentedControl.selectedSegmentIndex==0)
    {
        [segmentedControl removeAllSegments];
//        [segmentedControl insertSegmentWithTitle:@"" atIndex:0 animated:NO];
//        [segmentedControl insertSegmentWithTitle:@"" atIndex:1 animated:NO];
       CGRect rect=segmentedControl.frame;
        segmentedControl.frame=CGRectMake(rect.origin.x, rect.origin.y, 199, 31);
               
    
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"SegmentControl-CashSelected-Cash.png"] atIndex:0 animated:NO];
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"SegmentControl-CashSelected-Securities.png"] atIndex:1 animated:NO];
        segmentedControl.selectedSegmentIndex=0;
        segmentedControl.segmentedControlStyle=UISegmentedControlStylePlain;
        [segmentedControl setDividerImage:[UIImage imageNamed:@"SegmentedControl_Divider.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [segmentedControl setDividerImage:[UIImage imageNamed:@"SegmentedControl_Divider.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

        symbol.hidden=YES;
        quantity.hidden=YES;
        pricePaid.hidden=YES;
        amount.hidden=NO;
        rect=transferBTN.frame;
        transferBTN.frame=CGRectMake(rect.origin.x, rect.origin.y-50, rect.size.width, rect.size.height);
        rect=spinner.frame;
        spinner.frame=CGRectMake(rect.origin.x, rect.origin.y-50, rect.size.width, rect.size.height);
    }
    else
    {
       
        [segmentedControl removeAllSegments];
     
        CGRect rect=segmentedControl.frame;
        segmentedControl.frame=CGRectMake(rect.origin.x, rect.origin.y, 199, 31);

        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"SegmentControl-SecuritiesSelected-Cash.png"] atIndex:0 animated:NO];
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"SegmentControl-SecuritiesSelected-Securities.png"] atIndex:1 animated:NO];
        segmentedControl.segmentedControlStyle=UISegmentedControlStylePlain;
    
        [segmentedControl setDividerImage:[UIImage imageNamed:@"SegmentedControl_Divider.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [segmentedControl setDividerImage:[UIImage imageNamed:@"SegmentedControl_Divider.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

        
        segmentedControl.selectedSegmentIndex=1;
        
        symbol.hidden=NO;
        quantity.hidden=NO;
        pricePaid.hidden=NO;
        amount.hidden=YES;
        rect=transferBTN.frame;
        transferBTN.frame=CGRectMake(rect.origin.x, rect.origin.y+50, rect.size.width, rect.size.height);
        rect=spinner.frame;
        spinner.frame=CGRectMake(rect.origin.x, rect.origin.y+50, rect.size.width, rect.size.height);
    }
}

- (void)addExternalAccountBTNClicked:(id)sender
{
    AddExternalAccountViewController *controller= [[AddExternalAccountViewController alloc] initWithNibName:@"AddExternalAccountViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];

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
        [instrumentDropdown presentPopoverFromRect:self.symbol.frame  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
}

#pragma mark - text field lifecycle
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    // Set the active field. We' ll need that if we want to move properly
    // between our textfields.
    activeTextField=textField;
   if(isKeyBoardVisible==true)
   {
    if (activeTextField == self.symbol)
        [self showInstrumentDropdownMenu];
    else {
        if (instrumentDropdown.popoverVisible == YES)
            [instrumentDropdown dismissPopoverAnimated:YES];
    }
   }
}


-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet* cs;
    NSString* filtered;
    
    
    if(textField == pricePaid || textField == amount)
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
    
    return YES;
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
- (void)instrumentSelectionChanged:(InstrumentsDropdownViewController *)controller
{
    BFInstrument *instrument = controller.selectedInstrument;
    self.symbol.text = instrument.symbol;
}

-(void) keyBoardDidShow: (NSNotification*) notification
{
    isKeyBoardVisible=true;
    if (activeTextField == self.symbol)
        [self showInstrumentDropdownMenu];
    else {
        if (instrumentDropdown.popoverVisible == YES)
            [instrumentDropdown dismissPopoverAnimated:YES];
    }
    
}
-(void) keyBoardDidHide:(NSNotification*) notification
{
     isKeyBoardVisible=false;
    if (instrumentDropdown.popoverVisible == YES)
        [instrumentDropdown dismissPopoverAnimated:YES];
   
}
@end
