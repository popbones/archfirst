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
#import "AccountsViewController.h"
#import "PositionsViewController.h"
#import "OrdersViewController.h"
#import "TransactionsViewController.h"
#import "BFBrokerageAccountStore.h"
#import "BFToolbar.h"
#import "BFUser.h"
#import "BullFirstWebServiceObject.h"
#import "AppDelegate.h"

@implementation LoginViewController

@synthesize username;
@synthesize password;
@synthesize restService;

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
-(void) moveView:(UIView *) view duration:(NSTimeInterval) duration curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGAffineTransform transform=CGAffineTransformMakeTranslation(x, y);
    view.transform=transform;
    [UIView commitAnimations];
}
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        groupedView.frame=CGRectMake(255, 156, groupedView.frame.size.width, groupedView.frame.size.height);
        backgroundImage.frame=CGRectMake(0, 0, 1024, 768);
        [backgroundImage setImage:[UIImage imageNamed:@"login-screen-background-landscape.png"]];
        openAccountButton.frame=CGRectMake(433, 694, openAccountButton.frame.size.width, openAccountButton.frame.size.height);
    }
    else
    {
        groupedView.frame=CGRectMake(143, 177, groupedView.frame.size.width, groupedView.frame.size.height);
         backgroundImage.frame=CGRectMake(0, 0, 768, 1024);
        [backgroundImage setImage:[UIImage imageNamed:@"login-screen-background-portrait.png"]];
        openAccountButton.frame=CGRectMake(313, 710, openAccountButton.frame.size.width, openAccountButton.frame.size.height);
    }


}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    groupedView.backgroundColor=[UIColor clearColor];
    [password setReturnKeyType:UIReturnKeyGo];
   
    password.delegate=self;
    username.delegate=self;
    restService = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newBFAccountCreated:) name:@"NEW_ACCOUNT_CREATED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardIsShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardIsHidden:) name:UIKeyboardDidHideNotification object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    orientation=[[UIDevice currentDevice]orientation];
    if(orientation==UIDeviceOrientationLandscapeLeft||orientation==UIDeviceOrientationLandscapeRight)
    {
        groupedView.frame=CGRectMake(255, 156, groupedView.frame.size.width, groupedView.frame.size.height);
        backgroundImage.frame=CGRectMake(0, 0, 1024, 768);
        [backgroundImage setImage:[UIImage imageNamed:@"login-screen-background-landscape.png"]];
        openAccountButton.frame=CGRectMake(433, 694, openAccountButton.frame.size.width, openAccountButton.frame.size.height);
    }
    else
    {
        groupedView.frame=CGRectMake(143, 177, groupedView.frame.size.width, groupedView.frame.size.height);
        backgroundImage.frame=CGRectMake(0, 0, 768, 1024);
        [backgroundImage setImage:[UIImage imageNamed:@"login-screen-background-portrait.png"]];
        openAccountButton.frame=CGRectMake(313, 710, openAccountButton.frame.size.width, openAccountButton.frame.size.height);
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) keyBoardIsShown: (NSNotification*) notification
{
    NSTimeInterval animationDuration=0.3;
    orientation=[[UIDevice currentDevice]orientation];
    if(orientation==UIDeviceOrientationLandscapeRight||orientation==UIDeviceOrientationLandscapeLeft)  
    {
   
    CGRect viewframe= groupedView.frame;
    viewframe.origin.y-=100;
    viewframe.size.height+=100;
       groupedView.frame=viewframe;
        CGRect imageframe= backgroundImage.frame;
        imageframe.origin.y-=100;
        imageframe.size.height+=100;
       [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
       [UIView setAnimationDuration:animationDuration];
        backgroundImage.frame=imageframe;
    [UIView commitAnimations];
    }
  
}
-(void) keyBoardIsHidden: (NSNotification*) notification
{
    NSTimeInterval animationDuration=0.3;
    orientation=[[UIDevice currentDevice]orientation];
    if(orientation==UIDeviceOrientationLandscapeRight||orientation==UIDeviceOrientationLandscapeLeft)  
    {
        CGRect viewframe= groupedView.frame;
        viewframe.origin.y+=100;
        viewframe.size.height-=100;
        groupedView.frame=viewframe;
        CGRect imageframe= backgroundImage.frame;
        imageframe.origin.y+=100;
        imageframe.size.height-=100;
       [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        backgroundImage.frame=imageframe;
        [UIView commitAnimations];

    }
   
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    NSString *displayMsg = [NSString stringWithFormat:@"Connection failed! Error - %@ %@ %d",
                            [error localizedDescription],
                            [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey],
                            [error code]];
    NSLog(@"%@", displayMsg); 
    NSString *alertViewTitle=@"Invalid Username or Password";
    NSString *alertViewMsg=@"If you are new here, please open an account with Bullsfirst";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertViewTitle message:alertViewMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)requestSucceeded:(NSData *)data
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.currentUser = [BFUser userFromJSONData:data];
    
    [spinner stopAnimating];
    [self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGIN" object:nil];
}



#pragma mark - Methods

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
   
}
-(void) loginAction
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
    
    NSURLCredential* userCredential = [WebServiceObject userLoginCredentialWithUsername:[username text] password:[password text]];
    
    [restService requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://archfirst.org/bfoms-javaee/rest/users/",[userCredential user]]]];
    
    [spinner startAnimating];
    
    [username resignFirstResponder];
    [password resignFirstResponder];
    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField==password)
    {
        [password resignFirstResponder];
      //  [self moveView:self.view duration:3 curve:UIViewAnimationCurveLinear x:0 y:60];
        [self loginAction];
    }
    else
    {
        [username resignFirstResponder];
      //  [self moveView:self.view duration:3 curve:UIViewAnimationCurveLinear x:0 y:60];

    }
    
    return YES;
}
- (IBAction)login:(id)sender
{
    [self loginAction];
}

- (IBAction)openAccount:(id)sender
{
   
    openAccountViewController = [[OpenAccountViewController alloc] initWithNibName:@"OpenAccountViewController" bundle:nil];
    
    [openAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [openAccountViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:openAccountViewController animated:YES];
}

- (void)logout
{
    // Clear login form
    [username setText:@""];
    [password setText:@""];
    
    // Clear BrokerageAccountStore
    [[BFBrokerageAccountStore defaultStore] clearAccounts]; 
}



-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [viewController viewDidAppear:YES];
    
}

#pragma mark - MVC delegate methods

-(void) newBFAccountCreated:(NSString*) fullName
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGIN" object:nil];
    [self dismissModalViewControllerAnimated:YES];
    
}

@end
