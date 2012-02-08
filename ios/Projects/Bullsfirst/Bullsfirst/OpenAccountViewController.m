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

@implementation OpenAccountViewController

//@synthesize lvc;
@synthesize delegate;
@synthesize restServiceObjectForCreateNewBFAccount;
@synthesize restServiceObjectForCreateNewBrokerageAccount;

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
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/brokerage_accounts"];
    
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    [jsonDic setValue:kdefaultBrokerageAccountName forKey:kAccountName];
    
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    
    [restServiceObjectForCreateNewBrokerageAccount postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
    
}


#pragma mark - selectors for handling rest call(Create new BF Account) callbacks

-(void)receivedDataForCreateNewBFAccount:(NSData *)data
{
    
}

-(void)responseReceivedForCreateNewBFAccount:(NSURLResponse *)data
{
    
}

-(void)requestFailedForCreateNewBFAccount:(NSError *)error
{ 
    [spinner stopAnimating];
    urlConnection = nil;
    jsonResponseData = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceededForCreateNewBFAccount:(NSData *)data
{
    jsonResponseData = [NSMutableData dataWithData:data];
    NSError *err;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonResponseData options:0 error:&err];
    
    BFDebugLog(@"jsonObject = %@", jsonObject);
    
    // TODO: Handle error conditions and timeout
    if([jsonObject objectForKey:kUrl])
    {
        [[NSUserDefaults standardUserDefaults] setValue:[jsonObject valueForKey:kUrl] forKey:kUrl];
        BFDebugLog(@"url = %@", [[NSUserDefaults standardUserDefaults] valueForKey:kUrl]);
    }
    else if([jsonObject objectForKey:kDetail])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:[jsonObject valueForKey:kDetail]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        [spinner stopAnimating];
        return;                
    }
    
    //Creating a new default brokerage account within the above user account
    [self createBrokerageAccount];

}

#pragma mark - selectors for handling rest call(Create new Brokerage Account) callbacks

-(void)receivedDataForCreateNewBrokerageAccount:(NSData *)data
{
    
}

-(void)responseReceivedForCreateNewBrokerageAccount:(NSURLResponse *)data
{
    
}

-(void)requestFailedForCreateNewBrokerageAccount:(NSError *)error
{ 
    [spinner stopAnimating];
    urlConnection = nil;
    jsonResponseData = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceededForCreateNewBrokerageAccount:(NSData *)data
{
    [spinner stopAnimating];
    
//    [[lvc username] setText:[username text]];
//    [[lvc password] setText:[password text]];
    
    [self performSelectorOnMainThread:@selector(dismissModalViewControllerAnimated:) withObject:nil waitUntilDone:YES];
    [delegate newBFAccountCreated];
    

}


#pragma mark - Methods

- (IBAction)openAccountButtonClicked:(id)sender
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
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/users/"];
    
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    [jsonDic setValue:[firstName text] forKey:kFirstName];
    [jsonDic setValue:[lastName text] forKey:kLastName];
    [jsonDic setValue:[username text] forKey:kUsername];
    [jsonDic setValue:[password text] forKey:kPassword];
        
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    
    //Opening new BullFirst Account
    [restServiceObjectForCreateNewBFAccount postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
    
    //updating the webservice object about the credentials
    [WebServiceObject userLoginCredentialWithUsername:[username text] password:[password text]];
    

}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    restServiceObjectForCreateNewBFAccount = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceivedForCreateNewBFAccount:) receiveDataSelector:@selector(receivedDataForCreateNewBFAccount:) successSelector:@selector(requestSucceededForCreateNewBFAccount:) errorSelector:@selector(requestFailedForCreateNewBFAccount:)];
    restServiceObjectForCreateNewBrokerageAccount = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceivedForCreateNewBrokerageAccount:) receiveDataSelector:@selector(receivedDataForCreateNewBrokerageAccount:) successSelector:@selector(requestSucceededForCreateNewBrokerageAccount:) errorSelector:@selector(requestFailedForCreateNewBrokerageAccount:)];
    
    newAccountCreated = NO;
    
    
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


@end
