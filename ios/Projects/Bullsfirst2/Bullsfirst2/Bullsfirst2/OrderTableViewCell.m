//
//  OrderTableViewCell.m
//  Bullsfirst2
//
//  Created by Rashmi Garg on 1/24/13.
//  Copyright (c) 2013 Rashmi Garg. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell
@synthesize date, time, action, symbol, quantity, price;
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
