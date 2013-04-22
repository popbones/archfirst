//
//  LoginViewController.m
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

#import "LoginViewController.h"
#import "AccountsViewController.h"
#import "PositionsViewController.h"
#import "OrdersViewController.h"
#import "TransactionsViewController.h"
#import "BFBrokerageAccountStore.h"
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

#pragma mark - Handling Keyboard notifications
static BOOL keyBoardVisible;

-(void) keyBoardWillHideAnimation:(id) duration
{
    NSTimeInterval animationDuration=[duration floatValue];
    keyBoardVisible = NO;
    orientation = [[UIApplication sharedApplication] statusBarOrientation];
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    if(orientation==UIDeviceOrientationLandscapeRight||orientation==UIDeviceOrientationLandscapeLeft)  
    {
        CGRect viewframe= groupedView.frame;
        viewframe.origin.y+=100;
        viewframe.size.height-=100;
        //groupedView.frame=viewframe;
        CGRect imageframe= backgroundImage.frame;
        imageframe.origin.y+=100;
        imageframe.size.height-=100;
        backgroundImage.frame = imageframe;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        backgroundImage.frame = imageframe;
        CGAffineTransform transform= CGAffineTransformMakeTranslation(0, 0);
        groupedView.transform = transform;
        [UIView commitAnimations];
    }
     }
}

-(void) keyBoardWillHide:(NSNotification*) notification
{
    
    id duration = [[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [self keyBoardWillHideAnimation:duration];
}



-(void) keyboardWillShowAnimation:(id) duration
{
    NSTimeInterval animationDuration = [duration floatValue];
    keyBoardVisible = YES;
    orientation = [[UIApplication sharedApplication] statusBarOrientation];
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    if(orientation==UIDeviceOrientationLandscapeRight||orientation==UIDeviceOrientationLandscapeLeft)  
    {
        CGRect viewframe= groupedView.frame;
        viewframe.origin.y-=100;
        viewframe.size.height+=100;
        //groupedView.frame=viewframe;
        CGRect imageframe= backgroundImage.frame;
        imageframe.origin.y-=100;
        imageframe.size.height+=100;
        backgroundImage.frame = imageframe;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        backgroundImage.frame=imageframe;
        CGAffineTransform transform= CGAffineTransformMakeTranslation(0, -100);
        groupedView.transform = transform;
        [UIView commitAnimations];
    }
     }
}

-(void) keyBoardWillShow: (NSNotification*) notification
{
    
    id duration = [[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey];
   // NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(keyboardWillShowAnimation:) userInfo:nil repeats:NO];
    [self keyboardWillShowAnimation:duration];
    
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
    //Added for iPhone changes, iPhone interface changes are managed from struts/springs
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
        {
        if (keyBoardVisible == YES)
            return;
        
        groupedView.frame=CGRectMake(255, 156, groupedView.frame.size.width, groupedView.frame.size.height);
        backgroundImage.frame=CGRectMake(0, 0, 1024, 768);
        [backgroundImage setImage:[UIImage imageNamed:@"login-screen-background-landscape.png"]];
       
        }
        else if(toInterfaceOrientation==UIInterfaceOrientationPortrait||toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown)
        {
        groupedView.frame=CGRectMake(143, 177, groupedView.frame.size.width, groupedView.frame.size.height);
         backgroundImage.frame=CGRectMake(0, 0, 768, 1024);
        [backgroundImage setImage:[UIImage imageNamed:@"login-screen-background-portrait.png"]];
            
        }
     }

}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    groupedView.backgroundColor=[UIColor clearColor];
    
    loginButton.enabled=FALSE;
    password.delegate=self;
    username.delegate=self;
    restService = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];
    password.returnKeyType=UIReturnKeyGo;
    username.returnKeyType=UIReturnKeyGo;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newBFAccountCreated:) name:@"NEW_ACCOUNT_CREATED" object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [username addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [password addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [password addTarget:self action:@selector(passwordEditingStarted:) forControlEvents:UIControlEventEditingDidBegin];
    
    password.clearsOnBeginEditing = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice].systemVersion intValue] >= 5) {
        [self willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:0.1];
    }
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    //Added for iPhone changes, iPhone interface changes are managed from struts/springs
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(orientation==UIDeviceOrientationLandscapeLeft||orientation==UIDeviceOrientationLandscapeRight)
        {
            groupedView.frame=CGRectMake(255, 156, groupedView.frame.size.width, groupedView.frame.size.height);
            backgroundImage.frame=CGRectMake(0, 0, 1024, 768);
            [backgroundImage setImage:[UIImage imageNamed:@"login-screen-background-landscape.png"]];
      
        }
        else
        {
            groupedView.frame=CGRectMake(143, 177, groupedView.frame.size.width, groupedView.frame.size.height);
            backgroundImage.frame=CGRectMake(0, 0, 768, 1024);
            //[backgroundImage setImage:[UIImage imageNamed:@"login-screen-background-portrait.png"]];
            [backgroundImage setImage:[UIImage imageNamed:@"apply_bg_hover.png"]];
    
        }
     }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
-(void) clearUserData
{
    password.text=@"";
    username.text=@"";
}
-(void)requestSucceeded:(NSData *)data
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.currentUser = [BFUser userFromJSONData:data];
    
    [spinner stopAnimating];
    [self clearUserData];
    //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    [self dismissViewControllerAnimated:NO completion:NULL];
    //[self dismissModalViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGIN" object:nil];
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
        [self loginAction];
    }
    
    return YES;
}
- (IBAction)login:(id)sender
{
    [self loginAction];
}
- (IBAction)openAccount:(id)sender
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    openAccountViewController = [[OpenAccountViewController alloc] initWithNibName:@"OpenAccountViewController" bundle:nil];
    
    [openAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [openAccountViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentViewController:openAccountViewController animated:YES completion:NULL];
    //[self presentModalViewController:openAccountViewController animated:YES];
    openAccountViewController.view.superview.bounds=CGRectMake(0, 0, 560,455);
   }
    else
        [self performSegueWithIdentifier:@"OpenAccount" sender:self];
}
 //Added for iPhone changes, 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
    if([segue.identifier isEqualToString:@"OpenAccount"])
    {
    OpenAccountViewController *asker = (OpenAccountViewController *)segue.destinationViewController;
    //asker.delegate = self;
    }
   */
}
-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [viewController viewDidAppear:YES];
    
}

#pragma mark - MVC delegate methods

-(void) newBFAccountCreated:(NSString*) fullName
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGIN" object:nil];
    [self clearUserData];
    [self dismissViewControllerAnimated:YES completion:NULL];
    //[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - textField call back methods

-(void) textChanged:(UITextField*) textField
{
    if(username.text.length ==0 || password.text.length==0)
    {
        loginButton.enabled = NO;
    }
    else
    {
        loginButton.enabled = YES;
    }
}

-(void) passwordEditingStarted:(UITextField*) textField
{
    if(textField == password)
        loginButton.enabled = NO;
}
- (void)cancelButtonPressed:(OpenAccountViewController *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
   
}


@end
