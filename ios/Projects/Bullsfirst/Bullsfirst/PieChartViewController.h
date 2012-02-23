//
//  PieChartViewController.h
//  Bullsfirst
//
//  Created by Praveen on 23/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BF-CorePlot-CocoaTouch.h"


typedef enum{AccountsChart, PositionsChart} Chart;
@interface PieChartViewController : UIViewController <CPTPieChartDataSource,CPTPieChartDelegate>
{
    Chart currentChart;
    CPTGraphHostingView *pieChartView;
	CPTXYGraph *pieGraph;
	CPTPieChart *piePlot;
	BOOL piePlotIsRotating;
    NSMutableArray *contentArray;
    BOOL viewOnFront;
	NSMutableArray *dataForChart, *dataForPlot;
    int selectedAccount;
    NSArray *sortedPositions;
}

@property (nonatomic, retain) CPTGraphHostingView *pieChartView;
@property (nonatomic, retain) NSMutableArray *dataForChart, *dataForPlot;
@property Chart currentChart;

// Plot construction methods
-(void)constructPieChart;
-(void)clearPieChart;
-(void)backBTNClicked;

@end

