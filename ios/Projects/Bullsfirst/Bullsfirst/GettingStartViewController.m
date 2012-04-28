//
//  GettingStartViewController.m
//  Bullsfirst
//
//  Created by pong choa on 4/28/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "GettingStartViewController.h"

@interface GettingStartViewController ()

@end

@implementation GettingStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
	return YES;
}

@end
