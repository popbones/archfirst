//
//  PieChartMVPositionViewController.m
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

#import "PieChartMVPositionViewController.h"

#import "BFBrokerageAccount.h"
#import "BFBrokerageAccountStore.h"
#import "BFMoney.h"
#import "BFPosition.h"
@implementation PieChartMVPositionViewController

@synthesize pieChartView;
@synthesize dataForChart, dataForPlot;
@synthesize delegate;
@synthesize accountIndex;
#pragma mark -
#pragma mark Helper methods

-(void) performAnimation
{
    
    //    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //    
    //	rotation.removedOnCompletion = YES;
    //	rotation.fromValue			 = [NSNumber numberWithFloat:M_PI * 0.5];
    //	rotation.toValue			 = [NSNumber numberWithFloat:0];
    //	rotation.duration			 = 1.0f;
    //	rotation.timingFunction		 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
	fadeInAnimation.removedOnCompletion = YES;
	fadeInAnimation.fromValue			 = [NSNumber numberWithFloat:0.0];
	fadeInAnimation.toValue			 = [NSNumber numberWithFloat:1];
	fadeInAnimation.duration			 = 1.0f;
	fadeInAnimation.timingFunction		 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	piePlot.shouldRasterize=YES;
    
    CAAnimationGroup* animationGroup=[CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:fadeInAnimation, nil];
    
    animationGroup.delegate = self;
    animationGroup.duration = 1.0f;
    
	[piePlot addAnimation:animationGroup forKey:@"rotationAndFadeIn"];
    
	piePlotIsRotating = YES;
    
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
}


-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
	// Add a rotation animation
	//[self performAnimation];
    [piePlot setHidden:NO];
    viewOnFront=YES;
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [piePlot setHidden:YES];
    viewOnFront = NO;
}
-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	piePlotIsRotating = NO;
	if(viewOnFront== NO)
    {
        piePlot.opacity=0;
        [piePlot setHidden:YES];
    }
    else
    {
        piePlot.opacity=1;
        [piePlot setHidden:NO];
    }
	//[piePlot performSelector:@selector(reloadData) withObject:nil afterDelay:0.4];
}


/*
 -(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
 {
 if ( UIInterfaceOrientationIsLandscape(fromInterfaceOrientation) ) {
 // Move the plots into place for portrait
 pieChartView.frame	  = CGRectMake(408.0f, 644.0f, 340.0f, 340.0f);
 }
 else {
 // Move the plots into place for landscape
 pieChartView.frame	  = CGRectMake(684.0f, 408.0f, 320.0f, 320.0f);
 }
 }
 */

/*
 -(void)didReceiveMemoryWarning
 {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
 }
 */

/*
 -(void)viewDidUnload
 {
 // Release any retained subviews of the main view.
 // e.g. self.myOutlet = nil;
 }
 */


#pragma mark -
#pragma mark Plot construction methods

-(void)constructPieChart
{
	// Create pieChart from theme
	pieGraph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTTheme *theme = [CPTTheme themeNamed:kBFPlainWhiteTheme];
	[pieGraph applyTheme:theme];
	pieChartView.hostedGraph			 = pieGraph;
	pieGraph.plotAreaFrame.masksToBorder = NO;
    
	pieGraph.paddingLeft   = 20.0;
	pieGraph.paddingTop	   = 20.0;
	pieGraph.paddingRight  = 20.0;
	pieGraph.paddingBottom = 220.0;
    
    
	pieGraph.axisSet = nil;
    
	// Prepare a radial overlay gradient for shading/gloss
	//CPTGradient *overlayGradient = [[[CPTGradient alloc] init] autorelease];
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
	overlayGradient.gradientType = CPTGradientTypeAxial;
	overlayGradient				 = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.0];
	overlayGradient				 = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.3] atPosition:0.9];
	overlayGradient				 = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.7] atPosition:1.0];
    overlayGradient.angle = 315;
	// Add pie chart
	piePlot					= [[CPTPieChart alloc] init];
	piePlot.dataSource		= self;
    piePlot.delegate        = self;
	piePlot.pieRadius		= 130.0;
	piePlot.identifier		= @"Pie Chart 1";
	piePlot.startAngle		= M_PI/2;
	piePlot.sliceDirection	= CPTPieDirectionClockwise;
	//piePlot.borderLineStyle = [CPTLineStyle lineStyle];
	piePlot.labelOffset		= 5.0;
	piePlot.overlayFill		= [CPTFill fillWithGradient:overlayGradient];
	[pieGraph addPlot:piePlot];
	//[piePlot release];
    
	// Add some initial data
	//NSMutableArray *contentArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:20.0], [NSNumber numberWithDouble:30.0], [NSNumber numberWithDouble:NAN], [NSNumber numberWithDouble:60.0], nil];
    //
    NSMutableArray *contentArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    double total = 0.0;
    
    if([[BFBrokerageAccountStore defaultStore]allBrokerageAccounts].count!=0)
    {
        BFBrokerageAccount *neededAccount=[[[BFBrokerageAccountStore defaultStore]allBrokerageAccounts] objectAtIndex:accountIndex];
        for (BFPosition *position in [neededAccount positions] ){
            [tempArray addObject:[[position marketValue] amount]];
            total += [[[position marketValue] amount] doubleValue];
            
        }
        total +=[[[neededAccount cashPosition]amount]doubleValue];
        
        int count = 0;
        for(NSNumber *amount in tempArray)
        {
            if(count < 9)
            {
                count++;        
                [contentArray addObject:[NSNumber numberWithDouble:(100.0*[amount doubleValue]/total)]];
            }
        }        
        
        self.dataForChart = contentArray;
        // Add legend
        CPTLegend *theLegend = [CPTLegend legendWithGraph:pieGraph];
        theLegend.numberOfColumns = 2;
        theLegend.columnMargin = 47.0;
        theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
        //theLegend.borderLineStyle = [CPTLineStyle lineStyle];
        theLegend.cornerRadius = 5.0;
        CPTMutableLineStyle* lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.lineColor = CPTColorFromRGB(0X272727);
        lineStyle.lineWidth = 1;
        theLegend.swatchBorderLineStyle = lineStyle;
        pieGraph.legend = theLegend;
        pieGraph.legendAnchor = CPTRectAnchorTop;
        pieGraph.legendDisplacement = CGPointMake(0, -380);     
        pieGraph.title=neededAccount.name;
        pieGraph.titleDisplacement = CGPointMake(0,0);
        [self performAnimation];
    }
}
-(void)clearPieChart
{
    piePlot=nil;
}
#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
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



-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSDecimalNumber *num = nil;
    
    if ( index >= [self.dataForChart count] ) {
        return nil;
    }
    
    if ( fieldEnum == CPTPieChartFieldSliceWidth ) {
        num = [self.dataForChart objectAtIndex:index];
    }
    else {
        num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:index];
    }
    
	return num;
}
-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)index
{    
    [delegate pieChartMVPositionClicked];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
	if ( piePlotIsRotating ) {
		return nil;
	}
    
    //	static CPTMutableTextStyle *whiteText = nil;
    //    
    //	if ( !whiteText ) {
    //		whiteText		= [[CPTMutableTextStyle alloc] init];
    //		whiteText.color = [CPTColor whiteColor];
    //	}
    //    
    //	static CPTMutableTextStyle *blackText = nil;
    //    
    //	if ( !blackText ) {
    //		blackText		= [[CPTMutableTextStyle alloc] init];
    //		blackText.color = [CPTColor blackColor];
    //	}
    //    
    //	CPTTextLayer *newLayer = nil;
    //    
    //    switch ( index ) {
    //        case 0:
    //            newLayer = (id)[NSNull null];
    //            break;
    //            
    //        default:
    //            //newLayer = [[[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%lu", index] style:whiteText] autorelease];
    //            newLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%lu", index] style:blackText];
    //            break;
    //    }
    //    
    //	return newLayer;
    return nil;
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart
                        recordIndex:(NSUInteger)index
{
    if(index<=[[[[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts] objectAtIndex:accountIndex] positions] count])
        return [[[[[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts] objectAtIndex:accountIndex] positions] objectAtIndex:index]instrumentSymbol];
    else
        return @"CASH";
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
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
        return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0X1d7554) endColor:(0X9dc2b3)]];
    else if(index == 7)
        return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0Xb1a1b1) endColor:(0X50224f)]];
    else if(index == 8)
        return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0Xc1c0ae) endColor:(0X706341)]];
    else
        return [CPTFill fillWithGradient:[self CPTGradientWithStartColor:(0Xadbdc0) endColor:(0X446a73)]];
    
}


@end

