//
//  LoginViewController.m
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

#import "LoginViewController.h"
#import "OpenAccountViewController.h"

#import "AccountsViewController.h"
#import "PositionsViewController.h"
#import "OrdersViewController.h"
#import "TransactionsViewController.h"
#import "BFBrokerageAccountStore.h"
#import "BFToolbar.h"

@implementation LoginViewController

@synthesize username;
@synthesize password;

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
    if(interfaceOrientation==UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login-screen-background-landscape.png"]];
    }
    else
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login-screen-background-portrait.png"]];
    }
    return YES;
}

#pragma mark - Methods

- (IBAction)login:(id)sender
{
    
    if([[username text] isEqual:@""] || [[password text] isEqual:@""])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"All fields are required"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        return;        
    }
    
    jsonResponseData = [[NSMutableData alloc] init];
    [spinner startAnimating];
    
    NSString *userURL = [NSString stringWithFormat:@"%@%@", @"http://archfirst.org/bfoms-javaee/rest/users/",[username text]];
    NSURL *url = [NSURL URLWithString:userURL];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kRequestTimeout];
    
    //[req setHTTPMethod:@"GET"]; // default
    [req setValue:[password text] forHTTPHeaderField:@"password"];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    
    [[NSUserDefaults standardUserDefaults] setValue:[password text] forKey:kPassword];
    
    [username resignFirstResponder];
    [password resignFirstResponder];
    
}

- (IBAction)openAccount:(id)sender
{
    OpenAccountViewController *openAccountViewController = [[OpenAccountViewController alloc] initWithNibName:@"OpenAccountViewController" bundle:nil];
    [openAccountViewController setLvc:self];
    
    [openAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [openAccountViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:openAccountViewController animated:YES];
}

- (void)logout
{
    // Clear login form
    [username setText:@""];
    [password setText:@""];
    
    // Clear NSUserDefaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    // Clear BrokerageAccountStore
    [[BFBrokerageAccountStore defaultStore] clearAccounts]; 
}

#pragma mark - NSURLCollectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [jsonResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *jsonCheck = [[NSString alloc] initWithData:jsonResponseData encoding:NSUTF8StringEncoding];    
    BFDebugLog(@"jsonCheck = %@", jsonCheck);
    
    // TODO: Handle error conditions and timeout
    
    NSError *err;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonResponseData options:0 error:&err];
    
    BFDebugLog(@"jsonObject = %@", jsonObject);
    
    if([jsonObject isEqual:[NSNull null]] || (jsonObject == nil))
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"Error logging in.\nPlease try again."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        [spinner stopAnimating];
        return;        
    }
    
    // Store user data in standardUserDefaults
    [[NSUserDefaults standardUserDefaults] setValue:[jsonObject valueForKey:kFirstName] forKey:kFirstName];
    [[NSUserDefaults standardUserDefaults] setValue:[jsonObject valueForKey:kLastName] forKey:kLastName];
    [[NSUserDefaults standardUserDefaults] setValue:[jsonObject valueForKey:kUsername] forKey:kUsername];
    
    BFDebugLog(@"firstName = %@", [[NSUserDefaults standardUserDefaults] valueForKey:kFirstName]);
    BFDebugLog(@"lastName = %@", [[NSUserDefaults standardUserDefaults] valueForKey:kLastName]);
    BFDebugLog(@"username = %@", [[NSUserDefaults standardUserDefaults] valueForKey:kUsername]);
    
    [spinner stopAnimating];
    
    // TODO: Check for successful login
    
    // Create the tab bar controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    tabBarController.delegate = self;
    
    // Create the view controllers
    //AccountsViewController *vc1 = [[AccountsViewController alloc] init];
    AccountsViewController *accountsViewController = [[AccountsViewController alloc] initWithNibName:@"AccountsViewController" bundle:nil];
    PositionsViewController *vc2 = [[PositionsViewController alloc] init];
    OrdersViewController *vc3 = [[OrdersViewController alloc] init];
    TransactionsViewController *vc4 = [[TransactionsViewController alloc] init];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:accountsViewController,vc2,vc3,vc4, nil];
    
    // NOTE: Would rather only have one instance of BFToolbar; use one per tab for now
    BFToolbar *toolBar1 = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    BFToolbar *toolBar2 = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    BFToolbar *toolBar3 = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    BFToolbar *toolBar4 = [[BFToolbar alloc] initWithNibName:@"BFToolbar" bundle:nil];
    
    [toolBar1 setLvc:self]; [toolBar1 setTbc:tabBarController];
    [toolBar2 setLvc:self]; [toolBar2 setTbc:tabBarController];
    [toolBar3 setLvc:self]; [toolBar3 setTbc:tabBarController];
    [toolBar4 setLvc:self]; [toolBar4 setTbc:tabBarController];
    
    // Need to take ownership of toolbars; adding it to the view is not enough
    [accountsViewController setToolbar:toolBar1]; [[accountsViewController view] addSubview:[toolBar1 view]];
    [vc2 setToolbar:toolBar2]; [[vc2 view] addSubview:[toolBar2 view]];
    [vc3 setToolbar:toolBar3]; [[vc3 view] addSubview:[toolBar3 view]];
    [vc4 setToolbar:toolBar4]; [[vc4 view] addSubview:[toolBar4 view]];
    
    [[accountsViewController view] bringSubviewToFront:[toolBar1 view]];
    [[vc2 view] bringSubviewToFront:[toolBar2 view]];
    [[vc3 view] bringSubviewToFront:[toolBar3 view]];
    [[vc4 view] bringSubviewToFront:[toolBar4 view]];
    
    [tabBarController setViewControllers:viewControllers];
    
    [tabBarController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];    
    [self presentModalViewController:tabBarController animated:YES];     
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    urlConnection = nil;
    jsonResponseData = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

/*
 - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
 BFDebugLog(@"response = %@", response);
 }
 */

/*
 - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
 {
 BFDebugLog(@"challenge");
 
 if([challenge previousFailureCount] > 0) {        
 NSError *failure = [challenge error];
 BFErrorLog(@"Can't authenticate: %@", [failure localizedDescription]);
 
 [[challenge sender] cancelAuthenticationChallenge:challenge];
 return;
 }
 
 NSURLCredential *newCred = [NSURLCredential credentialWithUser:[username text] password:[password text] persistence:NSURLCredentialPersistenceNone];
 
 // Supply the credential to the sender of the challenge
 [[challenge sender] useCredential:newCred forAuthenticationChallenge:challenge];
 }
 */


#pragma mark tabBarController delegate methods

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [viewController viewDidAppear:YES];
    
}

@end
