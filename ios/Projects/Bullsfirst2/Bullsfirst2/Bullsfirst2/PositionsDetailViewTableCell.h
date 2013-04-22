//
//  PositionsDetailViewTableCell.h
//  Bullsfirst
//
//  Created by Rashmi Garg on 10/30/12.
//  For storyboard and Bullsfirst2 design
//
//

#import <UIKit/UIKit.h>
#import "expandPositionBTN.h"
#import "tradePositionBTN.h"

@interface PositionsDetailViewTableCell : UITableViewCell


//@property (nonatomic) IBOutlet UILabel *marketValueLBL;
@property (strong, nonatomic) IBOutlet UILabel *lotNumberLBL;
@property (nonatomic) IBOutlet UILabel *quantityLBL;
@property (nonatomic) IBOutlet UILabel *pricePaidLBL;
//@property (nonatomic) IBOutlet UILabel *currentPriceLBL;
//@property (nonatomic) IBOutlet UILabel *gainPercentageLBL;
@property (strong, nonatomic) IBOutlet UILabel *totalCostLBL;

@property (strong, nonatomic) IBOutlet UIButton *tradeButton;
@end
