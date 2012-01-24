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
#import "CorePlot-CocoaTouch.h"

@class BFToolbar;
@class AccountsTableViewController;

@class PieChartMVAccountsViewController;
@class PieChartMVPositionViewController;

@interface AccountsViewController : UIViewController
{   
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIView *headerView;
    
    IBOutlet UITableView *accountsTable;
    AccountsTableViewController *accountsTableViewController;    
       
    NSURLConnection *urlConnection;
    NSMutableData *jsonResponseData;
    
    PieChartMVAccountsViewController *pieChartMVAccountsViewController;
    IBOutlet CPTGraphHostingView *pieChartMVAccountsView;

    PieChartMVPositionViewController *pieChartMVPositionViewController;
    IBOutlet CPTGraphHostingView *pieChartMVPositionView;
    
    IBOutlet UILabel *accountsPlotLabel;
    IBOutlet UILabel *positionPlotLabel;

}

@property (nonatomic, retain) BFToolbar *toolbar;

- (void)retrieveAccountData;
- (IBAction)createAccount:(id)sender;
- (IBAction)refreshAccounts:(id)sender;

@end
