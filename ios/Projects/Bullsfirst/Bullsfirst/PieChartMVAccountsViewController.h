//
//  PieChartMVAccountsViewController.h
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

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface PieChartMVAccountsViewController : UIViewController <CPTPieChartDataSource>
{
    CPTGraphHostingView *pieChartView;
	CPTXYGraph *pieGraph;
	CPTPieChart *piePlot;
	BOOL piePlotIsRotating;
    BOOL viewOnFront;
    
	NSMutableArray *dataForChart, *dataForPlot;
    
}

@property (nonatomic, retain) CPTGraphHostingView *pieChartView;
@property (nonatomic, retain) NSMutableArray *dataForChart, *dataForPlot;

// Plot construction methods
-(void)constructPieChart;


@end
