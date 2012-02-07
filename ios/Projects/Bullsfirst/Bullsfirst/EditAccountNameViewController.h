//
//  EditAccountNameViewController.h
//  Bullsfirst
//
//  Created by Vivekan Arther
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


@class AccountsViewController;
@class BullFirstWebServiceObject;

@interface EditAccountNameViewController : UIViewController
{
    IBOutlet UITextField *accountName;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UIButton *editAccountButton;
    IBOutlet UIButton *cancelButton;
    NSString* oldAccountName;
    
    
    NSURLConnection *urlConnection;
    NSMutableData *jsonResponseData;

    __weak AccountsViewController *avc;
    
}

@property (nonatomic, weak) AccountsViewController *avc;
@property (strong, nonatomic) BullFirstWebServiceObject* restServiceObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil oldAccountName:(NSString*) oldAccName;

- (IBAction)editAccountButtonClicked:(id)sender;
- (IBAction)cancel:(id)sender;
@end
