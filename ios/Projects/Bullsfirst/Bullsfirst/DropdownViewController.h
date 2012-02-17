//
//  DropdownViewController.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropdownViewController;

@protocol DropdownViewControllerDelegate
- (void)selectionChanged:(DropdownViewController *)controller;
@end

@interface DropdownViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *selectionsTBL;
@property (strong, nonatomic) UIPopoverController *popOver;
@property (strong, nonatomic) NSArray *selections;
@property (strong, nonatomic) NSString *selected;
@property (assign, nonatomic) int tag;
@property (strong, nonatomic) id <DropdownViewControllerDelegate> delegate;

@end

