//
//  expandPositionBTN.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface expandPositionBTN : UIButton {
    int row;
    NSIndexPath *indexPath;
}
@property (nonatomic, assign) int row;
@property (nonatomic, retain) NSIndexPath *indexPath;

@end
