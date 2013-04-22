//
//  AccountsViewController.h
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
#import "CorePlot-CocoaTouch.h"
#import "PieChartViewController.h"
@class AccountsTableViewController;

@interface AccountsViewController: TabViewController<UITableViewDataSource, UITableViewDelegate, CPTPlotSpaceDelegate, CPTPlotDataSource,  CPTScatterPlotDelegate>
{   
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIView *headerView;
    IBOutlet UIView *layoutView;
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
    int selectedRow;
    int highlightedLabelIndex;
    IBOutlet UIView *chartTitleView;
    //Added for iPhone changes
    BOOL loginSuccess;
}
@property (strong, nonatomic) IBOutlet UIButton *addAccountButton;
@property (strong, nonatomic) IBOutlet UIButton *graphViewButton;
- (IBAction)graphViewButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIToolbar *accountToolbar;
@property (strong, nonatomic) IBOutlet UITableViewCell *accountCell;
@property (strong, nonatomic) IBOutlet UILabel *chartTitle;
@property (strong, nonatomic) IBOutlet UILabel *accountNameLBL;
@property (strong, nonatomic) IBOutlet UILabel *accountNumberLBL;
@property (strong, nonatomic) IBOutlet UILabel *marketValueLBL;
@property (strong, nonatomic) IBOutlet UILabel *cashLBL;
@property (strong, nonatomic) IBOutlet UILabel *actionLBL;
@property (strong, nonatomic) IBOutlet UIView *layoutView;
- (IBAction)createAccount:(id)sender;
- (IBAction)backBTNClicked:(id)sender;


@property (strong, nonatomic) UIPopoverController *userPopOver;

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graphView;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSMutableArray *data2;
@property (nonatomic, retain) NSMutableArray *data3;
//@property (nonatomic, retain) CPTGraphHostingView *hostingView;
@property (nonatomic, retain) CPTXYGraph *graph;

- (void) generateScatterPlot;
@property (strong, nonatomic) IBOutlet UISlider *chartSlider;
- (IBAction)chartSliderAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *totalCostLabel;

@property (strong, nonatomic) IBOutlet UILabel *totalMarketValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalGainLabel;

@end
@protocol AccountsViewSelectionDelegate <NSObject>
-(void) accountSelected:(int) withIndex; 
@end
