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
@property (strong, nonatomic) IBOutlet UIButton *accountBTN;
@property (strong, nonatomic) IBOutlet UIButton *orderBTN;
@property (strong, nonatomic) IBOutlet UIButton *priceBTN;
@property (strong, nonatomic) IBOutlet UIButton *goodForDayBTN;
@property (strong, nonatomic) IBOutlet UIButton *allOrNone;
@property (strong, nonatomic) IBOutlet UILabel *allOrNoneLabel;

- (IBAction)cancelBTNClicked:(id)sender;
- (IBAction)okBTNClicked:(id)sender;
- (IBAction)showDropdown:(id)sender;
- (IBAction)allOrNoneClicked:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil position:(BFPosition *)aPosition;

@property (strong, nonatomic) UIPopoverController *dropdown;
@property (strong, nonatomic) UIPopoverController *accountDropdown;

@property (strong, nonatomic) IBOutlet UILabel *accountLabel;
@end
