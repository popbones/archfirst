//
//  AccountTableViewCell.m
//  Bullsfirst
//
//  Created by Rashmi Garg
//  For storyboard and Bullsfirst2 design
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
//  Added for iPhone changes, the Accounts screen has table and each cell is
//  a custom cell of type AccountTableViewCell
//
#import "AccountTableViewCell.h"

@implementation AccountTableViewCell


@synthesize accountName;
@synthesize marketValue, gainPercentage, cash;
@synthesize editButton;
@synthesize indexPath;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//Layout our fields in case of a layoutchange (fix for iPad doing strange things with margins if width is > 400)
- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect origFrame = self.contentView.frame;
	if (accountName.text != nil) {
        UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
        {
            
            accountName.frame = CGRectMake(origFrame.origin.x+10, origFrame.origin.y, 188, origFrame.size.height-1);
            marketValue.frame = CGRectMake(origFrame.origin.x+195, origFrame.origin.y, origFrame.size.width-100, origFrame.size.height-1);
            editButton.frame = CGRectMake(origFrame.origin.x+390, origFrame.origin.y+10, origFrame.size.width-410, origFrame.size.height-15);
		
        }
        else
        {
            accountName.frame = CGRectMake(origFrame.origin.x+10, origFrame.origin.y, 120, origFrame.size.height-1);
            marketValue.frame = CGRectMake(origFrame.origin.x+125, origFrame.origin.y, origFrame.size.width-140, origFrame.size.height-1);
            editButton.frame = CGRectMake(origFrame.origin.x+240, origFrame.origin.y+10, origFrame.size.width-260, origFrame.size.height-15);
            
        }
	} else {
		accountName.hidden = YES;
		NSInteger imageWidth = 0;
		if (self.imageView.image != nil) {
			imageWidth = self.imageView.image.size.width + 5;
		}
		marketValue.frame = CGRectMake(origFrame.origin.x+imageWidth+10, origFrame.origin.y, origFrame.size.width-imageWidth-20, origFrame.size.height-1);
        editButton.frame = CGRectMake(origFrame.origin.x+100, origFrame.origin.y, origFrame.size.width-10, origFrame.size.height-1);
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end