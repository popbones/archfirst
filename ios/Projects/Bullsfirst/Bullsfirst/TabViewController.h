//
//  OrdersViewController.h
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

#import <Foundation/Foundation.h>
#import "BullFirstWebServiceObject.h"

@interface TabViewController : UIViewController {
}

@property (strong, nonatomic) IBOutlet UIView *portraitTitleBar;
@property (strong, nonatomic) IBOutlet UIView *landscrapeTitleBar;


- (IBAction)refreshBTNClicked:(id)sender;
- (IBAction)tradeBTNClicked:(id)sender;
- (IBAction)transferBTNClicked:(id)sender;
- (IBAction)filterBTNClicked:(id)sender;

@property (strong, nonatomic) BullFirstWebServiceObject* restServiceObject;

@property (strong, nonatomic) UIPopoverController *userPopOver;

@end