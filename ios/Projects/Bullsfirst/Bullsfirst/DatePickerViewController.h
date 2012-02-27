//
//  DatePickerViewController.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatePickerViewController;

@protocol DatePickerViewControllerDelegate
- (void)selectionChanged:(DatePickerViewController *)controller;
@end

@interface DatePickerViewController : UIViewController
{
    IBOutlet UIDatePicker* datePicker;
}
- (IBAction)pickerValueChanged:(id)sender;
- (IBAction)doneBTNClicked:(id)sender;

@property (retain, nonatomic) UIPopoverController *popOver;
@property (weak, nonatomic) id <DatePickerViewControllerDelegate> delegate;
@property (retain, nonatomic) NSString *dateInRequiredFormat;

@end
