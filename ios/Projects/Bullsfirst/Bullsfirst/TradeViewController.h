//
//  TradeViewController.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFPosition.h"

@interface TradeViewController : UIViewController {
    BFPosition *position;
}

@property (nonatomic, retain) BFPosition *position;
@property (strong, nonatomic) IBOutlet UITextField *cusipText;

- (IBAction)cancelBTNClicked:(id)sender;
- (IBAction)okBTNClicked:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil position:(BFPosition *)aPosition;

@end
