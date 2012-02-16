//
//  UserViewController.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController
@property (strong, nonatomic) UIPopoverController *popOver;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
- (IBAction)logoutBTNClicked:(id)sender;

@end
