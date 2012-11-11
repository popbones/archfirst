//
//  LearnToTradeViewController.h
//  Bullsfirst
//
//  Created by pong choa on 11/10/12.
//
//

#import <UIKit/UIKit.h>
#import "PDFScrollView.h"

@interface LearnToTradeViewController : UIViewController

@property (strong, nonatomic) PDFScrollView *pdf;

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)recognizer;


@end
