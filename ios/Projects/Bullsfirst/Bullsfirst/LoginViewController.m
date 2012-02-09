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

#import "BullFirstWebServiceObject.h"

@implementation LoginViewController

@synthesize username;
@synthesize password;
@synthesize delegate;
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
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardIsShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardIsHidden:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
     
   
    [password setReturnKeyType:UIReturnKeyGo];
   
    password.delegate=self;
    username.delegate=self;
    restService = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];
    
    // Do any additional setup after loading the view from its nib.
    
}
-(void) didRotate:(NSNotification*) notification
{
    UIDeviceOrientation newOrientation=[[UIDevice currentDevice]orientation];
    if(newOrientation!=UIDeviceOrientationUnknown && newOrientation!=UIDeviceOrientationFaceUp&&newOrientation!=UIDeviceOrientationFaceDown)
    {
        orientation=newOrientation;
    }
    if(orientation==UIDeviceOrientationPortrait||orientation==UIDeviceOrientationPortraitUpsideDown)  
    {
        CGRect frame= username.frame;
       // frame.origin.y-=50;
        username.frame=frame;
        
    }else if(orientation==UIDeviceOrientationLandscapeLeft||orientation==UIDeviceOrientationLandscapeRight)
    {
        CGRect frame= username.frame;
       // frame.origin.y+=50;
        username.frame=frame;
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
    orientation=[[UIDevice currentDevice]orientation];
    if(orientation==UIDeviceOrientationLandscapeRight)  
    {
    NSTimeInterval animationDuration=0.3;
    CGRect frame= self.view.frame;
    frame.origin.x-=70;
    frame.size.width+=70;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame=frame;
    [UIView commitAnimations];
    }
    else if(orientation==UIDeviceOrientationLandscapeLeft)
    {
        NSTimeInterval animationDuration=0.3;
        CGRect frame= self.view.frame;
        frame.origin.x-=70;
        frame.size.width+=70;
        [UIView beginAnimations:@"KeyboardLandScape" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame=frame;
        [UIView commitAnimations];
    }
}
-(void) keyBoardIsHidden: (NSNotification*) notification
{
    orientation=[[UIDevice currentDevice]orientation];
    if(orientation==UIDeviceOrientationLandscapeRight||orientation==UIDeviceOrientationLandscapeLeft)  
    {
    NSTimeInterval animationDuration=0.3;
    CGRect frame= self.view.frame;
    frame.origin.x+=70;
    frame.size.width-=70;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame=frame;
    [UIView commitAnimations];
    }
    else
    {
    
    }
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
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    NSLog(@"jsonObject = %@", jsonObject);
    
    NSDictionary* nameObj=(NSDictionary*)jsonObject;
    
    NSString* fullName=[nameObj objectForKey:@"firstName"];
    
    fullName=[fullName stringByAppendingString:@" "];
    fullName=[fullName stringByAppendingString:[nameObj objectForKey:@"lastName"]];
    fullName=[fullName uppercaseString];
    [spinner stopAnimating];
    [delegate loggedin:fullName];
    [self dismissModalViewControllerAnimated:YES];
    
    
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
    openAccountViewController.delegate = self;
    
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

#pragma mark - Open Account View Controller delegate methods

-(void) newBFAccountCreated:(NSString*) fullName
{
    [delegate loggedin:fullName];
    [self dismissModalViewControllerAnimated:YES];
    
}

@end
