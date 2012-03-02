//
//  InstrumentsDropdownViewController.m
//  Bullsfirst
//
//  Created by Pong Choa on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstrumentsDropdownViewController.h"
#import "BFInstrument.h"

@implementation InstrumentsDropdownViewController
@synthesize instrumentDelegate;
@synthesize instrumentTableViewCell;
@synthesize instruments;
@synthesize selectedInstrument;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    instruments = [NSMutableArray arrayWithArray:[BFInstrument getAllInstruments]];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    [[NSBundle mainBundle] loadNibNamed:@"InstrumentDropDownTableCell" owner:self options:nil];
    cell = instrumentTableViewCell;
    
    UILabel *label;
    
    BFInstrument *instrument = [instruments objectAtIndex:indexPath.row];
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [NSString stringWithString: instrument.symbol];
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [NSString stringWithString: instrument.name];

    label = (UILabel *)[cell viewWithTag:3];
    label.text = [NSString stringWithString: instrument.exchange];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [instruments count];
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedInstrument=[instruments objectAtIndex:indexPath.row];
    if (self.instrumentDelegate != nil)
        [self.instrumentDelegate instrumentSelectionChanged:self];
    [self.popOver dismissPopoverAnimated:YES];
}

-(void)filterInstrumentsWithString:(NSString *)string
{
    NSArray *allInstruments = [BFInstrument getAllInstruments];
    [instruments removeAllObjects];
    for(BFInstrument *instrument in allInstruments)
	{
        
		NSComparisonResult result = [instrument.symbol compare:string options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [string length])];
		if (result == NSOrderedSame)
		{
			[self.instruments addObject:instrument];
		}
		else
		{
			result = [instrument.name compare:string options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [string length])];
			if (result == NSOrderedSame)
			{
				[self.instruments addObject:instrument];
			}
		}
    }

    [super.selectionsTBL reloadData];
}
@end
