//
//  PositionsViewController.h
//  Bullsfirst
//
//  Created by Joe Howard
//  Edited by Rashmi Garg - changes for storyboard and Bullsfirst2 design
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

@interface PositionsViewController : TabViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil account:(int)account;

@property (strong, nonatomic) IBOutlet UIView *portraitTitleBar;
@property (strong, nonatomic) IBOutlet UIView *landscrapeTitleBar;
@property (strong, nonatomic) IBOutlet UIButton *editButton;

@property (strong, nonatomic) IBOutlet UITableViewCell *positionCell;
@property (strong, nonatomic) IBOutlet UITableView *positionTBL;

@property int selectedAccount;
@property int selectedSubAccount;
@property int selectedSecurity;
@property (strong, nonatomic) IBOutlet UILabel *totalMarketValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalCostLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalGainLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountNameLabel;

@property (retain, nonatomic) NSMutableArray *expanedRowSet;

- (IBAction)editButtonClicked:(id)sender;

@end
