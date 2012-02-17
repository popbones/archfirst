//
//  tradePreviewViewController.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFOrder.h"

@interface PreviewTradeViewController : UIViewController
{
    BFOrder *order;
    
}

@property (nonatomic, retain) BFOrder *order;

- (IBAction)placeOrderBTNClicked:(id)sender;
- (IBAction)cancelBTNClicked:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(BFOrder *)anOrder;

@end
