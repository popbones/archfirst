//
//  InstrumentsDropdownViewController.h
//  Bullsfirst
//
//  Created by Pong Choa on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "DropdownViewController.h"
#import "BFInstrument.h"

@class InstrumentsDropdownViewController;

@protocol InstrumentsDropdownViewControllerDelegate
- (void)instrumentSelectionChanged:(InstrumentsDropdownViewController *)controller;
@end

@interface InstrumentsDropdownViewController : DropdownViewController

@property (retain, nonatomic) id <InstrumentsDropdownViewControllerDelegate> instrumentDelegate;
@property (strong, nonatomic) IBOutlet UITableViewCell *instrumentTableViewCell;
@property (retain, nonatomic) NSMutableArray *instruments;
@property (retain, nonatomic) BFInstrument *selectedInstrument;
@end
