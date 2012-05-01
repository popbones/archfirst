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
@synthesize helpImageView;
@synthesize pageControl;
@synthesize navBar;
@synthesize currentPage;

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
    [navBar setBackgroundImage:[UIImage imageNamed:@"ModalView_TitleBar_BackgroundGradient.jpg"] forBarMetrics:UIBarMetricsDefault];
    currentPage = 0;
}

- (void)viewDidUnload
{
    [self setNavBar:nil];
    [self setPageControl:nil];
    [self setHelpImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)doneButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)swipeRightGesture:(id)sender {
    pageControl.currentPage -= 1;
    int page = pageControl.currentPage;
    if (currentPage == page)
        return;
    
    [UIView beginAnimations:@"pageChange" context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect viewframe= helpImageView.frame;
    viewframe.origin.x+=600;
    helpImageView.frame = viewframe;
    [UIView commitAnimations];
    
    viewframe.origin.x=-600;
    helpImageView.frame = viewframe;
    NSString *filename = [NSString stringWithFormat:@"bullsfirst-GettingStarted-%d.png", page+1];
    helpImageView.image = [UIImage imageNamed:filename];
    
    [UIView beginAnimations:@"pageChange" context:nil];
    [UIView setAnimationDuration:0.5];
    viewframe= helpImageView.frame;
    viewframe.origin.x+=600;
    helpImageView.frame = viewframe;
    [UIView commitAnimations];
    
    currentPage = page;
}

- (IBAction)swipeLeftGesture:(id)sender {
    pageControl.currentPage += 1;
    int page = pageControl.currentPage;
    if (currentPage == page)
        return;
    
    [UIView beginAnimations:@"pageChange" context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect viewframe= helpImageView.frame;
    viewframe.origin.x-=600;
    helpImageView.frame = viewframe;
    [UIView commitAnimations];
    
    viewframe.origin.x=600;
    helpImageView.frame = viewframe;
    NSString *filename = [NSString stringWithFormat:@"bullsfirst-GettingStarted-%d.png", page+1];
    helpImageView.image = [UIImage imageNamed:filename];
    
    [UIView beginAnimations:@"pageChange" context:nil];
    [UIView setAnimationDuration:0.5];
    viewframe= helpImageView.frame;
    viewframe.origin.x-=600;
    helpImageView.frame = viewframe;
    [UIView commitAnimations];

    currentPage = page;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
    
    if (page > currentPage) {
        pageControl.currentPage -= 1;
        [self swipeLeftGesture:sender];
    } else {
        pageControl.currentPage += 1;
        [self swipeRightGesture:sender];
    }
}


@end
