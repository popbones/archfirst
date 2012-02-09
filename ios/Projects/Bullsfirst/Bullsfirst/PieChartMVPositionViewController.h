//
//  PieChartMVPositionViewController.h
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
#import "BF-CorePlot-CocoaTouch.h"
@protocol PieChartMVPositionViewControllerDelegate;

@interface PieChartMVPositionViewController : UIViewController <CPTPieChartDataSource,CPTPieChartDelegate>
{
    CPTGraphHostingView *pieChartView;
	CPTXYGraph *pieGraph;
	CPTPieChart *piePlot;
	BOOL piePlotIsRotating;
    __weak id<PieChartMVPositionViewControllerDelegate> delegate;
	NSMutableArray *dataForChart, *dataForPlot;
    BOOL viewOnFront;
    int accountIndex;
}
@property(nonatomic,weak) id <PieChartMVPositionViewControllerDelegate> delegate;
@property (nonatomic, retain) CPTGraphHostingView *pieChartView;
@property (nonatomic, retain) NSMutableArray *dataForChart, *dataForPlot;
@property(atomic) int accountIndex;
// Plot construction methods
-(void)constructPieChart;


@end
@protocol PieChartMVPositionViewControllerDelegate <NSObject>

-(void) pieChartMVPositionClicked;

@end