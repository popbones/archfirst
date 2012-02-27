//
//  OrdersViewController.h
//  Bullsfirst
//
//  Created by Joe Howard
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

#import <Foundation/Foundation.h>
#import "BullFirstWebServiceObject.h"
#import "TabViewController.h"
#import "DatePickerViewController.h"

@interface OrdersViewController : TabViewController<DatePickerViewControllerDelegate> {
    NSMutableArray *orders;
}

@property (strong, nonatomic) IBOutlet UIView *portraitTitleBar;
@property (strong, nonatomic) IBOutlet UIView *landscrapeTitleBar;

@property (strong, nonatomic) IBOutlet UITableView *orderTBL;
@property (strong, nonatomic) IBOutlet UITableViewCell *orderTableViewCell;
@property (strong, nonatomic) IBOutlet UIView *orderFilterView;

- (IBAction)filterBTNClicked:(id)sender;

@property (strong, nonatomic) NSMutableArray *orders;

- (IBAction)accountBTNClicked:(id)sender;
- (IBAction)orderBTNClicked:(id)sender;
- (IBAction)orderStatusBTNClicked:(id)sender;
- (IBAction)dateDropdownClicked:(id)sender;
- (IBAction)resetBTNClicked:(id)sender;
- (IBAction)applyBTNClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *allAccountBTN;
@property (strong, nonatomic) IBOutlet UIButton *orderBTN;
@property (strong, nonatomic) IBOutlet UIButton *orderStatusBTN;
@property (strong, nonatomic) IBOutlet UILabel *fromDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *toDateLabel;
@property (strong, nonatomic) IBOutlet UIButton *resetBTN;
@property (strong, nonatomic) IBOutlet UIButton *applyBTN;

@property (strong, nonatomic) UIPopoverController *datedropdown;

@end
