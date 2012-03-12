//
//  TradeViewController.h
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

#import <UIKit/UIKit.h>
#import "BFPosition.h"
#import "BFOrder.h"
#import "AccountDropDownViewControiller.h"
#import "DropdownViewController.h"
#import "DropDownControl.h"
#import "BullFirstWebServiceObject.h"
#import "InstrumentsDropdownViewController.h"

@interface TradeViewController : UIViewController <DropdownViewControllerDelegate, AccountDropdownViewControllerDelegate, InstrumentsDropdownViewControllerDelegate> {
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
@property (strong, nonatomic) UIPopoverController *instrumentDropdown;

@property (strong, nonatomic) BullFirstWebServiceObject* restServiceObject;

@end
