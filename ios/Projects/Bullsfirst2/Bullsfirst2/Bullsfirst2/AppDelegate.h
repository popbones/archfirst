//
//  AppDelegate.h
//  Bullsfirst
//
//  Created by Joe Howard
//  Edited by Rashmi Garg - changes for storyboard and Bullsfirst2 design
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
#import "BFUser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BFUser *currentUser;
    NSMutableArray *accounts;
    NSMutableArray *securities;
    NSMutableArray *externalAccounts;
}
@property (strong, nonatomic) BFUser *currentUser;
@property (strong, nonatomic) NSMutableArray *accounts;
@property (strong, nonatomic) NSMutableArray *securities;
@property (strong, nonatomic) NSMutableArray *externalAccounts;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@end