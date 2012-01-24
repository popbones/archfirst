//
//  OpenAccountViewController.h
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

@class LoginViewController;

@interface OpenAccountViewController : UIViewController
{
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UITextField *confirmpassword;
    IBOutlet UIActivityIndicatorView *spinner;
    
    NSURLConnection *urlConnection;
    NSMutableData *jsonResponseData;
    
    __weak LoginViewController *lvc;
}

@property (nonatomic, weak) LoginViewController *lvc;

- (IBAction)createAccount:(id)sender;
- (IBAction)cancel:(id)sender;

@end
