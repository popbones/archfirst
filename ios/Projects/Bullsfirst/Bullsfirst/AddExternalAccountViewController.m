//
//  AddExternalAccountViewController.m
//  Bullsfirst
//
//  Created by suravi on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddExternalAccountViewController.h"

@implementation AddExternalAccountViewController

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
#pragma mark - selectors for handling rest call callbacks

-(void)receivedData:(NSData *)data
{
    
}

-(void)responseReceived:(NSURLResponse *)data
{
    
}

-(void)requestFailed:(NSError *)error
{   
}

-(void)requestSucceeded:(NSData *)data
{
   // [spinner stopAnimating];
    [self dismissModalViewControllerAnimated:YES];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_ACCOUNT" object:nil];
    
}




#pragma mark - Methods
-(void) addAccountAction
{
    
}
- (IBAction)addAccountButtonClicked:(id)sender
{
    // Check for errors    
    [self addAccountAction];
    
}
- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

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
    // Return YES for supported orientations
	return YES;
}

@end
