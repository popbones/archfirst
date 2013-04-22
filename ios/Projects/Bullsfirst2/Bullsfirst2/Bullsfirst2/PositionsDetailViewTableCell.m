//
//  PositionsDetailViewTableCell.m
//  Bullsfirst
//
//  Created by Rashmi Garg on 10/30/12.
//  For storyboard and Bullsfirst2 design
//
//

#import "PositionsDetailViewTableCell.h"

@implementation PositionsDetailViewTableCell
@synthesize lotNumberLBL;
@synthesize quantityLBL;
@synthesize pricePaidLBL, totalCostLBL;

@synthesize tradeButton;



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
