//
//  AccountDropDownTableViewCell.m
//  Bullsfirst2
//
//  Created by Rashmi Garg on 1/16/13.
//  Copyright (c) 2013 Rashmi Garg. All rights reserved.
//

#import "AccountDropDownTableViewCell.h"

@implementation AccountDropDownTableViewCell
@synthesize name, balance;

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
