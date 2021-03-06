//
//  AddAccountViewController.h
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

#import <Foundation/Foundation.h>

@class BullFirstWebServiceObject;

@interface AddAccountViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIButton *closeButton;
    IBOutlet UITextField *accountName;
    //IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UINavigationBar *navbar;
    IBOutlet UIButton *addAccountButton;
    IBOutlet UIButton *cancelButton;
}

@property (strong, nonatomic) BullFirstWebServiceObject* restServiceObject;

- (IBAction)addAccountButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;

@end
