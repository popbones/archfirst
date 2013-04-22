//
//  OrdersViewController.m
//  Bullsfirst
//
//  Created by Pong Choa
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

#import "AppDelegate.h"
#import "TabViewController.h"
#import "TradeViewController.h"
#import "TransferViewController.h"
#import "UserViewController.h"
#import "AddAccountViewController.h"
#import "AccountsViewController.h"
#import "GettingStartViewController.h"
#import "BFBrokerageAccountStore.h"


@implementation TabViewController
@synthesize portraitTitleBar;
@synthesize landscrapeTitleBar;
@synthesize restServiceObject;
@synthesize userPopOver;

- (id)init
{
    self = [super init];
    
    if(self)
    {
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Tab"];
        UIImage *i = [UIImage imageNamed:@"warningIcon.png"];
        [tbi setImage:i];        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

        UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(167.0f, 7.0f, 150.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
        //UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
        //tools.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        tools.clearsContextBeforeDrawing = NO;
        tools.clipsToBounds = NO;
        tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
        // anyone know how to get it perfect?
        tools.barStyle = -1; // clear background
        tools.contentMode = UIViewContentModeCenter;
        
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        
        // Trade Button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonBgImage = [UIImage imageNamed:@"trade_bg_normal.png"];
        [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [[button titleLabel] setFont:[UIFont fontWithName:@"Arial" size:12.0]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [[button titleLabel] setShadowOffset:CGSizeMake(0.0, 1.0)];
        tools.barStyle = -1; // clear background
        CGRect buttonFrame = [button frame];
        CGPoint origin = CGPointMake(100.0, 7.0);
        buttonFrame.origin = origin;
        buttonFrame.size.width =  44.0;
        buttonFrame.size.height =  20.0;
        [button setFrame:buttonFrame];
        [button setBackgroundImage:buttonBgImage forState:UIControlStateNormal];
        [button setTitle:@"Trade" forState:UIControlStateNormal];
        //Todo - Add Trade action 
        //[button addTarget:self action:@selector(logoutBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
        //[button addTarget:self action:@selector(tradeBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [buttons addObject:barButtonItem];
        
        // Transfer button
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [[button titleLabel] setFont:[UIFont fontWithName:@"Arial" size:12.0]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [[button titleLabel] setShadowOffset:CGSizeMake(0.0, 1.0)];
        buttonFrame = [button frame];
        origin = CGPointMake(217.0, 7.0);
        buttonFrame.origin = origin;
        buttonFrame.size.width =  59.0;
        buttonFrame.size.height =  20.0;
        [button setFrame:buttonFrame];
        tools.barStyle = -1; // clear background
        [button setBackgroundImage:buttonBgImage forState:UIControlStateNormal];
        [button setTitle:@"Transfer" forState:UIControlStateNormal];
        //Todo - Add Transfer action
        //[button addTarget:self action:@selector(logoutBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
        //[button addTarget:self action:@selector(transferBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
        barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [buttons addObject:barButtonItem];
        
        // Settings button
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        tools.barStyle = -1; // clear background
        buttonFrame = [button frame];
        origin = CGPointMake(282.0, 7.0);
        buttonFrame.origin = origin;
        buttonFrame.size.width =  22.0;
        buttonFrame.size.height =  20.0;
        [button setFrame:buttonFrame];
        [button setBackgroundImage:buttonBgImage forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"edit_icon.png"] forState:UIControlStateNormal];
        //Todo - Add Settings action
        [button addTarget:self action:@selector(logoutBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
        //[button addTarget:self action:@selector(transferBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
        barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [buttons addObject:barButtonItem];
            
        [tools setItems:buttons animated:NO];
        UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
        self.navigationItem.rightBarButtonItem = twoButtons;

    restServiceObject = [[BullFirstWebServiceObject alloc] initWithObject:self
                                                         responseSelector:@selector(responseReceived:) 
                                                      receiveDataSelector:@selector(receivedData:) 
                                                          successSelector:@selector(requestSucceeded:) 
                                                            errorSelector:@selector(requestFailed:)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateDevice) name:@"DEVICE_ROTATE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGettingStart) name:@"GETTING_START" object:nil];
    
    
}

- (void)viewDidUnload
{
    [self setPortraitTitleBar:nil];
    [self setLandscrapeTitleBar:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DEVICE_ROTATE" object:nil];
    [super viewDidUnload];
}

- (void) showGettingStart
{
    GettingStartViewController *gettingStartController = [[GettingStartViewController alloc] initWithNibName:@"GettingStartViewController" bundle:nil];
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:gettingStartController];

    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];

    [self presentViewController:controller animated:YES completion:NULL];
    controller.view.superview.bounds=CGRectMake(0, 0, 600,480);
}

- (void) rotateDevice
{
    [self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0.1];
    if ([userPopOver isPopoverVisible]) {
        [userPopOver dismissPopoverAnimated:NO];
    } 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice].systemVersion intValue] >= 5) {
        [self willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:0.1];
    }
    
    return YES;
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([userPopOver isPopoverVisible]) {
    [userPopOver dismissPopoverAnimated:NO];
    } 
        
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
    NSString *errorString = @"Try Refreshing!";
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

-(void)requestSucceeded:(NSData *)data
{
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    BFDebugLog(@"jsonObject = %@", jsonObject);
}

#pragma mark - KVO lifecycle

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
}

#pragma mark - IBActions

- (IBAction)logout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGOUT" object:nil];
    /*
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    if (!userPopOver) {
        UserViewController *controller = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
         UINavigationController *container=[[UINavigationController alloc]initWithRootViewController:controller];
       // container.navigationBar.backgroundColor=[UIColor colorWithRed:0.0 green:0 blue:0 alpha:1];
        [container.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        userPopOver = [[UIPopoverController alloc] initWithContentViewController:container];
        
        controller.popOver = userPopOver;
        controller.title=@"Settings";
        [userPopOver setPopoverContentSize:CGSizeMake(220, 250)];
    }
    if ([userPopOver isPopoverVisible]) {
        [userPopOver dismissPopoverAnimated:YES];
    } else {
        UIDeviceOrientation orientation= [[UIDevice currentDevice] orientation];
        if(orientation==UIDeviceOrientationLandscapeLeft||orientation==UIDeviceOrientationLandscapeRight)
        {
            [userPopOver presentPopoverFromRect:CGRectMake(1015, -15, 1, 1) inView:self.view  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
        else
        {
            [userPopOver presentPopoverFromRect:CGRectMake(765, -15, 1, 1) inView:self.view  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }
    }
    }
    else
    {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGOUT" object:nil];
    [self performSegueWithIdentifier:@"ShowLogin" sender:self];
    }
     */
}
- (IBAction)logoutBTNClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGOUT" object:nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [appDelegate.window makeKeyAndVisible];
    [appDelegate.window.rootViewController.navigationController popViewControllerAnimated:YES];
    [appDelegate.window.rootViewController presentViewController:controller animated:NO completion:NULL];
    //[self performSegueWithIdentifier:@"ShowLogin" sender:self];
}
- (IBAction)refreshBTNClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
}

- (IBAction)tradeBTNClicked:(id)sender {
    TradeViewController *tradeController = [[TradeViewController alloc] initWithNibName:@"TradeViewController" bundle:nil];    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:tradeController];
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentViewController:controller animated:YES completion:NULL];
    controller.view.superview.bounds=CGRectMake(0, 0, 500,400);
    controller.view.frame=CGRectMake(0, 0, 500,400);
}

- (IBAction)transferBTNClicked:(id)sender {
    TransferViewController *transferController = [[TransferViewController alloc] initWithNibName:@"TransferViewController" bundle:nil];    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:transferController];
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentViewController:controller animated:YES completion:NULL];
    controller.view.superview.bounds=CGRectMake(0, 0, 575,420);
    controller.view.frame=CGRectMake(0, 0, 575,420);
}

- (IBAction)addBTNClicked:(id)sender {
    AddAccountViewController *addAccointController = [[AddAccountViewController alloc] initWithNibName:@"AddAccountViewController" bundle:nil];    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:addAccointController];
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentViewController:controller animated:YES completion:NULL];
    controller.view.superview.bounds=CGRectMake(0, 0, 500,157+controller.navigationBar.frame.size.height);
}

@end
