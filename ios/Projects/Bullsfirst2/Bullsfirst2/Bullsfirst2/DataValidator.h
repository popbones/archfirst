//
//  DataValidator.h
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

#import <Foundation/Foundation.h>
#import "CMPopTipView.h"


//Used by the DataValidator to know the error status of the UITextField.
@protocol DataValidatorProtocol <NSObject>

@required
// should return nil on passing the validation checks.
// should return the error string on failing the validation checks.
-(NSString*) validationStatusForTextField:(UITextField*) textField;

//informs the user controller of any change in the error status
-(void) formValidationSucceeded:(bool) status;

@end

@interface DataValidator : NSObject
{
    __weak id<DataValidatorProtocol> delegate;
    CMPopTipView* hintView;
    bool isHintViewDisplayed;
    NSMutableArray *textFields;
    NSMutableArray *isAlreadyEntered;
    NSMutableArray *validIconFileNames;
    NSMutableArray *invalidIconFileNames;
}

@property (weak, nonatomic) id<DataValidatorProtocol> delegate;
-(void) processTextField:(UITextField*)textField rightViewValidIconFileName:(NSString*)validIconName rightViewInvalidIconFileName:(NSString*)invalidIconName  errorStringOnNoEntry:(NSString*) errorString;

-(void) processTextFields:(NSArray*)textFields rightViewValidIconFileName:(NSString*)validIconName rightViewInvalidIconFileName:(NSString*)invalidIconName  errorStringOnNoEntry:(NSString*) errorString;
@end
