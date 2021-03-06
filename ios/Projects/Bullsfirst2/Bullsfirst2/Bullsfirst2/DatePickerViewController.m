//
//  DatePickerViewController.m
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

#import "DatePickerViewController.h"

@implementation DatePickerViewController
@synthesize popOver;
@synthesize delegate;
@synthesize datePicker;
@synthesize tag;

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

- (IBAction)pickerValueChanged:(id)sender {
//    if (delegate != nil)
//        [delegate dateSelectionChanged:self];
}

- (IBAction)doneBTNClicked:(id)sender 
{   
    if (delegate != nil && [[self delegate] respondsToSelector:@selector(dateSelectionChanged:)])
        [delegate dateSelectionChanged:self];
    [popOver dismissPopoverAnimated:YES];
}

- (IBAction)clearBTNClicked:(id) sender
{
    if (delegate != nil && [[self delegate] respondsToSelector:@selector(datePickerCleared:)])
        [delegate datePickerCleared:self];
    [popOver dismissPopoverAnimated:YES];
}

@end
