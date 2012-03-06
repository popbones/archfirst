//
//  PieChartViewController.h
//  Bullsfirst
//
//  Created by Vivekan Arther
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
#import <UIKit/UIKit.h>

#import "BF-CorePlot-CocoaTouch.h"


typedef enum{AccountsChart, PositionsChart} Chart;
typedef enum{FadeIn,FadeOut} Animation;
@interface PieChartViewController : UIViewController <CPTPieChartDataSource,CPTPieChartDelegate>
{
    Chart currentChart;
    Animation currentAnimation;
    CPTGraphHostingView *pieChartView;
	CPTXYGraph *pieGraph;
	CPTPieChart *piePlot;
	BOOL piePlotIsRotating;
    NSMutableArray *contentArray;
    BOOL viewOnFront;
	NSMutableArray *dataForChart, *dataForPlot;
    int selectedAccount;
    NSArray *sortedPositions;
    bool loggedIn;
    NSString* chartTitle;
    UIPinchGestureRecognizer* pinchGesture;
}

@property (nonatomic, retain) CPTGraphHostingView *pieChartView;
@property (nonatomic, retain) NSMutableArray *dataForChart, *dataForPlot;
@property Chart currentChart;
@property (nonatomic, retain) NSString* chartTitle;

// Plot construction methods
-(void)constructPieChart;
-(void)clearPieChart;
-(void)backBTNClicked;

@end

