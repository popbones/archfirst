//
//  PositionsViewController.h
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
#import "AccountsViewController.h"
@interface PositionsViewController : UIViewController<AccountsViewSelectionDelegate>
@property (strong, nonatomic) IBOutlet UIView *portraitTitleBar;
@property (strong, nonatomic) IBOutlet UIView *landscrapeTitleBar;

@property (strong, nonatomic) IBOutlet UITableViewCell *positionCell;
@property (strong, nonatomic) IBOutlet UITableView *positionTBL;
@property (strong, nonatomic) IBOutlet UILabel *accountName;
@property (strong, nonatomic) IBOutlet UIButton *transferBTN;
@property (strong, nonatomic) IBOutlet UIButton *tradeBTN;
@property (strong, nonatomic) IBOutlet UIButton *refreshBTN;
@property (strong, nonatomic) IBOutlet UIButton *switchAcountBTN;
@property (assign, nonatomic) int selectedAccount;
@property (assign, nonatomic) int expandRow;

- (IBAction)switchAccountBTNClicked:(id)sender;
- (IBAction)refreshBTNClicked:(id)sender;
- (IBAction)tradeBTNClicked:(id)sender;
- (IBAction)transferBTNClicked:(id)sender;


@end
