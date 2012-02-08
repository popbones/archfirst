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
    UIBezierPath *passwordMaskPath=[UIBezierPath bezierPathWithRoundedRect:password.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
   
    CAShapeLayer *passwordMasklayer=[CAShapeLayer layer];
    passwordMasklayer.frame=password.bounds;
    passwordMasklayer.path=passwordMaskPath.CGPath;
    password.layer.mask=passwordMasklayer;
    UIBezierPath *usernameMaskPath=[UIBezierPath bezierPathWithRoundedRect:password.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    
    CAShapeLayer *usernameMaskLayer=[CAShapeLayer layer];
    usernameMaskLayer.frame=username.bounds;
    usernameMaskLayer.path=usernameMaskPath.CGPath;
    username.layer.mask=usernameMaskLayer;
 
    [username setBackgroundColor:[UIColor whiteColor]];
    [password setReturnKeyType:UIReturnKeyGo];
    [password setBackgroundColor:[UIColor whiteColor]];
    password.delegate=self;
    
    restService = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];
    
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error." message:displayMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)requestSucceeded:(NSData *)data
{
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    NSLog(@"jsonObject = %@", jsonObject);
    
    [spinner stopAnimating];
    [delegate loggedin];
    [self dismissModalViewControllerAnimated:YES];
    
    // TODO: Check for successful login
    /*
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
    [self presentModalViewController:tabBarController animated:YES]; */
}



#pragma mark - Methods

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    //[self moveView:self.view duration:3 curve:UIViewAnimationCurveLinear x:0 y:-60];
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
    
    // Clear NSUserDefaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    // Clear BrokerageAccountStore
    [[BFBrokerageAccountStore defaultStore] clearAccounts]; 
}


#pragma mark tabBarController delegate methods

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [viewController viewDidAppear:YES];
    
}

#pragma mark - Open Account View Controller delegate methods

-(void) newBFAccountCreated
{
    [delegate loggedin];
    [self dismissModalViewControllerAnimated:YES];
    
}

@end
