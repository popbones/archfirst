//
//  OrderBTN.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFOrder.h"

@interface OrderBTN : UIButton {
    BFOrder *order;
}
@property (nonatomic, retain) BFOrder *order;

@end
