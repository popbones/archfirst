//
//  PositionsSecurityTableViewCell.m
//  Bullsfirst2
//
//  Created by Rashmi Garg on 12/13/12.
//  For storyboard and Bullsfirst2 design
//  Copyright (c) 2012 Rashmi Garg. All rights reserved.
//

#import "PositionsSecurityTableViewCell.h"

@implementation PositionsSecurityTableViewCell
@synthesize symbol, symName, quantity, lastTrade, marketValue, gainPercentage;
@synthesize cellAccessoryImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
