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
#import "AppDelegate.h"
#import "BFInstrument.h"
@implementation TransferViewController
@synthesize segmentedControl,restServiceObject,symbol,amount,quantity,pricePaid;
@synthesize fromAccountDropDownCTL,toAccountDropDownCTL,dropdown,transferBTN;
@synthesize fromAccountDropDownView,toAccountDropDownView;
@synthesize amountLBL,quantityLBL,pricePaidLBL,symbolLBL,instrumentDropdown;
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
    
    spinner.hidden = YES;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ModalView_TitleBar_BackgroundGradient.jpg"] forBarMetrics:UIBarMetricsDefault];

    UIButton *cancelBTN=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBTN setImage:[UIImage imageNamed:@"Cancel.png"] forState:UIControlStateNormal];
    [cancelBTN setImage:[UIImage imageNamed:@"Cancel-PushDown.png"] forState:UIControlStateHighlighted];
    [cancelBTN addTarget:self action:@selector(cancelBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelBTN.frame=CGRectMake(0, 0, 57, 29);
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:cancelBTN];
    self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStylePlain;
    
   UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                     initWithTitle:@"Add Ext Account" style:UIBarButtonItemStylePlain target:self action:@selector(addExternalAccountBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"Transfer";
	self.navigationItem.backBarButtonItem = barButtonItem;
	self.navigationItem.title = @"Transfer";
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    orientationChanged=YES;
    
    textFields=[NSArray arrayWithObjects:symbol,quantity,pricePaid,nil];
    CGRect rect=segmentedControl.frame;
    segmentedControl.frame=CGRectMake(rect.origin.x, rect.origin.y, 192, 31);
    [segmentedControl setImage:[UIImage imageNamed:@"SegmentControl-CashSelected-Cash.png"] forSegmentAtIndex:0];
    [segmentedControl setImage:[UIImage imageNamed:@"SegmentControl-CashSelected-Securities.png"] forSegmentAtIndex:1];
    segmentedControl.segmentedControlStyle=UISegmentedControlStyleBar;
    fromAccountDropDownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0,fromAccountDropDownView.frame.size.width, fromAccountDropDownView.frame.size.height)
                                                       target:self
                                                       action:@selector(showDropdown:)];
    fromAccountDropDownCTL.label.text = @"From Account";
    fromAccountDropDownCTL.tag = 1;
    [fromAccountDropDownView addSubview:fromAccountDropDownCTL];
    
    toAccountDropDownCTL = [[DropDownControl alloc] initWithFrame:CGRectMake(0, 0,toAccountDropDownView.frame.size.width, toAccountDropDownView.frame.size.height)
                                                             target:self
                                                             action:@selector(showDropdown:)];
    toAccountDropDownCTL.label.text = @"To Account";
    toAccountDropDownCTL.tag = 2;
    [toAccountDropDownView addSubview:toAccountDropDownCTL];
    rect=self.view.frame;
    scrollView.contentSize=CGSizeMake(rect.size.width, rect.size.height);
}
-(void) keyBoardWillShow: (NSNotification*) notification
{
    UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
    if(UIDeviceOrientationIsLandscape(orientation))
    {
        CGRect  rect=self.view.frame;
        scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y+11, rect.size.width, rect.size.height-130);
        
    }
    else
    {
        CGRect  rect=self.view.frame;
        scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y+11, rect.size.width, rect.size.height-40);
    }
    
    
}
-(void) keyBoardWillHide:(NSNotification*) notification
{
    
    UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
    if(UIDeviceOrientationIsLandscape(orientation))
    {
        CGRect  rect=self.view.frame;
        scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y+11, rect.size.width, rect.size.height);
    }
    else
    {
        CGRect  rect=self.view.frame;
        scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y+11, rect.size.width, rect.size.height);
        
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"From Account" message:@"Need to chose an account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }        
    if(toAccountID==NULL)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"To Account" message:@"Need to chose an account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    
    if(fromAccountID==NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"From Account" message:@"Need to chose an account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }        
    if(toAccountID==NULL)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"To Account" message:@"Need to chose an account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    NSString *errorString = [NSString stringWithString:@"Try Again!"];
    
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
    NSString *errorString = [NSString stringWithString:@"Try Again!"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceededCashTransfer:(NSData *)data
{
    [spinner stopAnimating];
    spinner.hidden = YES;
    [self dismissModalViewControllerAnimated:YES];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
    AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.tabBarController.selectedIndex = 2;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_TRANSACTIONS" object:nil];

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
            fromAccountDropDownCTL.label.text = controller.selected;
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
            toAccountDropDownCTL.label.text = controller.selected;
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
     DropDownControl *dropdownCTL = (DropDownControl *)sender;
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
    CGPoint origin = [self.view convertPoint:dropdownCTL.arrowRect.origin fromView:dropdownCTL];
    CGRect dropdownRect = CGRectMake(origin.x, origin.y, dropdownCTL.arrowRect.size.width, dropdownCTL.arrowRect.size.height);

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
        [dropdown presentPopoverFromRect: dropdownRect  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}
- (IBAction)segmentedControlValueChanged:(id)sender
{
    if(segmentedControl.selectedSegmentIndex==0)
    {
        [segmentedControl removeAllSegments];
       [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"SegmentControl-CashSelected-Cash.png"] atIndex:0 animated:NO];
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"SegmentControl-CashSelected-Securities.png"] atIndex:1 animated:NO];
        segmentedControl.selectedSegmentIndex=0;
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
       
        [segmentedControl removeAllSegments];
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"SegmentControl-SecuritiesSelected-Cash.png"] atIndex:0 animated:NO];
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"SegmentControl-SecuritiesSelected-Securities.png"] atIndex:1 animated:NO];   
        segmentedControl.selectedSegmentIndex=1;
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
        [instrumentDropdown presentPopoverFromRect:self.symbol.frame  inView: self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

#pragma mark - text field lifecycle
- (void)previousBTNClicked:(id)sender {
   if(segmentedControl.selectedSegmentIndex==1)
   {
    NSUInteger currentTextField = [textFields indexOfObject:activeTextField];
    if (currentTextField == 0)
        currentTextField = [textFields count] -1;
    else
        currentTextField--;
    activeTextField = [textFields objectAtIndex:currentTextField];
    [activeTextField becomeFirstResponder];
   }
}

- (void)nextBTNClicked:(id)sender {
    if(segmentedControl.selectedSegmentIndex==1)
    {
    NSUInteger currentTextField = [textFields indexOfObject:activeTextField];
    if (currentTextField < [textFields count]-1)
        currentTextField++;
    else
        currentTextField = 0;
    activeTextField = [textFields objectAtIndex:currentTextField];
    [activeTextField becomeFirstResponder];
    }
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
//    if(orientationChanged)
//    {
//        UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
//        if(UIDeviceOrientationLandscapeLeft==orientation||UIDeviceOrientationLandscapeRight==orientation)
//        {
//            CGRect  rect=self.view.frame;
//            scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, rect.size.height-200);
//            
//        }
//        else
//        {
//            CGRect  rect=self.view.frame;
//            scrollView.frame=CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, rect.size.height-155);
//        }
//        
//        orientationChanged = NO;
//    }
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    // Set the active field. We' ll need that if we want to move properly
    // between our textfields.
    activeTextField = textField;
    if (activeTextField == self.symbol)
        [self showInstrumentDropdownMenu];
    else {
        if (instrumentDropdown.popoverVisible == YES)
            [instrumentDropdown dismissPopoverAnimated:YES];
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
    if (instrumentDropdown.popoverVisible == YES) {
        InstrumentsDropdownViewController *controller = (InstrumentsDropdownViewController *) instrumentDropdown.contentViewController;
        [controller filterInstrumentsWithString:[textField.text stringByAppendingString:string]];
    }
    return YES;
}

- (void)instrumentSelectionChanged:(InstrumentsDropdownViewController *)controller
{
    BFInstrument *instrument = controller.selectedInstrument;
    self.symbol.text = instrument.symbol;
    [self nextBTNClicked:nil];
}


@end
