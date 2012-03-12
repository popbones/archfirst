//
//  DatePickerViewController.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
