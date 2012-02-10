//
//  TransactionsViewController.m
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

#import "TransactionsViewController.h"
#import "AppDelegate.h"

@implementation TransactionsViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Transactions"];
        UIImage *i = [UIImage imageNamed:@"iconTransactions.png"];
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
    [super viewDidUnload];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate removeObserver:self forKeyPath:@"currentUser"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
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

@end
