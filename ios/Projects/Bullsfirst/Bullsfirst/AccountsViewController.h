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
#import "PieChartMVAccountsViewController.h"
#import "PieChartMVPositionViewController.h"
#import "BFToolbar.h"
@class AccountsTableViewController;

@class PieChartMVAccountsViewController;
@class PieChartMVPositionViewController;


@protocol AccountsViewSelectionDelegate;
@interface AccountsViewController: UIViewController<PieChartMVAccountsViewControllerDelegate,PieChartMVPositionViewControllerDelegate> 
{   
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIView *headerView;
    
    IBOutlet UITableView *accountsTable;
    IBOutlet UIButton *backBTN;
    NSURLConnection *urlConnection;
    NSMutableData *jsonResponseData;
    NSMutableArray *brokerageAccounts;
    PieChartMVAccountsViewController *pieChartMVAccountsViewController;
    IBOutlet CPTGraphHostingView *pieChartMVAccountsView;

    PieChartMVPositionViewController *pieChartMVPositionViewController;
    IBOutlet CPTGraphHostingView *pieChartMVPositionView;
    BFToolbar *toolbar,*toolbarPortraitView;
    UIDeviceOrientation orientation;
    IBOutlet UIView *positionsChartView;
    __weak id<AccountsViewSelectionDelegate> accountsViewSelectionDelegatedelegate;
}
@property(nonatomic,weak) id <AccountsViewSelectionDelegate> accountsViewSelectionDelegatedelegate;
@property (strong, nonatomic) IBOutlet UITableViewCell *accountCell;
@property (nonatomic, retain) BFToolbar *toolbar;
@property (nonatomic, retain) BFToolbar *toolbarPortraitView;
@property (nonatomic, retain)  PieChartMVAccountsViewController *pieChartMVAccountsViewController;
@property (strong, nonatomic) IBOutlet UILabel *accountNameLBL;
@property (strong, nonatomic) IBOutlet UILabel *accountNumberLBL;
@property (strong, nonatomic) IBOutlet UILabel *marketValueLBL;
@property (strong, nonatomic) IBOutlet UILabel *cashLBL;
@property (strong, nonatomic) IBOutlet UILabel *actionLBL;
-(void) clearViewController;
- (IBAction)createAccount:(id)sender;
- (IBAction)refreshAccounts:(id)sender;
- (IBAction)backBTNClicked:(id)sender;
@end
@protocol AccountsViewSelectionDelegate <NSObject>
-(void) accountSelected:(int) withIndex; 
@end
