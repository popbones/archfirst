//
//  TransferViewController.h
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
#import "BullFirstWebServiceObject.h"
#import "DropdownViewController.h"
#import "DropDownControl.h"
#import "InstrumentsDropdownViewController.h"
@interface TransferViewController : UIViewController <DropdownViewControllerDelegate,UITextFieldDelegate,InstrumentsDropdownViewControllerDelegate>   
{
    NSNumber *fromAccountID;
    NSNumber *toAccountID;
    IBOutlet UIActivityIndicatorView *spinner;
    bool orientationChanged;
    UITextField *activeTextField;
    Boolean isKeyBoardVisible;
}

@property (nonatomic,assign) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UIView *fromAccountDropDownView;
@property (nonatomic, retain) DropDownControl *fromAccountDropDownCTL;

@property (strong, nonatomic) IBOutlet UIView *toAccountDropDownView;
@property (nonatomic, retain) DropDownControl *toAccountDropDownCTL;
@property (strong, nonatomic) IBOutlet UIButton *transferBTN;
@property (strong, nonatomic) IBOutlet UITextField *amount;
@property (strong, nonatomic) IBOutlet UITextField *symbol;
@property (strong, nonatomic) IBOutlet UITextField *quantity;
@property (strong, nonatomic) IBOutlet UITextField *pricePaid;
@property (strong, nonatomic) IBOutlet UILabel *amountLBL;
@property (strong, nonatomic) IBOutlet UILabel *symbolLBL;
@property (strong, nonatomic) IBOutlet UILabel *quantityLBL;
@property (strong, nonatomic) IBOutlet UILabel *pricePaidLBL;
@property (strong, nonatomic) BullFirstWebServiceObject *restServiceObject;
@property (strong, nonatomic) UIPopoverController *instrumentDropdown;
- (IBAction)transferBTNClicked:(id)sender;
- (IBAction)segmentedControlValueChanged:(id)sender;
@property (strong, nonatomic) UIPopoverController *dropdown;
@end
