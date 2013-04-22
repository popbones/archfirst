//
//  DatePickerViewController.h
//  Bullsfirst
//
//  Created by Pong Choa
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
@class DatePickerViewController;

@protocol DatePickerViewControllerDelegate<NSObject>
- (void)dateSelectionChanged:(DatePickerViewController *)controller;
- (void)datePickerCleared:(DatePickerViewController *) controller;
@end

@interface DatePickerViewController : UIViewController
{
    IBOutlet UIDatePicker* datePicker;
}
- (IBAction)pickerValueChanged:(id)sender;
- (IBAction)doneBTNClicked:(id)sender;
- (IBAction)clearBTNClicked:(id) sender;

@property (retain, nonatomic) UIPopoverController *popOver;
@property (retain, nonatomic) UIDatePicker* datePicker;
@property (weak, nonatomic) id <DatePickerViewControllerDelegate> delegate;
@property (assign, nonatomic) int tag;

@end
