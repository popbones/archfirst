//
//  RootController.h
//  Bullsfirst
//
//  Created by suravi on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "AccountsViewController.h"
#import "PositionsViewController.h"
#import "OrdersViewController.h"
#import "TransactionsViewController.h"

@interface RootController : UITabBarController <UITabBarControllerDelegate,LoginViewControllerDelegate>
{
    AccountsViewController *accountsViewController;
    PositionsViewController *positionsViewController;
    OrdersViewController *ordersViewController;
    TransactionsViewController *transactionsViewController;
}
@end
