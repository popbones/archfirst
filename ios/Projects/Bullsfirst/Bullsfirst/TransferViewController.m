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
#import "AddAccountViewController.h"

@implementation TransferViewController
@synthesize segmentedControl,restServiceObject,symbol,amount,quantity,pricePaid;
@synthesize fromAccountBTN,toAccountBTN,dropdown;
@synthesize amountLBL,quantityLBL,pricePaidLBL,symbolLBL;
@synthesize navBar;
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
    [self.navigationController pushViewController:self animated:YES];
    
    // Do any additional setup after loading the view from its nib.
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
	return YES;
}

-(void) doSecuritiesTransfer
{
//    if([[accountName text] isEqual:@""])
//    {
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                     message:@"Account Name is required"
//                                                    delegate:nil
//                                           cancelButtonTitle:@"OK"
//                                           otherButtonTitles:nil];
//        [av show];
//        return;        
//    }
   // [spinner startAnimating];
    NSString* urlString = [NSString stringWithFormat:@"http://archfirst.org/bfoms-javaee/rest/secure/accounts/%@/transfer_securities",fromAccountID];
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    NSMutableDictionary *amountDic = [[NSMutableDictionary alloc] init];    
    
    [amountDic setValue:[NSNumber numberWithInt:[pricePaid.text intValue]] forKey:@"amount"];
    [amountDic setValue:@"USD" forKey:@"currency"];
    NSLog(@"%@",toAccountID);
    [jsonDic setValue:toAccountID forKey:@"toAccountId"];
    [jsonDic setValue:amountDic forKey:@"pricePaidPerShare"];
    [jsonDic setValue:[NSNumber numberWithInt:[quantity.text intValue]] forKey:@"quantity"];
    [jsonDic setValue:symbol.text forKey:@"symbol"];
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
//    
//    [spinner startAnimating];
//    
    
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
    NSString *errorString = [NSString stringWithString:@"Try Again!"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceededSecuritiesTransfer:(NSData *)data
{
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
    NSString *errorString = [NSString stringWithString:@"Try Again!"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceededCashTransfer:(NSData *)data
{
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
    }
}

- (IBAction)addExternalAccountBTNClicked:(id)sender
{
    AddAccountViewController *controller= [[AddAccountViewController alloc] initWithNibName:@"AddAccountViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];

}
@end
