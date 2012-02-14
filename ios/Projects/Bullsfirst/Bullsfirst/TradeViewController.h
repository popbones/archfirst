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

@property (nonatomic, retain) UITextField *activeTextField;
@property (nonatomic, retain) NSArray *textFields;
@property (nonatomic, retain) BFPosition *position;
@property (strong, nonatomic) IBOutlet UITextField *cusipText;
@property (strong, nonatomic) IBOutlet UITextField *quantity;
@property (strong, nonatomic) IBOutlet UITextField *limit;

- (IBAction)cancelBTNClicked:(id)sender;
- (IBAction)okBTNClicked:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil position:(BFPosition *)aPosition;

@end
