//
//  AccountDropDownViewControiller.m
//  Bullsfirst
//
//  Created by Pong Choa on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountDropDownViewControiller.h"
#import "BFBrokerageAccount.h"

@implementation AccountDropDownViewControiller
@synthesize accountDelegate;
@synthesize accountTableViewCell;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setAccountTableViewCell:nil];
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
    [[NSBundle mainBundle] loadNibNamed:@"AccountDropDownTableCell" owner:self options:nil];
    cell = accountTableViewCell;

    BFBrokerageAccount *account = [super.selections objectAtIndex:indexPath.row];

    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%d", [account.brokerageAccountID intValue]];
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [NSString stringWithString: account.name];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex=indexPath.row;
    if (self.accountDelegate != nil)
        [self.accountDelegate accountSelectionChanged:self];
    [self.popOver dismissPopoverAnimated:YES];
}

@end
