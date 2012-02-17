//
//  OrdersViewController.m
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

#import "OrdersViewController.h"
#import "TradeViewController.h"
#import "TransferViewController.h"
#import "FilterViewController.h"
#import "UserViewController.h"

@implementation OrdersViewController
@synthesize orderTBL;
@synthesize portraitTitleBar;
@synthesize landscrapeTitleBar;
@synthesize filterBTN;
@synthesize transferBTN;
@synthesize tradeBTN;
@synthesize refreshBTN;
@synthesize restServiceObject;
@synthesize orders;
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
        [tbi setTitle:@"Orders"];
        UIImage *i = [UIImage imageNamed:@"TabBar_Orders.png"];
        [tbi setImage:i];        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"img_bg_yellow.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bullsfirst-HeaderBarLogo.png"]];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SettingsButton.png"] style:UIBarButtonItemStyleBordered target:(id)self action:@selector(logout)];
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    self.navigationItem.rightBarButtonItem = barButtonItem;
/*    
    UIToolbar *tools = [[UIToolbar alloc]
                        initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
    // anyone know how to get it perfect?
    tools.barStyle = -1; // clear background
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    // Add buttons to toolbar and toolbar to nav bar.
    barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Transfer" style:UIBarButtonItemStylePlain target:self action:@selector(transferBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    [buttons addObject:barButtonItem];

    // Create a spacer.
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barButtonItem.width = 12.0f;
    [buttons addObject:barButtonItem];

    barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Trade" style:UIBarButtonItemStylePlain target:self action:@selector(tradeBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    [buttons addObject:barButtonItem];
    
    // Create a spacer.
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barButtonItem.width = 12.0f;
    [buttons addObject:barButtonItem];
    
    barButtonItem = [[UIBarButtonItem alloc]
                     initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshBTNClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    barButtonItem.tintColor = [UIColor colorWithRed:0.81 green:0.64 blue:0.14 alpha:0.5];
    [buttons addObject:barButtonItem];

    [tools setItems:buttons animated:NO];
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.leftBarButtonItem = twoButtons;
*/
    restServiceObject = [[BullFirstWebServiceObject alloc]initWithObject:self responseSelector:@selector(responseReceived:) receiveDataSelector:@selector(receivedData:) successSelector:@selector(requestSucceeded:) errorSelector:@selector(requestFailed:)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateDevice) name:@"DEVICE_ROTATE" object:nil];

}

- (void)viewDidUnload
{
    [self setOrderTBL:nil];
    [self setPortraitTitleBar:nil];
    [self setLandscrapeTitleBar:nil];
    [self setFilterBTN:nil];
    [self setTransferBTN:nil];
    [self setTradeBTN:nil];
    [self setRefreshBTN:nil];
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
        CGRect rect = filterBTN.frame;
        filterBTN.frame = CGRectMake(610, rect.origin.y, rect.size.width, rect.size.height);
        rect = transferBTN.frame;
        transferBTN.frame = CGRectMake(755, rect.origin.y, rect.size.width, rect.size.height);
        rect = tradeBTN.frame;
        tradeBTN.frame = CGRectMake(850, rect.origin.y, rect.size.width, rect.size.height);
        rect = refreshBTN.frame;
        refreshBTN.frame = CGRectMake(933, rect.origin.y, rect.size.width, rect.size.height);
    }
    else
    {
        CGRect rect = filterBTN.frame;
        filterBTN.frame = CGRectMake(360, rect.origin.y, rect.size.width, rect.size.height);
        rect = transferBTN.frame;
        transferBTN.frame = CGRectMake(505, rect.origin.y, rect.size.width, rect.size.height);
        rect = tradeBTN.frame;
        tradeBTN.frame = CGRectMake(600, rect.origin.y, rect.size.width, rect.size.height);
        rect = refreshBTN.frame;
        refreshBTN.frame = CGRectMake(683, rect.origin.y, rect.size.width, rect.size.height);
    }
    [orderTBL reloadData];
    
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
    TradeViewController *controller = [[TradeViewController alloc] initWithNibName:@"TradeViewController" bundle:nil];    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)transferBTNClicked:(id)sender {
    TransferViewController *controller = [[TransferViewController alloc] initWithNibName:@"TransferViewController" bundle:nil];    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)filterBTNClicked:(id)sender {
    FilterViewController *controller = [[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:controller animated:YES];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        return landscrapeTitleBar;
    } else {
        return portraitTitleBar;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [orders count];
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return cell;

}
*/

 // Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
 

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */




@end
