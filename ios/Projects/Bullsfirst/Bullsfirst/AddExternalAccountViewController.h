//
//  AddExternalAccountViewController.h
//  Bullsfirst
//
//  Created by suravi on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BullFirstWebServiceObject.h"
@interface AddExternalAccountViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIActivityIndicatorView *spinner;

}

@property (strong, nonatomic) IBOutlet UITextField *accountName;
@property (strong, nonatomic) IBOutlet UITextField *accountNumber;
@property (strong, nonatomic) IBOutlet UITextField *routingNumber;
@property (strong, nonatomic) IBOutlet UIButton *addAccountBTN;
@property (strong, nonatomic) BullFirstWebServiceObject* restServiceObject;

@end
