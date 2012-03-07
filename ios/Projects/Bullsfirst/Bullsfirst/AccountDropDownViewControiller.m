//
//  AccountDropDownViewControiller.m
//  Bullsfirst
//
//  Created by Pong Choa on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountDropDownViewControiller.h"
#import "BFBrokerageAccount.h"
#import "BFMoney.h"

@implementation AccountDropDownViewControiller
@synthesize accountDelegate;
@synthesize accountTableViewCell;
@synthesize allAccountsOption;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        allAccountsOption = NO;
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

-(void)allAccountsBTNClicked:(id) sender
{
    [accountDelegate allAccountsClicked:self];
    [self.popOver dismissPopoverAnimated:YES];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(allAccountsOption)
    {
        CGRect rect = self.view.frame;
        
        self.view.backgroundColor  = [UIColor darkTextColor];
        self.selectionsTBL.frame = CGRectMake(rect.origin.x,40, rect.size.width, rect.size.height-40);
        UIButton* clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [clearButton addTarget:self action:@selector(allAccountsBTNClicked:) forControlEvents:UIControlEventTouchUpInside];
        clearButton.frame = CGRectMake(180,6,110,30);
        [clearButton setTitle:@"All Accounts" forState:UIControlStateNormal];
        
        [self.view addSubview:clearButton];
    }
    
}


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
    
    
    
    UILabel *label;
    
    
    BFBrokerageAccount *account = [super.selections objectAtIndex:indexPath.row];
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%d", [account.brokerageAccountID intValue]];
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [NSString stringWithString: account.name];
    
    label = (UILabel *)[cell viewWithTag:3];
    label.text = [NSString stringWithFormat:@"$%d", [account.cashPosition.amount intValue]];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
         return self.selections.count;
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
