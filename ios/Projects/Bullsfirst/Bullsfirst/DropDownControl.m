//
//  DropDownControl.m
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

#import "DropDownControl.h"

@implementation DropDownControl
@synthesize responseTarget;
@synthesize label;
@synthesize arrowRect;

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    if (self){
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Dropdown_Strechable.png"]];
        self.multipleTouchEnabled = YES;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, aRect.size.width-10, aRect.size.height-4)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentLeft;
        label.lineBreakMode = UILineBreakModeTailTruncation;
        [self addSubview:label];
        
        arrowRect = CGRectMake(aRect.size.width-26, 0, 32, 32);
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:arrowRect];
        arrow.image = [UIImage imageNamed:@"Dropdown_RightCap.png"];
        [self addSubview:arrow];

        CGRect leftCapRect = CGRectMake(-6, 0, 6, 32);
        UIImageView *leftCap = [[UIImageView alloc] initWithFrame:leftCapRect];
        leftCap.image = [UIImage imageNamed:@"Dropdown_LeftCap.png"];
        [self addSubview:leftCap];

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
