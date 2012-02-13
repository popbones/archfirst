//
//  PositionsViewController.m
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

#import "PositionsViewController.h"
#import "AppDelegate.h"
#import "BFBrokerageAccountStore.h"
#import "BFBrokerageAccount.h"

@implementation PositionsViewController
@synthesize positionTBL;
@synthesize accountName;
@synthesize transferBTN;
@synthesize tradeBTN;
@synthesize refreshBTN;
@synthesize switchAcountBTN;
@synthesize positionCell;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Positions"];
        UIImage *i = [UIImage imageNamed:@"iconPositions.png"];
        [tbi setImage:i];        
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Bullsfirst";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate addObserver:self forKeyPath:@"currentUser" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    if (appDelegate.currentUser != nil) {
        NSString* fullName=[appDelegate.currentUser.firstName stringByAppendingString:@" "];
        fullName=[fullName stringByAppendingString:appDelegate.currentUser.lastName];
        fullName=[fullName uppercaseString];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:fullName style:UIBarButtonItemStylePlain target:self action:@selector(userProfile)];
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
}

- (void)viewDidUnload
{
    [self setPositionTBL:nil];
    [self setAccountName:nil];
    [self setTransferBTN:nil];
    [self setTradeBTN:nil];
    [self setRefreshBTN:nil];
    [self setSwitchAcountBTN:nil];
    [super viewDidUnload];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate removeObserver:self forKeyPath:@"currentUser"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice].systemVersion intValue] >= 5) {
        [self willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:0.1];
    }
    
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        CGRect rect = switchAcountBTN.frame;
        switchAcountBTN.frame = CGRectMake(610, rect.origin.y, rect.size.width, rect.size.height);
        rect = transferBTN.frame;
        transferBTN.frame = CGRectMake(755, rect.origin.y, rect.size.width, rect.size.height);
        rect = tradeBTN.frame;
        tradeBTN.frame = CGRectMake(850, rect.origin.y, rect.size.width, rect.size.height);
        rect = refreshBTN.frame;
        refreshBTN.frame = CGRectMake(933, rect.origin.y, rect.size.width, rect.size.height);
    }
    else
    {
        CGRect rect = switchAcountBTN.frame;
        switchAcountBTN.frame = CGRectMake(360, rect.origin.y, rect.size.width, rect.size.height);
        rect = transferBTN.frame;
        transferBTN.frame = CGRectMake(505, rect.origin.y, rect.size.width, rect.size.height);
        rect = tradeBTN.frame;
        tradeBTN.frame = CGRectMake(600, rect.origin.y, rect.size.width, rect.size.height);
        rect = refreshBTN.frame;
        refreshBTN.frame = CGRectMake(683, rect.origin.y, rect.size.width, rect.size.height);
    }
    
    
}

- (IBAction)logout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGOUT" object:nil];
}

#pragma mark - KVO lifecycle

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentUser"]) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSString* fullName=[appDelegate.currentUser.firstName stringByAppendingString:@" "];
        fullName=[fullName stringByAppendingString:appDelegate.currentUser.lastName];
        fullName=[fullName uppercaseString];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:fullName style:UIBarButtonItemStylePlain target:self action:@selector(userProfile)];
        self.navigationItem.leftBarButtonItem = barButtonItem;
        
        return;
    }
}


- (IBAction)switchAccountBTNClicked:(id)sender {
}

- (IBAction)refreshBTNClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
}

- (IBAction)tradeBTNClicked:(id)sender {
}

- (IBAction)transferBTNClicked:(id)sender {
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    [[NSBundle mainBundle] loadNibNamed:@"PositionTableViewCell" owner:self options:nil];
    cell = positionCell;

    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:[indexPath row]];
    label.text = account.name;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
