//
//  DropDownControl.m
//  Bullsfirst
//
//  Created by Pong Choa on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DropDownControl.h"

@implementation DropDownControl
@synthesize responseTarget;
@synthesize label;

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    if (self){
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ModalView_TitleBar_BackgroundGradient.jpg"]];
        self.multipleTouchEnabled = YES;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, aRect.size.width-10, aRect.size.height-4)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentLeft;
        [self addSubview:label];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(aRect.size.width-32, 0, 32, 32)];
        arrow.image = [UIImage imageNamed:@"img_bg_yellow.png"];
        [self addSubview:arrow];
        
        responseTarget = nil;
    }
    return self;
}

- (id)initWithFrame:(CGRect)aRect target:(id)target action:(SEL)action
{
    self = [self initWithFrame:aRect];
    if (self) {
        [self addTarget:target action:action];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    responseTarget = target;
    responseSelector = action;

}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    if (responseTarget != nil && [responseTarget respondsToSelector:responseSelector])
        [responseTarget performSelector:responseSelector withObject:self];    
}


@end
