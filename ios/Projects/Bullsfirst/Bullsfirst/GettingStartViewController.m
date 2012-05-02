//
//  GettingStartViewController.m
//  Bullsfirst
//
//  Created by pong choa on 4/28/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "GettingStartViewController.h"

@interface GettingStartViewController ()

@end

@implementation GettingStartViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize currentPage;
@synthesize pageControlUsed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define kNumberOfPages 11

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ModalView_TitleBar_BackgroundGradient.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClicked:)];
    barButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = barButtonItem;
	self.navigationItem.title = @"Getting Started";

    currentPage = 0;
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    CGRect frame = scrollView.frame;

    for (int page=0; page<kNumberOfPages; page++) {
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        NSString *filename = [NSString stringWithFormat:@"bullsfirst-GettingStarted-%d.png", page+1];
        imageView.image = [UIImage imageNamed:filename];
        [scrollView addSubview:imageView];
    }

}

- (void)viewDidUnload
{
    [self setPageControl:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)doneButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


@end
