//
//  tradePreviewViewController.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFOrder.h"
#import "BullFirstWebServiceObject.h"

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
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) BullFirstWebServiceObject* restServiceObject;
@property (strong, nonatomic) BullFirstWebServiceObject* estimateOrderServiceObject;
@property (strong, nonatomic) BullFirstWebServiceObject* lastTradeServiceObject;
@property (strong, nonatomic) IBOutlet UILabel *estValue;
@property (strong, nonatomic) IBOutlet UILabel *fee;
@property (strong, nonatomic) IBOutlet UILabel *totalInclFee;

@property (strong, nonatomic) IBOutlet UILabel *lastTrade;
- (IBAction)placeOrderBTNClicked:(id)sender;
- (IBAction)cancelBTNClicked:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil order:(BFOrder *)anOrder;

@end
