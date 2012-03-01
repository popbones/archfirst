//
//  DropDownControl.h
//  Bullsfirst
//
//  Created by Pong Choa on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DropDownControl : UIView <UIGestureRecognizerDelegate> {
    id responseTarget;
    SEL responseSelector;
    UILabel *label;
}

@property (nonatomic, strong) id responseTarget;
@property (nonatomic, strong) UILabel *label;

- (void)addTarget:(id)target action:(SEL)action;
- (id)initWithFrame:(CGRect)aRect target:(id)target action:(SEL)action;

@end
