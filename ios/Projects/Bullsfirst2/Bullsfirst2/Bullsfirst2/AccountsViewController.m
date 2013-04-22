//
//  AccountsViewController.m
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

#import "AccountsViewController.h"
#import "BFBrokerageAccount.h"
#import "BFMoney.h"
#import "BFBrokerageAccountStore.h"
#import "AccountsTableViewController.h"
#import "AddAccountViewController.h"
#import "EditAccountNameViewController.h"
#import "BullFirstWebServiceObject.h"
#import "AppDelegate.h"
#import "editAccountNameBTN.h"
#import "PositionsViewController.h"
#import "UserViewController.h"
#import "AccountTableViewCell.h"

#ifdef UI_USER_INTERFACE_IDIOM
#define IS_IPAD() (UI_USER_INTERFACE_IDIOM == UIUserInterfaceIdiomPad)
#else
#define IS_IPAD() (false)
#endif
#define AXIS_START 0
#define Y_AXIS_START -100
#define Y_AXIS_END 100
#define AXIS_END 70000

@implementation AccountsViewController
@synthesize accountToolbar;

@synthesize accountCell,chartTitle, layoutView;
@synthesize accountNameLBL,accountNumberLBL,marketValueLBL,cashLBL,actionLBL, addAccountButton;
@synthesize totalCostLabel, totalGainLabel, totalMarketValueLabel;
@synthesize userPopOver;

@synthesize data, data2, data3, graph;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Accounts"];
        UIImage *i = [UIImage imageNamed:@"TabBar_Accounts.png"];
        [tbi setImage:i];                
    }
    
    return self;
}


-(void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];

    if(selectedRow!=-1)
    {
        orientation=[[UIDevice currentDevice] orientation];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [accountsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        UITableViewCell* cell=[accountsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
        UIButton *editButton = (UIButton *)[cell viewWithTag:5];
        editButton.highlighted = NO;
        }
    }
    [accountsTable reloadData];
    //Added for iPhone changes
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if(!loginSuccess)
        {
           // [self performSegueWithIdentifier:@"ShowLogin" sender:self];
            loginSuccess = YES;
        }
        else
            [accountsTable reloadData];
    }
    
    
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // To hide the title display and have it on the back button
    self.title = @"Accounts";
    UILabel *label = [[UILabel alloc] init] ;
    self.navigationItem.titleView = label;
    label.text = @"";
    
    int totalCost=0, totalMarketValue=0, gain = 0;
    if([self.navigationController.navigationBar  respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"HeaderBar_BackgroundGradient.jpg"] forBarMetrics:UIBarMetricsDefault];
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setMaximumFractionDigits:0];
    [formatter setMinimumFractionDigits:0];
    NSMutableArray *brokerageAccounts = (NSMutableArray*)[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    if ([brokerageAccounts count] > 0)
    {
        for(int i=0; i < [brokerageAccounts count]; i++)
        {
            BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:i];
            totalMarketValue += [account.marketValue.amount integerValue];
            totalCost += [account.cashPosition.amount integerValue];
        }
        gain = totalMarketValue - totalCost;
        self.totalMarketValueLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:totalMarketValue]];
        self.totalCostLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:totalCost]];
        self.totalGainLabel.text = [formatter stringFromNumber:[NSNumber numberWithInt:gain]];

        accountsTable.delegate = self;
        accountsTable.dataSource = self;
        loginSuccess = NO;
        highlightedLabelIndex = -1;
        [self initChart];
    //[self.chartSlider setMinimumTrackImage:[UIImage imageNamed:@"left_arrow_bg.png"] forState:UIControlStateNormal];
        [self.chartSlider setThumbImage:[UIImage imageNamed:@"courser_normal_state.png"]forState:UIControlStateNormal];
        [self.chartSlider setThumbImage:[UIImage imageNamed:@"courser_active_state.png"]forState:UIControlStateSelected];
        [self.chartSlider setThumbImage:[UIImage imageNamed:@"courser_hover_state.png"]forState:UIControlStateHighlighted];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:@"USER_LOGOUT" object:nil];
    
        
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"EditAccountNameSegue"])
    {
        EditAccountNameViewController *editAccountViewController = [segue destinationViewController];
        if([editAccountViewController isKindOfClass:[EditAccountNameViewController class]])
        {
            editAccountNameBTN *button = (editAccountNameBTN *)sender;
            [editAccountViewController initWithAccountName:button.currentName withId:button.accountID];
            [editAccountViewController setModalPresentationStyle:UIModalPresentationFormSheet];
        }
    }
    else if([segue.identifier isEqualToString:@"PositionsViewSegue"])
    {
        PositionsViewController *destController = [segue destinationViewController];
       
        if([destController isKindOfClass:[PositionsViewController class]])
        {
            destController.selectedAccount = selectedRow;
            //NSLog(@"in AacountViewController account selecetd is %d",selectedRow );
            
        }
    }
 
        
     
}
- (void)viewDidUnload
{
    [self setAccountToolbar:nil];
    [super viewDidUnload];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate removeObserver:self forKeyPath:@"accounts"];
    
    [pieChartViewController removeObserver:self forKeyPath:@"currentChart"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USER_LOGOUT" object:nil];
    
}
//initialze brokerage accounts
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Added for iPhone changes
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    if(toInterfaceOrientation==UIDeviceOrientationLandscapeRight||toInterfaceOrientation==UIDeviceOrientationLandscapeLeft)
    {
        CGRect rect=accountsTable.frame;
        accountsTable.frame = CGRectMake(rect.origin.x, rect.origin.y,620,655);
        rect=accountNameLBL.frame;
        accountNameLBL.frame = CGRectMake(20, rect.origin.y, rect.size.width, rect.size.height);
        rect = accountNumberLBL.frame;
        accountNumberLBL.frame = CGRectMake(180, rect.origin.y, rect.size.width, rect.size.height);
        rect = marketValueLBL.frame;
        marketValueLBL.frame = CGRectMake(220, rect.origin.y, rect.size.width, rect.size.height);
        rect = cashLBL.frame;
        cashLBL.frame = CGRectMake(360, rect.origin.y, rect.size.width, rect.size.height);
        rect = actionLBL.frame;
        actionLBL.frame = CGRectMake(554, rect.origin.y, rect.size.width, rect.size.height);
        chartView.hidden = NO;
    }
    else
    {
        CGRect rect=accountsTable.frame;
        
        accountsTable.frame = CGRectMake(rect.origin.x,rect.origin.y,766, 920); 
        rect=accountNameLBL.frame;
        accountNameLBL.frame = CGRectMake(20, rect.origin.y, rect.size.width, rect.size.height);
        rect = accountNumberLBL.frame;
        accountNumberLBL.frame = CGRectMake(230, rect.origin.y, rect.size.width, rect.size.height);
        rect = marketValueLBL.frame;
        marketValueLBL.frame = CGRectMake(320, rect.origin.y, rect.size.width, rect.size.height);
        rect = cashLBL.frame;
        cashLBL.frame = CGRectMake(490, rect.origin.y, rect.size.width, rect.size.height);
        rect = actionLBL.frame;
        actionLBL.frame = CGRectMake(680, rect.origin.y, rect.size.width, rect.size.height);
        chartView.hidden = YES;
        
    }
    [accountsTable reloadData];
     }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice].systemVersion intValue] >= 5) {
        [self willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:0.1];
    }
    return YES;
}

- (IBAction)createAccount:(id)sender
{
    [self performSegueWithIdentifier:@"AddAccountSegue" sender:addAccountButton];
    
}

#pragma mark - KVO lifecycle

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"accounts"]) 
    {
        NSMutableArray *brokerageAccounts = (NSMutableArray*)[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
        if ([brokerageAccounts count] > 0) 
        {
            [accountsTable reloadData];
            [pieChartViewController constructPieChart];
            //[pieChartMVPositionViewController constructPieChart];
        }
        return;
    }

    if([keyPath isEqualToString:@"chartTitle"])
    {
        chartTitle.text = [change objectForKey:NSKeyValueChangeNewKey];
    }
    
}
#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    return headerView.frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSMutableArray *brokerageAccounts = (NSMutableArray*)[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    return [brokerageAccounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AccountDataCell";
    
    NSMutableArray *brokerageAccounts = (NSMutableArray*)[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumberFormatter *percentageFormatter = [[NSNumberFormatter alloc] init];
    [percentageFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    [percentageFormatter setMinimumFractionDigits:0];
    [percentageFormatter setMaximumFractionDigits:1];
    AccountTableViewCell *cell = (AccountTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[AccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if ([brokerageAccounts count] > 0)
    {
        BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:indexPath.row];
       
        cell.accountName.text = [NSString stringWithFormat:@"%@", account.name];
        cell.marketValue.text = [formatter stringFromNumber:account.marketValue.amount];
        NSNumber *gain = [[NSNumber alloc]init];
        float perc;
        if(([account.marketValue.amount intValue] == 0)  && ([account.cashPosition.amount intValue] == 0))
            perc = 0.0;
        else
            perc = ([account.marketValue.amount floatValue] - [account.cashPosition.amount floatValue])/([account.cashPosition.amount floatValue]);

        gain = [NSNumber numberWithFloat:perc];
        cell.gainPercentage.text = [percentageFormatter stringFromNumber:gain];
        cell.cash.text = [formatter stringFromNumber:account.cashPosition.amount];
        editAccountNameBTN *edit = (editAccountNameBTN *)[cell editButton]; // edit button
        [edit addTarget:self action:@selector(editAccount:) forControlEvents:UIControlEventTouchUpInside];
        [edit setSelected:YES];
        [edit setImage:[UIImage imageNamed:@"EditButton-PushDown.png"] forState:UIControlStateHighlighted];
        [edit setImage:[UIImage imageNamed:@"EditButton.png"] forState:UIControlStateNormal];
        edit.currentName=account.name;
        edit.accountID=[NSString stringWithFormat:@"%d", [account.brokerageAccountID intValue]];
        edit.index=(NSInteger*)indexPath.row;
        UIView *selected = [[UIView alloc] initWithFrame:cell.contentView.frame];
        selected.backgroundColor=[UIColor blackColor];
        cell.selectedBackgroundView = selected;
    }
    return cell;

}

-(void) selectionChanged:(id)sender
{
}

-(void)editAccount:(id)sender
{
    editAccountNameBTN *button = (editAccountNameBTN *)sender;
    [self performSegueWithIdentifier:@"EditAccountNameSegue" sender:button];
}


- (IBAction)backBTNClicked:(id)sender
{
    [pieChartViewController backBTNClicked];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountTableViewCell *accountTableCell = (AccountTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    editAccountNameBTN *editButton = (editAccountNameBTN *)accountTableCell.editButton;
    editButton.highlighted = NO;
    //PositionsViewController *controller = [[PositionsViewController alloc] initWithNibName:@"PositionsViewController" bundle:nil account:indexPath.row];
    selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"PositionsViewSegue" sender:self];

}

#pragma mark MVC Delegate methods

-(void)userLogout:(NSNotification*)notification
{
    [[BFBrokerageAccountStore defaultStore] clearAccounts];
    self.chartTitle.text = nil;
}
// Added for iPhone changes - for the time being to Logout on pressing Settings button
// To do - add popover
- (IBAction)userLogoutClicked:(id)sender {
    [[BFBrokerageAccountStore defaultStore] clearAccounts];
    [self performSegueWithIdentifier:@"ShowLogin" sender:self];
    loginSuccess = YES;
    
}

- (IBAction)graphViewButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"AccountsChartSegue" sender:self];
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
    self.graph.plotAreaFrame.paddingTop = 10.0f;
    self.graph.plotAreaFrame.paddingRight = 10.0f;
    self.graph.plotAreaFrame.paddingBottom = 5.0f;//70.0
    self.graph.plotAreaFrame.paddingLeft = 35.0f;//45.0
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
    axisSet.xAxis.titleOffset = 35.0f;
    axisSet.yAxis.titleOffset = 20.0f;
    CPTMutableTextStyle *textStyle2 = [CPTMutableTextStyle textStyle];
    textStyle2.fontName = @"Arial";
    textStyle2.fontSize = 9;
    textStyle2.color = [CPTColor blackColor];
    //axisSet.xAxis.labelTextStyle = textStyle;
    //axisSet.xAxis.labelOffset = 1.0f;
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
    
    self.graph.plotAreaFrame.borderLineStyle = nil;
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init] ;
    dataSourceLinePlot.identifier = @"Data Source Plot";
    dataSourceLinePlot.delegate = self;
    dataSourceLinePlot.dataSource = self;
    dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationStepped;
    //dataSourceLinePlot.areaFill = [CPTFill fillWithColor:[CPTColor blueColor]];
    dataSourceLinePlot.areaFill = [CPTFill fillWithColor:CPTColorFromRGB(0xf6bc0c)];
    dataSourceLinePlot.areaBaseValue = CPTDecimalFromInteger(0);
    
    CPTMutableLineStyle *lineStylePlot = [dataSourceLinePlot.dataLineStyle mutableCopy] ;
    lineStylePlot.lineWidth = 3.0;
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
    
    // Third scatter plot
    CPTScatterPlot *dataSourceLinePlot3 = [[CPTScatterPlot alloc] init] ;
    dataSourceLinePlot3.identifier = @"Data Source Plot3";
    dataSourceLinePlot3.delegate = self;
    dataSourceLinePlot3.dataSource = self;
    dataSourceLinePlot3.interpolation = CPTScatterPlotInterpolationStepped;
    dataSourceLinePlot3.areaFill = [CPTFill fillWithColor:[CPTColor grayColor]];
    dataSourceLinePlot3.areaBaseValue = CPTDecimalFromInteger(0);
    
    CPTMutableLineStyle *lineStylePlot3 = [dataSourceLinePlot3.dataLineStyle mutableCopy] ;
    lineStylePlot3.lineWidth = 3.0;
    lineStylePlot3.lineColor = [CPTColor whiteColor];
    dataSourceLinePlot3.dataLineStyle = lineStylePlot3;
    [graph addPlot:dataSourceLinePlot3];
    
     // Fourth scatter plot    
    CPTScatterPlot *dataSourceLinePlot4 = [[CPTScatterPlot alloc] init] ;
    dataSourceLinePlot4.identifier = @"Data Source Plot4";
    dataSourceLinePlot4.delegate = self;
    dataSourceLinePlot4.dataSource = self;
    dataSourceLinePlot4.interpolation = CPTScatterPlotInterpolationStepped;
    dataSourceLinePlot4.areaFill = [CPTFill fillWithColor:[CPTColor grayColor]];
    dataSourceLinePlot4.areaBaseValue = CPTDecimalFromInteger(0);
    
    CPTMutableLineStyle *lineStylePlot4 = [dataSourceLinePlot4.dataLineStyle mutableCopy] ;
    lineStylePlot4.lineWidth = 1.0;
    lineStylePlot4.lineColor = [CPTColor whiteColor];
    dataSourceLinePlot4.dataLineStyle = lineStylePlot4;
    //[graph addPlot:dataSourceLinePlot4];
    
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
    NSMutableArray *brokerageAccounts = (NSMutableArray*)[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    int gainPercentage[] = {70,45,30,20,0};
    double lastMarketValue = 0;
     float perc;
    //NSString *accountName[] = {@"one", @"two", @"three", @"four"};
    //for (int i = 0; i < 4 ; i++){
    for (int i = 0; i < [brokerageAccounts count] ; i++){
        double y_pos = gainPercentage[i];; //Bars will be 10 pts away from each other
        BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:i];
        double x_pos = account.marketValue.amount.doubleValue;
        NSString *name = account.name;
        
        if(i == 0)
        {
            lastMarketValue = 0;
        }
        NSNumber *gain = [[NSNumber alloc]init];
        if(([account.marketValue.amount intValue] == 0)  && ([account.cashPosition.amount intValue] == 0))
                perc = 0.0;
        else
        {
                perc = 100*([account.marketValue.amount floatValue] - [account.cashPosition.amount floatValue])/([account.cashPosition.amount floatValue]);
                //NSLog(@"gain percentage is %f", perc);
        }
        gain = [NSNumber numberWithFloat:perc];
        //NSLog(@"gain percentage is %f", [gain floatValue]);
        //NSLog(@" x is %f, max xis %f", lastMarketValue, x_pos+lastMarketValue);

        NSDictionary *dataPlot = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithDouble:lastMarketValue],@"x",
                                  [NSNumber numberWithDouble:gainPercentage[i]],@"y",
                                  name, @"name",
                                  [NSNumber numberWithDouble:(x_pos+lastMarketValue)],@"max_x",
                                  nil];
        NSDictionary *dataPlot3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithDouble:lastMarketValue],@"x",
                                  [NSNumber numberWithDouble:y_pos],@"y",
                                  nil];
        
        [self.data3 addObject:dataPlot3];
        lastMarketValue = lastMarketValue + x_pos;
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

    int gainPercentage3[] = {-100,-100, -100, -100, 0};
    int marketValue3[] = {0,66990, 66990, 66990, 66990, 66990};
    self.data3 = [NSMutableArray array];
    for (int i = 0; i < [brokerageAccounts count] ; i++){
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
}
-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    if ( [plot.identifier isEqual: @"Data Source Plot"] )
    {
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        textStyle.fontName = @"Arial";
        textStyle.fontSize = 9;
        textStyle.color = [CPTColor blackColor];
        NSDictionary *plot;
        int labelIndex = 0;
        if(highlightedLabelIndex < 0)
            labelIndex = 0;
        else labelIndex = highlightedLabelIndex;
       
        plot = [[NSDictionary alloc]initWithDictionary:[self.data objectAtIndex:labelIndex]];
        CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@", [plot valueForKey:@"name"]]];
        label.textStyle =textStyle;
        label.paddingLeft = 70.0f;
        label.paddingBottom = 20.0f;
        if(labelIndex == index)
        {
            highlightedLabelIndex = index;
        return label;
        }
        else return nil;
    }
    return nil;
  
}

- (IBAction)chartSliderAction:(id)sender {
    UISlider *slider = (UISlider *) sender;
    float progressAsInt = slider.value*70000;
   // NSString *newText =[[NSString alloc]
     //                   initWithFormat:@"%f",progressAsInt];
    //NSLog(@"slider value is %@",newText );
    int i = 0;
    for(i=0; i < [self.data count]; i++)
    {
        NSDictionary *plot = [[NSDictionary alloc]initWithDictionary:[self.data objectAtIndex:i]];
        //NSLog(@"----For index %d", i);
        //NSLog(@"x is %@, max is %@", [plot valueForKey:@"x"], [plot valueForKey:@"max_x"]);
        //NSLog(@"y is %@, name is %@", [plot valueForKey:@"y"], [plot valueForKey:@"name"]);
        if((progressAsInt < [[plot valueForKey:@"max_x"]floatValue]) &&
           (progressAsInt > [[plot valueForKey:@"x"]floatValue]))
        {
            //NSLog(@"found i %d, highlighted index is %d", i, highlightedLabelIndex);
            if(highlightedLabelIndex != i)
            {
            highlightedLabelIndex = i;
            [accountsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:highlightedLabelIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
            [self.graph reloadData];
            }
            break;
        }
    }
}
@end
