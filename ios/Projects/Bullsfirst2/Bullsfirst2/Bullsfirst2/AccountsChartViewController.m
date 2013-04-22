//
//  AccountsChartViewController.m
//  Bullsfirst2
//
//  Created by Rashmi Garg on 1/29/13.
//  Copyright (c) 2013 Rashmi Garg. All rights reserved.
//

#import "AccountsChartViewController.h"

@interface AccountsChartViewController ()

@end

@implementation AccountsChartViewController
#define BAR_POSITION 0
#define BAR_HEIGHT 1
#define COLOR @"COLOR"
#define CATEGORY @"CATEGORY"

#define AXIS_START 0
#define Y_AXIS_START -100
#define Y_AXIS_END 100
#define AXIS_END 20000

@synthesize data, data2, data3, graph;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initChart];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)generateScatterPlot
{
    //Create host view
    //self.hostingView = [[CPTGraphHostingView alloc]
    //                   initWithFrame:[[UIScreen mainScreen]bounds]];
    //[self.view addSubview:self.hostingView];
    
    //Create graph and set it as host view's graph
    self.graph = [[CPTXYGraph alloc] initWithFrame:self.graphView.bounds];
    [self.graphView setHostedGraph:self.graph];
    
    
    //set graph padding and theme
    self.graph.plotAreaFrame.paddingTop = 20.0f;
    self.graph.plotAreaFrame.paddingRight = 20.0f;
    self.graph.plotAreaFrame.paddingBottom = 70.0f;
    self.graph.plotAreaFrame.paddingLeft = 45.0f;//70.0
    //[self.graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    
    //set axes ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:
                        CPTDecimalFromFloat(AXIS_START)
                                                    length:CPTDecimalFromFloat((AXIS_END - AXIS_START))];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:
                        CPTDecimalFromFloat(Y_AXIS_START)
                                                    length:CPTDecimalFromFloat((Y_AXIS_END - Y_AXIS_START))];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    //set axes' title, labels and their text styles
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Arial";
    textStyle.fontSize = 9;
    textStyle.color = [CPTColor blackColor];
    axisSet.xAxis.title = @"Market Value";
    axisSet.yAxis.title = @"Gain %";
    axisSet.xAxis.titleTextStyle = textStyle;
    axisSet.yAxis.titleTextStyle = textStyle;
    axisSet.xAxis.titleOffset = 70.0f;
    axisSet.yAxis.titleOffset = 30.0f;
    CPTMutableTextStyle *textStyle2 = [CPTMutableTextStyle textStyle];
    textStyle2.fontName = @"Arial";
    textStyle2.fontSize = 10;
    textStyle2.color = [CPTColor blackColor];
    //axisSet.xAxis.labelTextStyle = textStyle;
    //axisSet.xAxis.labelOffset = 3.0f;
    axisSet.xAxis.labelTextStyle = nil;
    axisSet.yAxis.labelTextStyle = textStyle2;
    axisSet.yAxis.labelOffset = 3.0f;
    //set axes' line styles and interval ticks
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor whiteColor];
    //lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 3.0f;
    axisSet.xAxis.axisLineStyle = nil;
    axisSet.yAxis.axisLineStyle = nil;
    //axisSet.xAxis.axisLineStyle = lineStyle;
    //axisSet.yAxis.axisLineStyle = lineStyle;
    //axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = nil;
    axisSet.yAxis.minorTickLineStyle = nil;
    axisSet.xAxis.majorTickLineStyle = nil;
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(1000.0f);
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(100.0f);
    //axisSet.xAxis.majorTickLength = 7.0f;
    //axisSet.yAxis.majorTickLength = 20.0f;
    //axisSet.xAxis.minorTickLineStyle = lineStyle;
    //axisSet.yAxis.minorTickLineStyle = lineStyle;
    //axisSet.xAxis.minorTicksPerInterval = 1;
    //axisSet.yAxis.minorTicksPerInterval = 1;
    //axisSet.xAxis.minorTickLength = 5.0f;
    //axisSet.yAxis.minorTickLength = 5.0f;
    
    
    
    self.graph.plotAreaFrame.borderLineStyle = nil;
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init] ;
    dataSourceLinePlot.identifier = @"Data Source Plot";
    dataSourceLinePlot.delegate = self;
    dataSourceLinePlot.dataSource = self;
    dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationStepped;
    dataSourceLinePlot.areaFill = [CPTFill fillWithColor:[CPTColor blueColor]];
    dataSourceLinePlot.areaBaseValue = CPTDecimalFromInteger(0);
    CPTMutableLineStyle *lineStylePlot = [dataSourceLinePlot.dataLineStyle mutableCopy] ;
    lineStylePlot.lineWidth = 1.0;
    lineStylePlot.lineColor = [CPTColor whiteColor];
    dataSourceLinePlot.dataLineStyle = lineStylePlot;
    
    
    
    [graph addPlot:dataSourceLinePlot];
    
    // Second scatter plot
    CPTScatterPlot *dataSourceLinePlot2 = [[CPTScatterPlot alloc] init] ;
    dataSourceLinePlot2.identifier = @"Data Source Plot2";
    dataSourceLinePlot2.delegate = self;
    dataSourceLinePlot2.dataSource = self;
    dataSourceLinePlot2.interpolation = CPTScatterPlotInterpolationStepped;
    dataSourceLinePlot2.areaFill = [CPTFill fillWithColor:[CPTColor redColor]];
    dataSourceLinePlot2.areaBaseValue = CPTDecimalFromInteger(0);
    
    CPTMutableLineStyle *lineStylePlot2 = [dataSourceLinePlot2.dataLineStyle mutableCopy] ;
    lineStylePlot2.lineWidth = 0.0;
    lineStylePlot2.lineColor = [CPTColor whiteColor];
    dataSourceLinePlot2.dataLineStyle = lineStylePlot2;
    // [graph addPlot:dataSourceLinePlot2];
	
    
    // Third scatter plot
    CPTScatterPlot *dataSourceLinePlot3 = [[CPTScatterPlot alloc] init] ;
    dataSourceLinePlot3.identifier = @"Data Source Plot3";
    dataSourceLinePlot3.delegate = self;
    dataSourceLinePlot3.dataSource = self;
    dataSourceLinePlot3.interpolation = CPTScatterPlotInterpolationStepped;
    dataSourceLinePlot3.areaFill = [CPTFill fillWithColor:[CPTColor grayColor]];
    dataSourceLinePlot3.areaBaseValue = CPTDecimalFromInteger(0);
    
    CPTMutableLineStyle *lineStylePlot3 = [dataSourceLinePlot3.dataLineStyle mutableCopy] ;
    lineStylePlot3.lineWidth = 1.0;
    lineStylePlot3.lineColor = [CPTColor whiteColor];
    dataSourceLinePlot3.dataLineStyle = lineStylePlot3;
    [graph addPlot:dataSourceLinePlot3];
    [graph addPlot:dataSourceLinePlot2];

   // [self generateData];
    /*
    // Auto scale the plot space to fit the plot data
    // Extend the y range by 10% for neatness
	
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:dataSourceLinePlot, nil]];
    CPPlotRange *xRange = plotSpace.xRange;
    CPPlotRange *yRange = plotSpace.yRange;
    [xRange expandRangeByFactor:CPDecimalFromDouble(1.3)];
    [yRange expandRangeByFactor:CPDecimalFromDouble(1.3)];
    //plotSpace.yRange = yRange;
	plotSpace.xRange = xRange;
	
    // Restrict y range to a global range
    //CPPlotRange *globalYRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0f)
    //                                                      length:CPDecimalFromFloat(2.0f)];
	CPPlotRange *globalYRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-1.5f)
                                                            length:CPDecimalFromFloat(5.0f)];
	//CPPlotRange *globalXRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-2.5f)
    //                                                      length:CPDecimalFromFloat(6.0f)];
    plotSpace.globalYRange = globalYRange;
	//plotSpace.globalXRange = globalXRange;
	
    // set the x and y shift to match the new ranges
    CGFloat length = xRange.lengthDouble;
    //xShift = length - 3.0;
	//xShift = length - 1.0;
    length = yRange.lengthDouble;
    //yShift = length - 2.0;
	
	
    // Add plot symbols
    CPMutableLineStyle *symbolLineStyle = [CPMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPColor blackColor];
    CPPlotSymbol *plotSymbol = [CPPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPFill fillWithColor:[CPColor blueColor]];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(10.0, 10.0);
    dataSourceLinePlot.plotSymbol = plotSymbol;
	
    // Set plot delegate, to know when symbols have been touched
    // We will display an annotation when a symbol is touched
    dataSourceLinePlot.delegate = self;
    dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0f;
    
    */
}

- (void)initChart
{
    
    self.data = [NSMutableArray array];
    
    int gainPercentage[] = {20,-70,50,0};
    int marketValue[] = {0,5000,12000, 15000};
        
    for (int i = 0; i < 4 ; i++){
        double y_pos = gainPercentage[i];; //Bars will be 10 pts away from each other
        double x_pos = marketValue[i];
        NSDictionary *dataPlot = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithDouble:x_pos],@"x",
                             [NSNumber numberWithDouble:y_pos],@"y",
                             nil];
       
        [self.data addObject:dataPlot];
    }
    self.data2 = [NSMutableArray array];
    
    int gainPercentage2[] = {-70,0};
    int marketValue2[] = {5002,12000};
    
    for (int i = 0; i < 2 ; i++){
        double y_pos = gainPercentage2[i];; //Bars will be 10 pts away from each other
        double x_pos = marketValue2[i];
        NSDictionary *dataPlot = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithDouble:x_pos],@"x",
                                  [NSNumber numberWithDouble:y_pos],@"y",
                                  nil];
        
        [self.data2 addObject:dataPlot];
    }

    int gainPercentage3[] = {-100,-100, 0,0,-100, -100, 0,0,-100, -100, 0, 0, -100};
    int marketValue3[] = {0,4998,4998, 5002, 5002, 11998,11998, 12002, 12002, 14998, 14998, 15002, 15002};
    self.data3 = [NSMutableArray array];
    for (int i = 0; i < 13 ; i++){
        double y_pos = gainPercentage3[i];; //Bars will be 10 pts away from each other
        double x_pos = marketValue3[i];
        NSDictionary *dataPlot = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithDouble:x_pos],@"x",
                                  [NSNumber numberWithDouble:y_pos],@"y",
                                  nil];
        
        [self.data3 addObject:dataPlot];
    }

    [self generateScatterPlot];
    
    
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ( [plot.identifier isEqual:@"Data Source Plot"] )
        return [self.data count];
    else if ( [plot.identifier isEqual:@"Data Source Plot2"] )
        return [self.data2 count];
    else if ( [plot.identifier isEqual:@"Data Source Plot3"] )
        return [self.data3 count];

    
    return 0;
}
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    if ( [plot.identifier isEqual:@"Data Source Plot"] )
    {
        num = [[self.data objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
        if (fieldEnum == CPTScatterPlotFieldY) {
            num = [NSNumber numberWithDouble:[num doubleValue]];
    }
    }
    else if ( [plot.identifier isEqual:@"Data Source Plot2"] )
    {
       num = [[self.data2 objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
        if (fieldEnum == CPTScatterPlotFieldY) {
            num = [NSNumber numberWithDouble:[num doubleValue]];
        }

    }
    else 
    {
        num = [[self.data3 objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
        if (fieldEnum == CPTScatterPlotFieldY) {
            num = [NSNumber numberWithDouble:[num doubleValue]];
        }
        
    }
    return num;
/*
    //NSDecimalNumber *num = nil;
    NSNumber *num = [[NSNumber alloc]init];
    if ( [plot isKindOfClass:[CPTScatterPlot class]] ) {
		switch ( fieldEnum ) {
			case CPTScatterPlotFieldX:
                num = [[self.data objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
				break;
			case CPTScatterPlotFieldY:
				num = [[self.data objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
				break;
		}
    }
	
    return num;
 */
}



#pragma mark CPScatterPlot delegate method
/*
-(void)scatterPlot:(CPScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    //CPXYGraph *graph = [graphs objectAtIndex:0];
	
    if (symbolTextAnnotation) {
        [graph.plotAreaFrame.plotArea removeAnnotation:symbolTextAnnotation];
        [symbolTextAnnotation release];
        symbolTextAnnotation = nil;
    }
	
    // Setup a style for the annotation
    CPMutableTextStyle *hitAnnotationTextStyle = [CPMutableTextStyle textStyle];
    hitAnnotationTextStyle.color = [CPColor whiteColor];
    hitAnnotationTextStyle.fontSize = 16.0f;
    hitAnnotationTextStyle.fontName = @"Helvetica-Bold";
	
    // Determine point of symbol in plot coordinates
    NSNumber *x = [[plotData objectAtIndex:index] valueForKey:@"x"];
    NSNumber *y = [[plotData objectAtIndex:index] valueForKey:@"y"];
    NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
	
    // Add annotation
    // First make a string for the y value
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setMaximumFractionDigits:2];
    NSString *yString = [formatter stringFromNumber:y];
	
    // Now add the annotation to the plot area
    CPTextLayer *textLayer = [[[CPTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle] autorelease];
    symbolTextAnnotation = [[CPPlotSpaceAnnotation alloc] initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:anchorPoint];
    symbolTextAnnotation.contentLayer = textLayer;
    symbolTextAnnotation.displacement = CGPointMake(0.0f, 20.0f);
    [graph.plotAreaFrame.plotArea addAnnotation:symbolTextAnnotation];
}
*/





-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot
                  recordIndex:(NSUInteger)index

{
    
    if ( [barPlot.identifier isEqual:@"chocoplot"] )
    {
        //NSDictionary *bar = [[NSDictionary alloc]initWithDictionary:[self.data objectAtIndex:index]];
        NSDictionary *bar = [self.data objectAtIndex:index];
        
        CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor whiteColor]
                                                            endingColor:[bar valueForKey:@"COLOR"]
                                                      beginningPosition:0.0 endingPosition:0.3 ];
        
        
        [gradient setGradientType:CPTGradientTypeAxial];
        [gradient setAngle:320.0];
        
        //CPTFill *fill = [[CPTFill alloc]initWithGradient:gradient];
        
        CPTFill *fill = [CPTFill fillWithGradient:gradient];
        
        //return fill;
        //CPTFill *fill =  [CPTFill fillWithGradient:[self CPTGradientWithStartColor]];
        return fill;
    }
    return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    
    
    
    
}


- (IBAction)tableViewButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
