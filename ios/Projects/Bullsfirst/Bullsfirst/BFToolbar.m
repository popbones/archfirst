//
//  BFToolbar.m
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

#import "BFToolbar.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
@implementation BFToolbar

@synthesize lvc;
@synthesize tbc;
@synthesize userName;
/*
- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    
    //if(self)
    //{
    //}
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}
*/
- (IBAction)logout
{
    AppDelegate* appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.loginViewController logout];
    [appDelegate.loginViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve]; 
    [tbc presentModalViewController: appDelegate.loginViewController animated:YES];
    [tbc.accountsViewController clearViewData];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end
