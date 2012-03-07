//
//  PieChartViewController.m
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

#import "PieChartViewController.h"
#import "BFBrokerageAccount.h"
#import "BFBrokerageAccountStore.h"
#import "BFMoney.h"
#import "BFPosition.h"
#import "BFConstants.h"

#define animationTime 0.5f

@implementation PieChartViewController

@synthesize pieChartView;
@synthesize dataForChart, dataForPlot;
@synthesize chartTitle;
@synthesize chartTitleLabel;

#pragma mark -

#pragma mark - getters and setters

-(void) setCurrentChart:(Chart)tempCurrentChart
{
    [self willChangeValueForKey:@"currentChart"];
    currentChart = tempCurrentChart;
    [self didChangeValueForKey:@"currentChart"];
}

-(Chart) currentChart
{
    return currentChart;
}


#pragma mark Helper methods



-(void) performFadeInAnimation
{
    currentAnimation = FadeIn;
    piePlotIsRotating = YES;
        CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    	fadeInAnimation.removedOnCompletion = YES;
    	fadeInAnimation.fromValue			 = [NSNumber numberWithFloat:0.0];
    	fadeInAnimation.toValue			 = [NSNumber numberWithFloat:1];
    	fadeInAnimation.duration			 = animationTime;
    	fadeInAnimation.timingFunction		 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    	pieGraph.shouldRasterize=YES;
        
        fadeInAnimation.delegate = self;
        
    
    	[pieGraph addAnimation:fadeInAnimation forKey:@"FadeIn"];
    
}

-(void) performFadeOutAnimation
{
        currentAnimation = FadeOut;
        CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    	fadeOutAnimation.removedOnCompletion = YES;
    	fadeOutAnimation.fromValue			 = [NSNumber numberWithFloat:1.0];
    	fadeOutAnimation.toValue			 = [NSNumber numberWithFloat:0];
    	fadeOutAnimation.duration			 = animationTime;
    	fadeOutAnimation.timingFunction		 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    	pieGraph.shouldRasterize=YES;
        
        fadeOutAnimation.delegate = self;
    	[pieGraph addAnimation:fadeOutAnimation forKey:@"FadeIn"];
    
	piePlotIsRotating = YES;
    
    //Chart Title Animation
    
    [UIView animateWithDuration:animationTime delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        chartTitleLabel.alpha = 0.0;
    }completion:^(BOOL finished){
        if(finished)
        {
            chartTitleLabel.alpha = 0.0;
            [UIView animateWithDuration:animationTime delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                chartTitleLabel.alpha = 1.0;
            }completion:^(BOOL finished){
                if(finished)
                {
                    theLegend.opacity = 1.0;
                }
            }];
        }
    }];
    
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if(flag)
    {
        
        if(currentAnimation == FadeOut)
        {
            
            //[self clearPieChart];
            pieGraph.opacity = 0.0;
            [self constructPieChart];
        }
        else if(currentAnimation == FadeIn)
        {
            piePlotIsRotating = NO;
            pieGraph.opacity = 1.0;
        }
    }
}



-(CPTColor*) middleColorForStartColor:(int)startHex endColor:(int)endHex
{
    
    float red1=((float)((startHex & 0xFF0000) >> 16))/255.0;
    float green1=((float)((startHex & 0xFF00) >> 8))/255.0;
    float blue1=((float)(startHex & 0xFF))/255.0;
    
    float red2=((float)((endHex & 0xFF0000) >> 16))/255.0;
    float green2=((float)((endHex & 0xFF00) >> 8))/255.0;
    float blue2=((float)(endHex & 0xFF))/255.0;
    CPTColor* color = [[CPTColor alloc] initWithComponentRed:(red2+red1)/2 green:(green2+green1)/2 blue:(blue2+blue1)/2 alpha:1.0];
    return color;
}

-(CPTGradient *)CPTGradientWithStartColor:(int)startHex endColor:(int) endHex
{
	CPTGradient *newInstance = [CPTGradient gradientWithBeginningColor:CPTColorFromRGB(startHex) endingColor:CPTColorFromRGB(endHex)];
    [newInstance addColorStop:[self middleColorForStartColor:startHex endColor:endHex] atPosition:0.2];
    
    newInstance.gradientType = CPTGradientTypeAxial;
    newInstance.angle = 315;
    return newInstance;
}


#pragma mark Initialization and teardown

-(void)viewDidLoad
{
	[super viewDidLoad]; 
    self.currentChart = AccountsChart;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:@"USER_LOGOUT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin:) name:@"USER_LOGIN" object:nil];
    loggedIn = NO;
}



-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark -
#pragma mark Plot construction methods

-(void)constructPieChart
{
    //Initialize contentArray
    
    if(loggedIn)
    {
        
        contentArray = [[NSMutableArray alloc] init];
        // Create pieChart from theme
        pieGraph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
        CPTTheme *theme = [CPTTheme themeNamed:kBFPlainWhiteTheme];
        [pieGraph applyTheme:theme];
        pieChartView.hostedGraph			 = pieGraph;
        pieGraph.plotAreaFrame.masksToBorder = NO;
        
        pieGraph.paddingLeft   = 20.0;
        pieGraph.paddingTop	   = 20.0;
        pieGraph.paddingRight  = 20.0;
        pieGraph.paddingBottom = 300.0;
        
        if(!pinchGesture)
        {
            pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
        }
        [pieChartView addGestureRecognizer:pinchGesture];
        
        pieGraph.plotAreaFrame.borderWidth = 0.0f;
        pieGraph.axisSet = nil;
        
        // Prepare a radial overlay gradient for shading/gloss
        CPTGradient *overlayGradient = [[CPTGradient alloc] init];
        overlayGradient.gradientType = CPTGradientTypeAxial;
        overlayGradient				 = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.0];
        overlayGradient				 = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.3] atPosition:0.9];
        overlayGradient				 = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.7] atPosition:1.0];
        overlayGradient.angle = 315;
        // Add pie chart
        piePlot					= [[CPTPieChart alloc] init];
        piePlot.delegate=self;
        piePlot.dataSource		= self;
        piePlot.pieRadius		= 130.0;
        piePlot.identifier		= @"Pie Chart 1";
        piePlot.startAngle		= M_PI/2;
        piePlot.sliceDirection	= CPTPieDirectionClockwise;
        piePlot.overlayFill		= [CPTFill fillWithGradient:overlayGradient];
        [pieGraph addPlot:piePlot];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        double total = 0.0;
        
        if(currentChart == AccountsChart)
        {
            NSArray* sortedBrokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccountsInSortedOrder];
            pieGraph.title = nil;
            self.chartTitle = kAllAccounts;
            for(BFBrokerageAccount *account in sortedBrokerageAccounts)
            {
                [tempArray addObject:[[account marketValue] amount]];
                total += [[[account marketValue] amount] doubleValue];
            }
        }
        else
        {
            BFBrokerageAccount *neededAccount=[[[BFBrokerageAccountStore defaultStore]allBrokerageAccountsInSortedOrder] objectAtIndex:selectedAccount];
            
            self.chartTitle = neededAccount.name;
            
            NSArray *sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"marketValue" ascending:NO]];
            
            sortedPositions = [[neededAccount positions] sortedArrayUsingDescriptors:sortDescriptors];
            
            for (BFPosition *position in sortedPositions){
                [tempArray addObject:[[position marketValue] amount]];
                total += [[[position marketValue] amount] doubleValue];
                
            }
        }
        
        int count = 0;
        NSNumber* others;
        double otherValues=0;
        for(NSNumber *amount in tempArray)
        {
            if(count < 9)
            {
                
                [contentArray addObject:[NSNumber numberWithDouble:(100.0*[amount doubleValue]/total)]];
            }
            else
            {
                otherValues =  otherValues + (100.0*[amount doubleValue]/total);
            }
            count++;
        }
        if(count>=9)
        {
            others = [NSNumber numberWithDouble:otherValues];
            [contentArray addObject:others];
        }
        
        self.dataForChart = contentArray;
        
        // Add legend
        if(contentArray.count!=0)
        {
            theLegend = [CPTLegend legendWithGraph:pieGraph];
            theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
            NSNumber *rowHeight = [NSNumber numberWithInt:36];
            theLegend.rowHeights = [NSArray arrayWithObjects:rowHeight,rowHeight,rowHeight,rowHeight,rowHeight,nil];
            NSNumber *columnWidth = [NSNumber numberWithInt:140];
            theLegend.columnWidths = [NSArray arrayWithObjects:columnWidth,columnWidth,nil];
            theLegend.swatchSize = CGSizeMake(25, 25);
            CPTMutableTextStyle *swatchTextStyle = [[CPTMutableTextStyle alloc] init];
            swatchTextStyle.fontName=@"Helvetica";
            swatchTextStyle.fontSize = 15;
            theLegend.textStyle = swatchTextStyle;
            theLegend.cornerRadius = 5.0;
            CPTMutableLineStyle* lineStyle = [CPTMutableLineStyle lineStyle];
            lineStyle.lineColor = CPTColorFromRGB(0X272727);
            lineStyle.lineWidth = 1;
            theLegend.swatchBorderLineStyle = lineStyle;
            pieGraph.legend = theLegend;
            pieGraph.legend.fillMode=kCAFillModeBackwards;
            pieGraph.legendAnchor = CPTRectAnchorTop;
            pieGraph.legendDisplacement = CGPointMake(0, -330);
            CPTMutableTextStyle *titleStyle = [[CPTMutableTextStyle alloc] init];
            titleStyle.fontName=@"Helvetica-Bold";
            titleStyle.fontSize = 20;
            pieGraph.titleTextStyle = titleStyle;
            pieGraph.titleDisplacement = CGPointMake(0,-30);
            theLegend.numberOfColumns = 2;
            if(contentArray.count == 1)
            {
                pieGraph.legendDisplacement = CGPointMake(-70, -330);
                
            }
            else
            {
                
            }
            [self performFadeInAnimation];
        }
    }
}

-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)index
{
    
    if(index!=9)
    {
        if(currentChart == AccountsChart)
        {
            self.currentChart = PositionsChart;
            selectedAccount = index;
        }
        else
        {
            self.currentChart = AccountsChart;
        }
        //        [self clearPieChart];
        [self performFadeOutAnimation];
    }
}
-(void)clearPieChart
{
    [contentArray removeAllObjects];
    pieGraph.title = nil;
    [pieGraph reloadData];
    [piePlot reloadData];
}

#pragma mark - handling gestures

-(void) handlePinchGesture:(UIPinchGestureRecognizer*) pinch
{
    if(pinch.scale<1)
    {
        if(currentChart == PositionsChart)
        {
            self.currentChart = AccountsChart;
            //[self clearPieChart];
            [self performFadeOutAnimation];
        }
    }
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if(loggedIn)
    {
        if ( [plot isKindOfClass:[CPTPieChart class]] ) {
            return [self.dataForChart count];
        }
        else if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
            return 16;
        }
        else {
            return [dataForPlot count];
        }
    }
    else
        return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSDecimalNumber *num = nil;
    if(loggedIn)
    {
        if ( index >= [self.dataForChart count] ) {
            return nil;
        }
        
        if ( fieldEnum == CPTPieChartFieldSliceWidth ) {
            num = [self.dataForChart objectAtIndex:index];
        }
        else {
            num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:index];
        }
    }
	return num;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    //	if ( piePlotIsRotating ) {
    //		return nil;
    //	}
    return nil;
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart
                        recordIndex:(NSUInteger)index
{
    if(loggedIn)
    {
        if(index == 9)
            return @"Others";
        else
        {
            if(currentChart == AccountsChart)
            {
                return [[[[BFBrokerageAccountStore defaultStore] allBrokerageAccountsInSortedOrder] objectAtIndex:index] name];
            }
            else
            {
                if(index<=[sortedPositions count])
                    return [[sortedPositions objectAtIndex:index]instrumentSymbol];
                else
                    return @"CASH";
            }
        }
    }
    else
        return nil;
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    if(loggedIn)
    {
        if(index == 0)
            return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0Xfde79c) endColor:(0Xf6bc0c)]];   
        else if(index == 1)
            return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0Xb9d6f7) endColor:(0X284b70)]];   
        else if(index == 2)
            return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0Xfbb7b5) endColor:(0X702828)]];   
        else if(index == 3)
            return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0Xb8c0ac) endColor:(0X5f7143)]];  
        else if(index == 4)
            return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0Xa9a3bd) endColor:(0X382c6c)]];   
        else if(index == 5)
            return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0X98c1dc) endColor:(0X0271ae)]];
        else if(index == 6)
            return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0X9dc2b3) endColor:(0X1d7554)]];
        else if(index == 7)
            return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0Xb1a1b1) endColor:(0X50224f)]];
        else if(index == 8)
            return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0Xc1c0ae) endColor:(0X706341)]];
        else
            return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0Xadbdc0) endColor:(0X446a73)]];
    }
    else
        return  nil;
}

#pragma mark - handling the commands from the accounts view controller

-(void) backBTNClicked
{
    self.currentChart = AccountsChart;
    //[self clearPieChart];
    [self performFadeOutAnimation];
    
}

#pragma mark MVC Delegate methods

-(void)userLogout:(NSNotification*)notification
{
    loggedIn = NO;
    self.currentChart = AccountsChart;
    [self clearPieChart];
}

-(void)userLogin:(NSNotification*)notification
{
    loggedIn = YES;
}


@end
