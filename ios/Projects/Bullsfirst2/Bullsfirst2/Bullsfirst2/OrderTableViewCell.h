//
//  OrderTableViewCell.h
//  Bullsfirst2
//
//  Created by Rashmi Garg on 1/24/13.
//  Copyright (c) 2013 Rashmi Garg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *action;
@property (strong, nonatomic) IBOutlet UILabel *symbol;
@property (strong, nonatomic) IBOutlet UILabel *quantity;
@property (strong, nonatomic) IBOutlet UILabel *price;

@end
