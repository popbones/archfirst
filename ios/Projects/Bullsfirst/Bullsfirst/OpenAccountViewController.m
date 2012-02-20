//
//  OpenAccountViewController.m
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

#import "OpenAccountViewController.h"
#import "LoginViewController.h"
#import "BullFirstWebServiceObject.h"
#import "AppDelegate.h"

@implementation OpenAccountViewController

@synthesize restServiceObject;

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

#pragma mark - helper methods
-(void) createBrokerageAccount
{
    currentProcess = CreateNewBrokerageAccount;
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/brokerage_accounts"];
    
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    [jsonDic setValue:kdefaultBrokerageAccountName forKey:kAccountName];
    
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    
    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
    
}

-(void) createExternalAccount
{
    
    currentProcess = CreateExternalAccount;
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/external_accounts"];
    
    NSMutableDictionary* jsonDic = [[NSMutableDictionary alloc]init];
    [jsonDic setValue:kDefaultExternalAccountName forKey:kExternalAccountName];
    [jsonDic setValue:[NSNumber numberWithInt:kDefaultRoutingNumber] forKey:kRoutingNumber];
    [jsonDic setValue:[NSNumber numberWithInt:kDefaultExternalAccountNumber] forKey:kAccountNumber];
    
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
}

-(void) transferAmount
{
    currentProcess = TransferAmount;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://archfirst.org/bfoms-javaee/rest/secure/accounts/%@/transfer_cash",newExternalAccountId]];
    
    
    BFDebugLog(@"URL : %@",url.absoluteString);
    NSMutableDictionary* jsonDic = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary* amountDic = [[NSMutableDictionary alloc]init];
    [amountDic setValue:[NSNumber numberWithInt:kDefaultTransferAmount] forKey:kAmount];
    [amountDic setValue:kUSD forKey:kCurrency];
    
    [jsonDic setValue:amountDic forKey:kAmount];
    [jsonDic setValue:newBrokerageAccountId forKey:kToAccountId];
    
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
}


#pragma mark - rest service call back methods

-(void)receivedData:(NSData *)data
{
    
}

-(void)responseReceived:(NSURLResponse *)data
{

}

-(void)requestFailed:(NSError *)error
{ 
    [spinner stopAnimating];
    urlConnection = nil;
    jsonResponseData = nil;
    
    NSString *errorString = [NSString stringWithString:@"Try Again!"];
    BFDebugLog(@"%@ %@",error.description,error.debugDescription);
    if(currentProcess == CreateNewBFAccount)
    {
        if(error.code == 409)
            errorString = @"Username already exists";
    }
    else if(currentProcess == CreateNewBrokerageAccount)
    {
        errorString = @"Not able to create default brokerage account";
    }
    else if(currentProcess == CreateExternalAccount)
    {
        errorString = @"Not able to create default external account";
    }
    else if(currentProcess == TransferAmount)
    {
        if(error.code == 403)
        {
            errorString = @"Insufficient Funds";
        }
    }
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];    
    openAccountButton.enabled = YES;
    cancelButton.enabled = YES;
}

-(void)requestSucceeded:(NSData *)data
{
    jsonResponseData = [NSMutableData dataWithData:data];
    NSError *err;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonResponseData options:0 error:&err];
    
    BFDebugLog(@"jsonObject = %@", jsonObject);
    
    if(currentProcess == CreateNewBFAccount)
    {
        [self createBrokerageAccount];       
    }
    else if(currentProcess == CreateNewBrokerageAccount)
    {
        if([jsonObject objectForKey:kId])
        {
            newBrokerageAccountId = [jsonObject objectForKey:kId];
        }
        
        [self createExternalAccount];
    }
    else if(currentProcess == CreateExternalAccount)
    {
        if([jsonObject objectForKey:kId])
        {
            newExternalAccountId = [jsonObject objectForKey:kId];
            BFDebugLog(@"%@",newExternalAccountId);
        }
        [self transferAmount];
    }
    else if(currentProcess == TransferAmount)
    {
        [spinner stopAnimating];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.currentUser = [[BFUser alloc] initWithName:firstName.text
                                                      lastName:lastName.text 
                                                      username:username.text];
        
        [self performSelectorOnMainThread:@selector(dismissModalViewControllerAnimated:) withObject:nil waitUntilDone:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEW_ACCOUNT_CREATED" object:nil];
    }
}


#pragma mark - Methods

-(void) openAccountAction
{
    // Check for errors    
    if(![[password text] isEqual:[confirmpassword text]])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Check Passwords"
                                                     message:@"Passwords do not match"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    else if([[firstName text] isEqual:@""] || [[lastName text] isEqual:@""] || [[username text] isEqual:@""] || [[password text] isEqual:@""])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"All fields are required"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        return;        
    }
    
    [spinner startAnimating];
    
    currentProcess = CreateNewBFAccount;
    
    openAccountButton.enabled = NO;
    cancelButton.enabled = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/users/"];
    
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    [jsonDic setValue:[firstName text] forKey:kFirstName];
    [jsonDic setValue:[lastName text] forKey:kLastName];
    [jsonDic setValue:[username text] forKey:kUsername];
    [jsonDic setValue:[password text] forKey:kPassword];
    
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    
    //Opening new BullFirst Account
    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
    
    //updating the webservice object about the credentials
    [WebServiceObject userLoginCredentialWithUsername:[username text] password:[password text]];
}

- (IBAction)openAccountButtonClicked:(id)sender
{
    [self openAccountAction];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

-(void) registerForDataValidations
{    
    [validator processTextFields:[NSArray arrayWithObjects:firstName,lastName,username,password,confirmpassword,nil] rightViewIconFileName:kErrorIconAtEndOfTextField errorStringOnNoEntry:kStringFieldIsEmpty];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    firstName.returnKeyType = UIReturnKeyGo;
    lastName.returnKeyType = UIReturnKeyGo;
    username.returnKeyType = UIReturnKeyGo;
    password.returnKeyType = UIReturnKeyGo;
    confirmpassword.returnKeyType = UIReturnKeyGo;
    
    validator = [[DataValidator alloc] init];
    validator.delegate = self;
    
    
    restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];
    openAccountButton.enabled = NO;
    
    [password addTarget:self action:@selector(passwordEditingStarted:) forControlEvents:UIControlEventEditingDidBegin];
    [confirmpassword addTarget:self action:@selector(passwordEditingStarted:) forControlEvents:UIControlEventEditingDidBegin];
    
    password.clearsOnBeginEditing = YES;
    confirmpassword.clearsOnBeginEditing = YES;
    
    [self registerForDataValidations];
    
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

#pragma mark - UITextField delegate methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self openAccountAction];
    return YES;
}

#pragma mark - DataValidator protocol methods

-(void) formValidationSucceeded:(bool) status;
{
    openAccountButton.enabled = status;
}

-(NSString*) validationStatusForTextField:(UITextField*) textField;
{
    if(textField == firstName)
    {
        if(textField.text.length ==0)
        {
            return kStringFieldIsEmpty;
        }
    }
    else if(textField == lastName)
    {
        if(textField.text.length == 0)
        {
            return kStringFieldIsEmpty;
        }
    }
    else if(textField == username)
    {
        if(textField.text.length == 0)
        {
            return kStringFieldIsEmpty;
        }
    }
    else if(textField == password)
    {
        if(textField.text.length == 0)
        {
            return kStringFieldIsEmpty;
        }
        else if(![textField.text isEqualToString:confirmpassword.text])
        {
            return @"The text doesnot match with the confirm password field";
        }
    }
    else if(textField == confirmpassword)
    {
        if(textField.text.length == 0)
        {
            return kStringFieldIsEmpty;
        }
        else if(![textField.text isEqualToString:password.text])
        {
            return @"The text doesnot match with the password field";
        }
    }
    return nil;
}

#pragma mark - TextField callback methods
-(void) passwordEditingStarted:(UITextField*) textField
{
    openAccountButton.enabled = NO;
}

@end
