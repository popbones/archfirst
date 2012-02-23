//
//  UserViewController.m
//  Bullsfirst
//
//  Created by Pong Choa on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
    self.versionLabel.text = [NSString stringWithFormat:@"Bullsfirst Verion %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
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
    self.usernameLabel.text = [[NSString stringWithFormat:@"%@ %@", appDelegate.currentUser.firstName, appDelegate.currentUser.lastName] uppercaseString];
}

- (IBAction)logoutBTNClicked:(id)sender {
    [self.popOver dismissPopoverAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_LOGOUT" object:nil];
}
@end
