//
//  GettingStartViewController.h
//  Bullsfirst
//
//  Created by pong choa on 4/28/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GettingStartViewController : UIViewController {
    NSArray *contentList;
}

- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)swipeRightGesture:(id)sender;
- (IBAction)swipeLeftGesture:(id)sender;
- (IBAction)changePage:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *helpImageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (retain, nonatomic) NSArray *contentList;
@end
