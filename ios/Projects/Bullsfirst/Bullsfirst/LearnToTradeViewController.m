//
//  LearnToTradeViewController.m
//  Bullsfirst
//
//  Created by pong choa on 11/10/12.
//
//

#import "LearnToTradeViewController.h"

@interface LearnToTradeViewController ()

@end

@implementation LearnToTradeViewController
@synthesize pdf;

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

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ModalView_TitleBar_BackgroundGradient.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = barButtonItem;
	self.navigationItem.title = @"Learn To Trade";
    
    NSString *thePath = [[NSBundle mainBundle]
                         pathForResource:@"bullsfirst-LearntoTrade" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:thePath];    
    pdf = [[PDFScrollView alloc] initWithFrame:CGRectMake(0, -40, 600,480)
                                           url:url];
    [self.view addSubview:pdf];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction & UISwipeGestureRecognizerDirectionLeft)
    {
        if (pdf.currentPage < pdf.totalPage) {
            pdf.currentPage++;
            [pdf gotoPage:pdf.currentPage];
        }
    }
    
    if (recognizer.direction & UISwipeGestureRecognizerDirectionRight)
    {
        if (pdf.currentPage > 1) {
            pdf.currentPage--;
            [pdf gotoPage:pdf.currentPage];
        }
    }
}
@end
