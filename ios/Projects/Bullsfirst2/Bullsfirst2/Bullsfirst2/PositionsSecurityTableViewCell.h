//
//  PositionsSecurityTableViewCell.h
//  Bullsfirst2
//
//  Created by Rashmi Garg on 12/13/12.
//  For storyboard and Bullsfirst2 design
//  Copyright (c) 2012 Rashmi Garg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionsSecurityTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *symbol;
@property (strong, nonatomic) IBOutlet UILabel *symName;
@property (strong, nonatomic) IBOutlet UILabel *quantity;
@property (strong, nonatomic) IBOutlet UILabel *lastTrade;
@property (strong, nonatomic) IBOutlet UILabel *marketValue;
@property (strong, nonatomic) IBOutlet UILabel *gainPercentage;
@property (strong, nonatomic) IBOutlet UIImageView *cellAccessoryImageView;
@end
