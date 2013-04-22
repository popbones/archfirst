//
//  AccountsChartViewController.h
//  Bullsfirst2
//
//  Created by Rashmi Garg on 1/29/13.
//  Copyright (c) 2013 Rashmi Garg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface AccountsChartViewController : UIViewController< CPTPlotSpaceDelegate,
CPTPlotDataSource,  CPTScatterPlotDelegate>
@property (strong, nonatomic) IBOutlet UIButton *tableViewButton;
- (IBAction)tableViewButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graphView;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSMutableArray *data2;
@property (nonatomic, retain) NSMutableArray *data3;
//@property (nonatomic, retain) CPTGraphHostingView *hostingView;
@property (nonatomic, retain) CPTXYGraph *graph;

- (void) generateScatterPlot;

@end
