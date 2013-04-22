//
//  PositionsDetailViewController.h
//  Bullsfirst
//
//  Created by Rashmi Garg
//  For storyboard and Bullsfirst2 design
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

@interface PositionsDetailViewController : TabViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil account:(int)account;
@property BOOL isComingFromAccountsScreen;
@property (strong, nonatomic) IBOutlet UILabel *securityLBL;

@property (strong, nonatomic) IBOutlet UILabel *accountLBL;

@property (strong, nonatomic) IBOutlet UILabel *quantityLBL;
@property (strong, nonatomic) IBOutlet UILabel *lastTradeLBL;
@property (strong, nonatomic) IBOutlet UILabel *pricePaidLBL;
@property (strong, nonatomic) IBOutlet UILabel *totalCostLBL;

@property (strong, nonatomic) IBOutlet UILabel *marketValueLBL;
@property (strong, nonatomic) IBOutlet UITableView *lotsTable;
@property int selectedSecurity;
@property int selectedAccountInSecurity;
@property int selectedAccount;
@property int selectedSecurityInAccount;


@end
