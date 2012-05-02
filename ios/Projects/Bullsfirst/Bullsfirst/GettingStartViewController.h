//
//  GettingStartViewController.h
//  Bullsfirst
//
//  Created by pong choa on 4/28/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GettingStartViewController : UIViewController 

- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)changePage:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL pageControlUsed;

@end
