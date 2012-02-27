//
//  TransferViewController.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BullFirstWebServiceObject.h"
@interface TransferViewController : UIViewController

- (IBAction)transferBTNClicked:(id)sender;
- (IBAction)cancelBTNClicked:(id)sender;
@property (nonatomic,assign) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) BullFirstWebServiceObject *restServiceObject;
@end
