//
//  PositionsSummaryViewController.h
//  Bullsfirst2
//
//  Created by Rashmi Garg on 12/13/12.
//  For storyboard and Bullsfirst2 design
//  Copyright (c) 2012 Rashmi Garg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabViewController.h"

@interface PositionsSummaryViewController : TabViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *totalMarketValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalCostLabel;

@property (strong, nonatomic) IBOutlet UILabel *totalGainLabel;
@property (strong, nonatomic) IBOutlet UILabel *securityNameLabel;

@property (strong, nonatomic) IBOutlet UITableView *accountsTable;
@property int selectedSecurity;
@property int selectedAccountInSecurity;
@end
