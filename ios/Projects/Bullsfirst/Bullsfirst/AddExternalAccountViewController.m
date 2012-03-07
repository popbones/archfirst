//
//  AddExternalAccountViewController.m
//  Bullsfirst
//
//  Created by suravi on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddExternalAccountViewController.h"

@implementation AddExternalAccountViewController
@synthesize accountName,accountNumber,routingNumber,addAccountBTN,restServiceObject;
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
#pragma mark - selectors for handling rest call callbacks

-(void)receivedData:(NSData *)data
{
    
}

-(void)responseReceived:(NSURLResponse *)data
{
    
}

-(void)requestFailed:(NSError *)error
{   
    [spinner stopAnimating];
    spinner.hidden = YES;
    
    NSString *errorString = [NSString stringWithString:@"Try Again!"];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    
    addAccountBTN.enabled = YES;

}

-(void)requestSucceeded:(NSData *)data
{
    [spinner stopAnimating];
    spinner.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
    
}




#pragma mark - Methods
-(void) addAccountAction
{
    if([accountName.text isEqual:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Name" message:@"Need to enter an account name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }                
    
       if([routingNumber.text isEqual:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Routing Number" message:@"Need to enter a routing number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;   
    }
    if([accountNumber.text isEqual:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Number" message:@"Need to enter an account number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;   
    }

    spinner.hidden = NO;
    [spinner startAnimating];
    
    addAccountBTN.enabled = NO;
    
    
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/external_accounts"];
    
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    [jsonDic setValue:accountName.text forKey:kExternalAccountName];
    [jsonDic setValue:[NSNumber numberWithInt:[accountNumber.text longLongValue]]  forKey:kAccountNumber];
    [jsonDic setValue:[NSNumber numberWithInt:[routingNumber.text longLongValue]]  forKey:kRoutingNumber];
    NSError *err;
    NSLog(@"%@",jsonDic);
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];

    }
- (IBAction)addAccountButtonClicked:(id)sender
{
    // Check for errors    
    [self addAccountAction];
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    spinner.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = barButtonItem;

   restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];
    routingNumber.delegate = self;
    accountNumber.delegate = self;

    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];
    


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

-(IBAction)cancelBTNClicked:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];  
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet* cs;
    NSString* filtered;
           
    if(textField == accountNumber||textField==routingNumber)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
        
    }
   
    return YES;
}

@end
