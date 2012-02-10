//
//  LoginViewController.h
//  Bullsfirst
//
//  Created by Joe Howard
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
#import "OpenAccountViewController.h"
#import "UITextField+Padding.h"

@class BullFirstWebServiceObject;

@interface LoginViewController : UIViewController
<NSURLConnectionDelegate,UITextFieldDelegate,OpenAccountViewControllerDelegate>
{
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UIActivityIndicatorView *spinner;
    NSURLConnection *urlConnection;
    NSMutableData *jsonResponseData;
    OpenAccountViewController *openAccountViewController;
    UIDeviceOrientation orientation;
    IBOutlet UIView *groupedView;
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIButton *openAccountButton;
    
}

@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UITextField *password;
@property (strong, nonatomic) BullFirstWebServiceObject *restService;

- (IBAction)login:(id)sender;
- (IBAction)openAccount:(id)sender;

- (void)logout;
@end
