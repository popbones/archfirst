//
//  RootViewController.h
//  Bullsfirst
//
//  Created by Subramanian R
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
#import "LoginViewController.h"
#import "AccountsViewController.h"
#import "PositionsViewController.h"
#import "OrdersViewController.h"
#import "TransactionsViewController.h"

@interface RootViewController : UITabBarController <UITabBarControllerDelegate,LoginViewControllerDelegate>
{
    AccountsViewController *accountsViewController;
    PositionsViewController *positionsViewController;
    OrdersViewController *ordersViewController;
    TransactionsViewController *transactionsViewController;
}

@property (nonatomic,retain) AccountsViewController *accountsViewController;
@end
