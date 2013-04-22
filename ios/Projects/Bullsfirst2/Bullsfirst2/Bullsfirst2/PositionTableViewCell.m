//
//  PositionTableViewCell.m
//  Bullsfirst
//
//  Created by Rashmi Garg on 9/17/12.
//  For storyboard and Bullsfirst2 design
//
//

#import "PositionTableViewCell.h"

@implementation PositionTableViewCell
@synthesize symbolNameLabel;
@synthesize marketValueLabel;

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
