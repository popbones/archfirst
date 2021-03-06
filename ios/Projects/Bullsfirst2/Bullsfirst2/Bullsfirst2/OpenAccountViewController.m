//
//  OpenAccountViewController.m
//  Bullsfirst
//
//  Created by Joe Howard
//  Edited by Rashmi Garg - changes for storyboard and Bullsfirst2 design
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
    
    NSString *errorString = @"Try Again!";
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
    
    if([firstName.text isEqualToString:@""])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"First Name field must not be empty."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    if([lastName.text isEqualToString:@""])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"Last Name field must not be empty."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    if([username.text isEqualToString:@""])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"Username field must not be empty."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    if([password.text isEqualToString:@""])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"Password field must not be empty."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    if([confirmpassword.text isEqualToString:@""])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"Confirm Password field must not be empty."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    
    if(![[password text] isEqual:[confirmpassword text]])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"Passwords do not match"
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
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - View lifecycle


-(void) keyBoardWillShow: (NSNotification*) notification
{
    UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
    if(UIDeviceOrientationIsLandscape(orientation))
    {
        CGRect  rect=self.view.frame;
        scrollview.frame=CGRectMake(rect.origin.x,rect.origin.y-10, rect.size.width, rect.size.height-100);
        
    }
    else
    {
        CGRect  rect=self.view.frame;
        scrollview.frame=CGRectMake(rect.origin.x,rect.origin.y-10, rect.size.width, rect.size.height-30);
    }
    
    
}
-(void) keyBoardWillHide:(NSNotification*) notification
{
    
    UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
    if(UIDeviceOrientationIsLandscape(orientation))
    {
        CGRect  rect=self.view.frame;
        scrollview.frame=CGRectMake(rect.origin.x,rect.origin.y-10, rect.size.width, rect.size.height);
    }
    else
    {
        CGRect  rect=self.view.frame;
        scrollview.frame=CGRectMake(rect.origin.x,rect.origin.y-10, rect.size.width, rect.size.height);
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    orientationChanged = YES;
    
    firstName.returnKeyType = UIReturnKeyGo;
    lastName.returnKeyType = UIReturnKeyGo;
    username.returnKeyType = UIReturnKeyGo;
    password.returnKeyType = UIReturnKeyGo;
    confirmpassword.returnKeyType = UIReturnKeyGo;
    
    
    [navBar setBackgroundImage:[UIImage imageNamed:@"ModalView_TitleBar_BackgroundGradient.jpg"] forBarMetrics:UIBarMetricsDefault];
    textFields=[NSArray arrayWithObjects:firstName,lastName,username,password,confirmpassword, nil];
    
    
    restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];
    
    
    [password addTarget:self action:@selector(passwordEditingStarted:) forControlEvents:UIControlEventEditingDidBegin];
    [confirmpassword addTarget:self action:@selector(passwordEditingStarted:) forControlEvents:UIControlEventEditingDidBegin];
    
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];
    
    password.clearsOnBeginEditing = YES;
    confirmpassword.clearsOnBeginEditing = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    CGRect  rect=self.view.frame;
    scrollview.contentSize=CGSizeMake(rect.size.width, rect.size.height);
    
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
            scrollview.frame=CGRectMake(rect.origin.x,rect.origin.y-10, rect.size.width, rect.size.height-100);
            
        }
        else
        {
            CGRect  rect=self.view.frame;
            scrollview.frame=CGRectMake(rect.origin.x,rect.origin.y-10, rect.size.width, rect.size.height-30);
        }
        [activeTextField becomeFirstResponder];
        
        
    }
    
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
    [self openAccountAction];
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
            scrollview.frame=CGRectMake(rect.origin.x,rect.origin.y-10, rect.size.width, rect.size.height-100);
            
        }
        else
        {
            CGRect  rect=self.view.frame;
            scrollview.frame=CGRectMake(rect.origin.x,rect.origin.y-10, rect.size.width, rect.size.height-30);
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




#pragma mark - TextField callback methods
-(void) passwordEditingStarted:(UITextField*) textField
{
    //    openAccountButton.enabled = NO;
}

@end
