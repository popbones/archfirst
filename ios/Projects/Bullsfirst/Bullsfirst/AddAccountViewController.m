//
//  AddAccountViewController.m
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

#import "AddAccountViewController.h"
#import "AccountsViewController.h"
#import "BullFirstWebServiceObject.h"

@implementation AddAccountViewController

@synthesize avc;
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
    urlConnection = nil;
    jsonResponseData = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    
    addAccountButton.enabled = YES;
    cancelButton.enabled = YES;
}

-(void)requestSucceeded:(NSData *)data
{
    [spinner stopAnimating];
    jsonResponseData = [NSMutableData dataWithData:data];
    [self dismissModalViewControllerAnimated:YES];
    
    addAccountButton.enabled = YES;
    cancelButton.enabled = YES;
    
    [avc refreshAccounts:self];

}




#pragma mark - Methods

- (IBAction)addAccountButtonClicked:(id)sender
{
    // Check for errors    
    if([[accountName text] isEqual:@""])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"Account Name is required"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        return;        
    }
    
    [spinner startAnimating];
    
    addAccountButton.enabled = NO;
    cancelButton.enabled = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://archfirst.org/bfoms-javaee/rest/secure/brokerage_accounts"];
    
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    [jsonDic setValue:[accountName text] forKey:kAccountName];
    
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    
    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
    
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
    
    restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];
    
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
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}




@end

