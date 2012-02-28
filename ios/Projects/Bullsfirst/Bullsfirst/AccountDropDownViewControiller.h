//
//  AccountDropDownViewControiller.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DropdownViewController.h"
@class AccountDropDownViewControiller;

@protocol AccountDropdownViewControllerDelegate
- (void)accountSelectionChanged:(AccountDropDownViewControiller *)controller;
@end

@interface AccountDropDownViewControiller : DropdownViewController

@property (retain, nonatomic) id <AccountDropdownViewControllerDelegate> accountDelegate;

@end
