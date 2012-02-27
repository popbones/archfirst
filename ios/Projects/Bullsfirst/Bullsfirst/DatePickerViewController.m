//
//  DatePickerViewController.m
//  Bullsfirst
//
//  Created by Pong Choa on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"

@implementation DatePickerViewController
@synthesize popOver;
@synthesize delegate;
@synthesize dateInRequiredFormat;

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
}

- (IBAction)doneBTNClicked:(id)sender 
{
    NSDate* date = datePicker.date;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* dateComponents = [gregorianCalendar components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date];
    int day = [dateComponents day];
    int month = [dateComponents month];
    int year = [dateComponents year];
    dateInRequiredFormat = [NSString stringWithFormat:@"%d-%d-%d",year,month,day];
    BFDebugLog(@"DATE %@ DATE",dateInRequiredFormat);
    
    [delegate selectionChanged:self];
    
    [popOver dismissPopoverAnimated:YES];
}
@end
