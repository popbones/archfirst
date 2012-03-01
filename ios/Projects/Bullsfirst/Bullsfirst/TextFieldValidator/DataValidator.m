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
        
        textFields = [[NSMutableArray alloc]init];
        isAlreadyEntered=[[NSMutableArray alloc]init];
         validIconFileNames=[[NSMutableArray alloc]init];
         invalidIconFileNames=[[NSMutableArray alloc]init];
    }
    return self;
}


-(void) removeHintView
{
    if(isHintViewDisplayed)
    {
        [hintView dismissAnimated:NO];
    }
    isHintViewDisplayed = NO;
}

-(void) displayHintViewForTextField:(UITextField*)textField withStatus:(NSString*)errorString
{
    [self removeHintView];
    isHintViewDisplayed = YES;
    hintView.message = errorString;
    [hintView presentPointingAtView:textField inView:textField.superview animated:NO];
}

-(void) textEditStart:(UITextField*) textField
{
    
    NSString* status=[delegate validationStatusForTextField:textField];
    int index=[textFields indexOfObject:textField];
    if(status == nil)
    {
        textField.rightViewMode = UITextFieldViewModeNever;
        [self removeHintView];
        if([[isAlreadyEntered objectAtIndex:index] isEqual:@"1"])
        {
            UIImageView* rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[validIconFileNames objectAtIndex:index]]];
            rightView.frame = CGRectMake(textField.bounds.origin.x+textField.bounds.size.width-20, textField.bounds.origin.y, 32, textField.bounds.size.height-4);
            textField.rightView = rightView;
            textField.rightViewMode = UITextFieldViewModeAlways;
        }
    }
    else
    {
        
        if([[isAlreadyEntered objectAtIndex:index] isEqual:@"1"] )
        {
            if(status==kStringFieldIsEmpty)
            {
            [self displayHintViewForTextField:textField withStatus:status];
            UIImageView* rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[invalidIconFileNames objectAtIndex:index]]];
            rightView.frame = CGRectMake(textField.bounds.origin.x+textField.bounds.size.width-20, textField.bounds.origin.y, 32, textField.bounds.size.height-4);
            textField.rightView = rightView;
            textField.rightViewMode = UITextFieldViewModeAlways;
            }
        }
        else
        {
            [isAlreadyEntered replaceObjectAtIndex:index withObject:@"1"];
        }
        for(int i=0;i<textFields.count;i++)
        {
            NSLog(@"%@ dsfafdas %@",[textFields objectAtIndex:i],[isAlreadyEntered objectAtIndex:i]);
        }
    }
}


-(bool) validationSucceeded
{
    bool valStatus = YES;
    for (UITextField* textField in textFields) 
    {
        if([delegate validationStatusForTextField:textField]!=nil)
        {
            //textField.rightViewMode= UITextFieldViewModeAlways;
            valStatus = NO;
        }
        else
        {
           // textField.rightViewMode= UITextFieldViewModeNever;
        }
    }
    return valStatus;
}


-(void) textEditOver:(UITextField*) textField
{
    NSString* status=[delegate validationStatusForTextField:textField];
    int index=[textFields indexOfObject:textField];
    if(status == nil)
    {
//        textField.rightViewMode = UITextFieldViewModeNever;
//        [self removeHintView];
//    }
//    else if([status isEqual:kStringFieldValid])
//    {
        
        UIImageView* rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[validIconFileNames objectAtIndex:index]]];
        rightView.frame = CGRectMake(textField.bounds.origin.x+textField.bounds.size.width-20, textField.bounds.origin.y, 32, textField.bounds.size.height-4);
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;    
    }
    else
    {
        UIImageView* rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[invalidIconFileNames objectAtIndex:index]]];
        rightView.frame = CGRectMake(textField.bounds.origin.x+textField.bounds.size.width-20, textField.bounds.origin.y, 32, textField.bounds.size.height-4);
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;
        [self displayHintViewForTextField:textField withStatus:status];
    }
    [delegate formValidationSucceeded:[self validationSucceeded]];
    [self removeHintView];
}

-(void) textChange:(UITextField*) textField
{
    
    NSString* status=[delegate validationStatusForTextField:textField];
    int index=[textFields indexOfObject:textField];
    if(status == nil)
    {
//        textField.rightViewMode = UITextFieldViewModeNever;
//        [self removeHintView];
//    }
//    else if([status isEqual:kStringFieldValid])
//    {
    
        UIImageView* rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[validIconFileNames objectAtIndex:index]]];
        rightView.frame = CGRectMake(textField.bounds.origin.x+textField.bounds.size.width-20, textField.bounds.origin.y, 32, textField.bounds.size.height-4);
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;    
        [self removeHintView];
    }
    else
    {
        UIImageView* rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[invalidIconFileNames objectAtIndex:index]]];
        rightView.frame = CGRectMake(textField.bounds.origin.x+textField.bounds.size.width-20, textField.bounds.origin.y, 32, textField.bounds.size.height-4);
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;
        [self displayHintViewForTextField:textField withStatus:status];
    }
    [delegate formValidationSucceeded:[self validationSucceeded]];

}




-(void) processTextField:(UITextField*)textField rightViewValidIconFileName:(NSString*)validIconName rightViewInvalidIconFileName:(NSString*)invalidIconName  errorStringOnNoEntry:(NSString*) errorString
{
    [textFields addObject:textField];
//    UIImageView* rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:invalidIconName]];
//    rightView.frame = CGRectMake(textField.bounds.origin.x+textField.bounds.size.width-20, textField.bounds.origin.y, 32, textField.bounds.size.height-4);
//    textField.rightView = rightView;
//    textField.rightViewMode = UITextFieldViewModeNever;
    [validIconFileNames addObject:validIconName];
    [invalidIconFileNames addObject:invalidIconName];
    [textField addTarget:self action:@selector(textEditOver:) forControlEvents:UIControlEventEditingDidEnd];
    [textField addTarget:self action:@selector(textEditStart:) forControlEvents:UIControlEventEditingDidBegin];
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void) processTextFields:(NSArray*)textFieldsfromFile rightViewValidIconFileName:(NSString*)validIconName rightViewInvalidIconFileName:(NSString*)invalidIconName  errorStringOnNoEntry:(NSString*) errorString
{
    [textFields removeAllObjects];
    for (UITextField* textField in textFieldsfromFile) 
    {
        [textFields addObject:textField];
        [isAlreadyEntered addObject:@"0"];
//        UIImageView* rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:invalidIconName]];
//        rightView.frame = CGRectMake(textField.bounds.origin.x+textField.bounds.size.width-20, textField.bounds.origin.y, 32, textField.bounds.size.height-4);
//        textField.rightView = rightView;
//        textField.rightViewMode = UITextFieldViewModeNever;
        [validIconFileNames addObject:validIconName];
        [invalidIconFileNames addObject:invalidIconName];
        
        
        [textField addTarget:self action:@selector(textEditOver:) forControlEvents:UIControlEventEditingDidEnd];
        [textField addTarget:self action:@selector(textEditStart:) forControlEvents:UIControlEventEditingDidBegin];
        [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
   
    
}


@end

