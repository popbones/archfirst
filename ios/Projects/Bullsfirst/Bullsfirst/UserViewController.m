//
//  UserViewController.m
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

#import "UserViewController.h"
#import "AppDelegate.h"

@implementation UserViewController
@synthesize versionLabel;
@synthesize usernameLabel;
@synthesize popOver;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.versionLabel.text = [NSString stringWithFormat:@"Bullsfirst Version %@"
                              , [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    self.view.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];
}

- (void)viewDidUnload
{
    [self setVersionLabel:nil];
    [self setUsernameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.usernameLabel.text = [NSString stringWithFormat:@"User:  %@ %@", appDelegate.currentUser.firstName, appDelegate.currentUser.lastName];
}

- (IBAction)logoutBTNClicked:(id)sender {
    [self.popOver dismissPopoverAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGOUT" object:nil];
}

- (IBAction)gettingStartedBTNClicked:(id)sender {
    [self.popOver dismissPopoverAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETTING_START" object:nil];
}

- (IBAction)launchArchFirstWebsite:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://archfirst.org/"]];

}
@end
