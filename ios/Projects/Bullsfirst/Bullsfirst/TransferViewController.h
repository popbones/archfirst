//
//  TransferViewController.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BullFirstWebServiceObject.h"
#import "DropdownViewController.h"

@interface TransferViewController : UIViewController <DropdownViewControllerDelegate,UITextFieldDelegate>   
{
    NSNumber *fromAccountID;
    NSNumber *toAccountID;
    IBOutlet UIActivityIndicatorView *spinner;
    bool orientationChanged;
}
@property (nonatomic, retain) UITextField *activeTextField;
@property (nonatomic, retain) NSArray *textFields;

@property (nonatomic,assign) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UIButton *fromAccountBTN;
@property (strong, nonatomic) IBOutlet UIButton *toAccountBTN;
@property (strong, nonatomic) IBOutlet UIButton *transferBTN;
@property (strong, nonatomic) IBOutlet UITextField *amount;
@property (strong, nonatomic) IBOutlet UITextField *symbol;
@property (strong, nonatomic) IBOutlet UITextField *quantity;
@property (strong, nonatomic) IBOutlet UITextField *pricePaid;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *amountLBL;
@property (strong, nonatomic) IBOutlet UILabel *symbolLBL;
@property (strong, nonatomic) IBOutlet UILabel *quantityLBL;
@property (strong, nonatomic) IBOutlet UILabel *pricePaidLBL;
@property (strong, nonatomic) BullFirstWebServiceObject *restServiceObject;
- (IBAction)transferBTNClicked:(id)sender;
- (IBAction)segmentedControlValueChanged:(id)sender;
@property (strong, nonatomic) UIPopoverController *dropdown;
@end
