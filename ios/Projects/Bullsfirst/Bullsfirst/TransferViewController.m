//
//  TransferViewController.m
//  Bullsfirst
//
//  Created by Pong Choa on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferViewController.h"
#import "BFBrokerageAccountStore.h"
#import "BFExternalAccountStore.h"
#import "BFExternalAccount.h"
#import "BFMoney.h"
@implementation TransferViewController
@synthesize segmentedControl,restServiceObject;
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
    
  
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/brokerage_accounts"];
    
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    // [jsonDic setValue:[accountName text] forKey:kAccountName];
    
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    
    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];

}

-(void) doCashTransfer
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
//    
//    [spinner startAnimating];
//    
    NSString* urlString = [NSString stringWithFormat:@"%@",@"http://archfirst.org/bfoms-javaee/rest/secure/accounts/132/transfer_cash"];
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    NSMutableDictionary *amountDic = [[NSMutableDictionary alloc] init];    
    
    [amountDic setValue:[NSNumber numberWithInt:5000] forKey:@"amount"];
    [amountDic setValue:@"USD" forKey:@"currency"];
    
    [jsonDic setValue:[NSNumber numberWithInt:133] forKey:@"toAccountId"];
    [jsonDic setValue:amountDic forKey:@"amount"];
    
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    NSURL *url= [NSURL URLWithString:urlString];
    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
    NSLog(@"fafdsfadsfasf");
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
    NSString *errorString = [NSString stringWithString:@"Try Refreshing!"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceededSecuritiesTransfer:(NSData *)data
{
    [[BFExternalAccountStore defaultStore] accountsFromJSONData:data];
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
    NSString *errorString = [NSString stringWithString:@"Try Refreshing!"];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceededCashTransfer:(NSData *)data
{
    
}
-(IBAction)cancelBTNClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];  
}

@end
