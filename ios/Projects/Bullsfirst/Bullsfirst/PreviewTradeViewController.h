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
@property (strong, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sideLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *cusipLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *termLabel;
@property (strong, nonatomic) IBOutlet UILabel *allOrNoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *limitPriceLabel;

- (IBAction)placeOrderBTNClicked:(id)sender;
- (IBAction)cancelBTNClicked:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(BFOrder *)anOrder;

@end
