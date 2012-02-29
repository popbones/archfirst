//
//  EditAccountNameViewController.m
//  Bullsfirst
//
//  Created by Vivekan Arther
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

#import "EditAccountNameViewController.h"
#import "AccountsViewController.h"
#import "BullFirstWebServiceObject.h"


@implementation EditAccountNameViewController
@synthesize restServiceObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil oldAccountName:(NSString*) oldAccName withId:(NSString*) accId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        oldAccountName=oldAccName;
        accountId = accId;
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

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ModalView_TitleBar_BackgroundGradient.jpg"] forBarMetrics:UIBarMetricsDefault];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
//    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.navigationItem.title =  @"Edit Account";
/*    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = label;
    label.text = @"Edit Account";
    label.textColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:0 alpha:1];
    [label sizeToFit];
 */
    restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];
    accountName.text = oldAccountName;
    accountName.returnKeyType = UIReturnKeyGo;
    [accountName becomeFirstResponder];
    
    
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
    NSString *errorString = [NSString stringWithString:@"Try Again!"];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    editAccountButton.enabled = YES;
    cancelButton.enabled = YES;
}

-(void)requestSucceeded:(NSData *)data
{
    [spinner stopAnimating];
    [self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
    
}


#pragma mark - methods

-(void) editAccountAction
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
    editAccountButton.enabled = NO;
    cancelButton.enabled = NO;
    
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@",@"http://archfirst.org/bfoms-javaee/rest/secure/accounts/",accountId,@"/change_name"];
    BFDebugLog(@"EDIT ACCOUNT NAME URL %@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];    
    [jsonDic setValue:[accountName text] forKey:kNewAccountName];
    
    NSError *err;
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:&err];
    
    [restServiceObject postRequestWithURL:url body:jsonBodyData contentType:@"application/json"];
}

- (IBAction)editAccountButtonClicked:(id)sender
{
  
    [self editAccountAction];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITextField delegate methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self editAccountAction];
    return YES;
}

@end
