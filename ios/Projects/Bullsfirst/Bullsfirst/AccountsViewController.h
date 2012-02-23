//
//  AccountsViewController.h
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

#import "PieChartViewController.h"
#import "BFToolbar.h"
@class AccountsTableViewController;

@interface AccountsViewController: TabViewController
{   
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIView *headerView;
    
    IBOutlet UITableView *accountsTable;
    IBOutlet UIButton *backBTN;
    NSURLConnection *urlConnection;
    NSMutableData *jsonResponseData;
    PieChartViewController *pieChartViewController;
    IBOutlet CPTGraphHostingView *pieChartView;
    UIDeviceOrientation orientation;
    IBOutlet UIView *chartView;
    IBOutlet UIView *leftBorderView;
    IBOutlet UIView *rightBorderView;
}
@property (strong, nonatomic) IBOutlet UITableViewCell *accountCell;
@property (strong, nonatomic) IBOutlet UILabel *accountNameLBL;
@property (strong, nonatomic) IBOutlet UILabel *accountNumberLBL;
@property (strong, nonatomic) IBOutlet UILabel *marketValueLBL;
@property (strong, nonatomic) IBOutlet UILabel *cashLBL;
@property (strong, nonatomic) IBOutlet UILabel *actionLBL;

- (IBAction)createAccount:(id)sender;
- (IBAction)backBTNClicked:(id)sender;

@property (strong, nonatomic) UIPopoverController *userPopOver;

@end
@protocol AccountsViewSelectionDelegate <NSObject>
-(void) accountSelected:(int) withIndex; 


@end
