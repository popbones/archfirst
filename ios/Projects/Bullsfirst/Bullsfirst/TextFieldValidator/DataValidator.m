//
//  DataValidator.m
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

#import "DataValidator.h"

@implementation DataValidator
@synthesize delegate;

-(id)init
{
    self = [super init];
    if(self)
    {
        hintView = [[CMPopTipView alloc] init];
        hintView.backgroundColor = [UIColor whiteColor];
        hintView.textColor = [UIColor blackColor];
        hintView.disableTapToDismiss = YES;
        isHintViewDisplayed = NO;
        
        textFieldStatuses = [[NSMutableDictionary alloc]init];
        
    }
    return self;
}


-(void) textEditStart:(UITextField*) textField
{
    
    NSString* status=[delegate validationStatusForTextField:textField];
    if(hintView  && status)
    {
            hintView.message = [delegate validationStatusForTextField:textField];
            isHintViewDisplayed = YES;
            [hintView presentPointingAtView:textField.rightView inView:textField.superview animated:NO];
    }
}


-(bool) validationSucceeded
{
    for (UITextField* textField in textFieldStatuses) {
        id object = [textFieldStatuses objectForKey:textField];
        if(object != [NSNull null])
            return NO;
    }
    return YES;
}


-(void) textEditOver:(UITextField*) textField
{
    NSString* status=[delegate validationStatusForTextField:textField];
    if(hintView && isHintViewDisplayed == YES)
    {
        isHintViewDisplayed = NO;
        [hintView dismissAnimated:NO];
    }
    if(status==nil)
    {
        textField.rightViewMode = UITextFieldViewModeNever;
        [textFieldStatuses setObject:[NSNull null] forKey:textField];
    }
    else
    {
        textField.rightViewMode = UITextFieldViewModeAlways;
        [textFieldStatuses setObject:status forKey:textField];
    }
    [delegate formValidationSucceeded:[self validationSucceeded]];
}

-(void) textChange:(UITextField*) textField
{
    NSString* status=[delegate validationStatusForTextField:textField];
    if(status==nil)
    {
        textField.rightViewMode = UITextFieldViewModeNever;
        [textFieldStatuses setObject:[NSNull null] forKey:textField];
        if(hintView && isHintViewDisplayed == YES)
        {
            isHintViewDisplayed = NO;
            [hintView dismissAnimated:NO];
        }
    }
    else
    {
        textField.rightViewMode = UITextFieldViewModeAlways;
        [textFieldStatuses setObject:status forKey:textField];
        if(hintView)
        {
            hintView.message = [delegate validationStatusForTextField:textField];

            if(isHintViewDisplayed == YES)
            {
                [hintView dismissAnimated:NO];
                isHintViewDisplayed=NO;
            }
            isHintViewDisplayed = YES;
            [hintView presentPointingAtView:textField.rightView inView:textField.superview animated:NO];
        }

    }
    [delegate formValidationSucceeded:[self validationSucceeded]];

}



-(void) processTextField:(UITextField*)textField rightViewIconFileName:(NSString*)iconName errorStringOnNoEntry:(NSString*) errorString
{
    if([textFieldStatuses objectForKey:textField]!=nil)
    {
        [textFieldStatuses removeObjectForKey:textField];
    }
    
    [textFieldStatuses setObject:errorString forKey:textField];
    UIImageView* rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconName]];
    rightView.frame = CGRectMake(textField.bounds.origin.x+textField.bounds.size.width-20, textField.bounds.origin.y, 32, textField.bounds.size.height-4);
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeNever;
    
    [textField addTarget:self action:@selector(textEditOver:) forControlEvents:UIControlEventEditingDidEnd];
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingDidBegin];
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
}


@end

