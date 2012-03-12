//
//  PreviewTradeViewController.h
//  Bullsfirst
//
//  Created by Pong Choa
//  Copyright 2012 Archfirst
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
@property (strong, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *limitedPrice;
@property (strong, nonatomic) IBOutlet UILabel *term;
@property (strong, nonatomic) IBOutlet UILabel *allOrNone;

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
