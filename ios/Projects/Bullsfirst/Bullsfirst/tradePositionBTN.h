//
//  tradePositionBTN.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFPosition.h"

@interface tradePositionBTN : UIButton {
    BFPosition *position;
}
@property (nonatomic, retain) BFPosition *position;

@end
