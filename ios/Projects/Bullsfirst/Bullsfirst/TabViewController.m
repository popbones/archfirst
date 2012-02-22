//
//  OrdersViewController.m
//  Bullsfirst
//
//  Created by Pong Choa
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

#import "TabViewController.h"
#import "TradeViewController.h"
#import "TransferViewController.h"
#import "FilterViewController.h"
#import "UserViewController.h"
#import "AddAccountViewController.h"
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
	// Do any additional setup after loading the view, typically from a nib.
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"HeaderBar_BackgroundGradient.jpg"] forBarMetrics:UIBarMetricsDefault];

    UIToolbar *tools = [[UIToolbar alloc]
                        initWithFrame:CGRectMake(0.0f, 0.0f, 190.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
    // anyone know how to get it perfect?
    tools.barStyle = -1; // clear background
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    // Add buttons to toolbar and toolbar to nav bar.
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStylePlain;
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    [buttons addObject:barButtonItem];
    
    // Create a spacer.
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barButtonItem.width = 10.0f;
    [buttons addObject:barButtonItem];
    
    barButtonItem = [[UIBarButtonItem alloc]
                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(transferBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStylePlain;
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    [buttons addObject:barButtonItem];

    // Create a spacer.
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barButtonItem.width = 10.0f;
    [buttons addObject:barButtonItem];

    barButtonItem = [[UIBarButtonItem alloc]
                     initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(tradeBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStylePlain;
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    [buttons addObject:barButtonItem];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barButtonItem.width = 10.0f;
    [buttons addObject:barButtonItem];
    
    
    
    barButtonItem = [[UIBarButtonItem alloc]
                     initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStylePlain;
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    [buttons addObject:barButtonItem];

    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barButtonItem.width = 10.0f;
    [buttons addObject:barButtonItem];

    barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SettingsButton.png"] style:UIBarButtonItemStyleBordered target:(id)self action:@selector(logout)];
    barButtonItem.style = UIBarButtonItemStylePlain;
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    [buttons addObject:barButtonItem];

    [tools setItems:buttons animated:NO];
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem = twoButtons;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = @"Orders";
    [label sizeToFit];
    
    portraitTitleBar.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    landscrapeTitleBar.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];

    restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateDevice) name:@"DEVICE_ROTATE" object:nil];

}

- (void)viewDidUnload
{
    [self setPortraitTitleBar:nil];
    [self setLandscrapeTitleBar:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DEVICE_ROTATE" object:nil];
    [super viewDidUnload];
}

- (void) rotateDevice
{
    [self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0.1];
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
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
    }
    else
    {
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
    NSString *errorString = [NSString stringWithString:@"Try Refreshing!"];
    
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
    if (!userPopOver) {
        UserViewController *controller = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
        CGRect frame = controller.view.frame;
        
        userPopOver = [[UIPopoverController alloc] initWithContentViewController:controller];
        controller.popOver = userPopOver;
        [userPopOver setPopoverContentSize:frame.size];
    }
    if ([userPopOver isPopoverVisible]) {
        [userPopOver dismissPopoverAnimated:YES];
    } else {
        [userPopOver presentPopoverFromBarButtonItem: self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (IBAction)refreshBTNClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
}

- (IBAction)tradeBTNClicked:(id)sender {
    TradeViewController *tradeController = [[TradeViewController alloc] initWithNibName:@"TradeViewController" bundle:nil];    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:tradeController];
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)transferBTNClicked:(id)sender {
    TransferViewController *controller = [[TransferViewController alloc] initWithNibName:@"TransferViewController" bundle:nil];    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)filterBTNClicked:(id)sender {
    FilterViewController *controller = [[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
  
    
    [self presentModalViewController:controller animated:YES];
}
- (IBAction)addBTNClicked:(id)sender {
    AddAccountViewController *controller = [[AddAccountViewController alloc] initWithNibName:@"AddAccountViewController" bundle:nil];    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];

    
    [self presentModalViewController:controller animated:YES];
    controller.view.superview.bounds=CGRectMake(0, 0, 500,235);
    controller.view.frame=CGRectMake(0, 0, 500,235);
}

@end