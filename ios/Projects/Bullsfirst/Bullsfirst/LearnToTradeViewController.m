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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ModalView_TitleBar_BackgroundGradient.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = barButtonItem;
	self.navigationItem.title = @"Learn To Trade";

    self.currentPage = 0;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 9, self.scrollView.frame.size.height);
    CGRect frame = self.scrollView.frame;
    
    for (int page=0; page<9; page++) {
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        NSString *filename = [NSString stringWithFormat:@"bullsfirst-LearntoTrade-%d.png", page+1];
        imageView.image = [UIImage imageNamed:filename];
        [self.scrollView addSubview:imageView];
    }
    self.pageControl.numberOfPages = 9;
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

@end
