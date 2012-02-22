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
#import "DataValidator.h"

@class LoginViewController;
@class BullFirstWebServiceObject;

@interface OpenAccountViewController : UIViewController<UITextFieldDelegate,DataValidatorProtocol>
{
    
    //to keep track of the responses being received from the server
    enum { CreateNewBFAccount, CreateNewBrokerageAccount, CreateExternalAccount, TransferAmount} currentProcess;
    
    
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UITextField *confirmpassword;
    
    IBOutlet UILabel *firstNameLBL;
    IBOutlet UILabel *lastNameLBL;
    IBOutlet UILabel *usernameLBL;
    IBOutlet UILabel *passwordLBL;
    IBOutlet UILabel *confirmPasswordFirstPartLBL;
    IBOutlet UILabel *confirmPasswordSecondPartLBL;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIActivityIndicatorView *spinner;
    
    IBOutlet UIButton* openAccountButton;
    IBOutlet UIBarButtonItem* cancelButton;
    
    NSURLConnection *urlConnection;
    NSMutableData *jsonResponseData;
    
    NSNumber* newBrokerageAccountId;
    NSNumber* newExternalAccountId;
    
    DataValidator* validator;
    
    IBOutlet UINavigationBar* navBar;
    
}


@property (strong, nonatomic) BullFirstWebServiceObject* restServiceObject;
@property (nonatomic, retain) UITextField *activeTextField;
@property (nonatomic, retain) NSArray *textFields;

- (IBAction)openAccountButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end

@protocol OpenAccountViewControllerDelegate <NSObject>
-(void) newBFAccountCreated:(NSString*) fullName;
@end


