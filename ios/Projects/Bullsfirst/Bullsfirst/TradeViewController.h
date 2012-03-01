//
//  TradeViewController.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFPosition.h"
#import "BFOrder.h"
#import "AccountDropDownViewControiller.h"
#import "DropdownViewController.h"
#import "DropDownControl.h"

@interface TradeViewController : UIViewController <DropdownViewControllerDelegate, AccountDropdownViewControllerDelegate> {
    BFPosition *position;
    BFOrder *order;
}

@property (nonatomic, retain) UITextField *activeTextField;
@property (nonatomic, retain) NSArray *textFields;
@property (nonatomic, retain) BFPosition *position;
@property (nonatomic, retain) BFOrder *order;
@property (strong, nonatomic) IBOutlet UITextField *cusipText;
@property (strong, nonatomic) IBOutlet UITextField *quantity;
@property (strong, nonatomic) IBOutlet UITextField *limit;
@property (strong, nonatomic) IBOutlet UIButton *allOrNone;
@property (strong, nonatomic) IBOutlet UILabel *allOrNoneLabel;

@property (strong, nonatomic) IBOutlet UIView *actionDropDownView;
@property (nonatomic, retain) DropDownControl *actionDropDownCTL;
@property (strong, nonatomic) IBOutlet UIView *accountDropDownView;
@property (nonatomic, retain) DropDownControl *accountDropDownCTL;
@property (strong, nonatomic) IBOutlet UIView *priceDropDownView;
@property (nonatomic, retain) DropDownControl *priceDropDownCTL;
@property (strong, nonatomic) IBOutlet UIView *goodForDayDropDownView;
@property (nonatomic, retain) DropDownControl *goodForDayDropDownCTL;

- (IBAction)cancelBTNClicked:(id)sender;
- (IBAction)okBTNClicked:(id)sender;
- (IBAction)showDropdown:(id)sender;
- (IBAction)allOrNoneClicked:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil position:(BFPosition *)aPosition;

@property (strong, nonatomic) UIPopoverController *dropdown;
@property (strong, nonatomic) UIPopoverController *accountDropdown;

@end
