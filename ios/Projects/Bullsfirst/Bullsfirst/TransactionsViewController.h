//
//  TransactionsViewController.h
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
#import "TabViewController.h"
#import "DatePickerViewController.h"
#import "AccountDropDownViewControiller.h"
#import "DropDownControl.h"

@interface TransactionsViewController : TabViewController<UITableViewDataSource,DatePickerViewControllerDelegate,AccountDropdownViewControllerDelegate>
{
    enum {FromDate, ToDate} currentSelectedDateType;

    int selectedAccountId;
    IBOutlet UITableViewCell *transactionCell;
    
    NSDate *fromDate;
    NSDate *toDate;

    NSMutableArray* transactions;
    
}


@property (strong, nonatomic) IBOutlet UIView *toDateDropDownView;
@property (nonatomic, retain) DropDownControl *toDateDropDownCTL;

@property (strong, nonatomic) IBOutlet UIView *fromDateDropDownView;
@property (nonatomic, retain) DropDownControl *fromDateDropDownCTL;

@property (strong, nonatomic) IBOutlet UIView *accountDropDownView;
@property (nonatomic, retain) DropDownControl *accountDropDownCTL;

@property (strong, nonatomic) IBOutlet UITableView *transectionTBL;
@property (strong, nonatomic) IBOutlet UIView *portraitTableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *landscrapeTableHeaderView;
@property (retain,nonatomic) NSMutableArray* transactions;
@property (strong, nonatomic) UIPopoverController *dropdown;
@property (strong, nonatomic) UIPopoverController *datedropdown;


-(IBAction)resetBTNClicked:(id)sender;
-(IBAction)applyBTNClicked:(id)sender;

@end
