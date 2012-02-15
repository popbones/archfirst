//
//  editAccountNameBTN.h
//  Bullsfirst
//
//  Created by suravi on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface editAccountNameBTN : UIButton

{
    NSString *currentName;
    NSString *accountID;
    NSInteger *index;
}
@property (nonatomic, retain) NSString *currentName;
@property (nonatomic, retain) NSString *accountID;
@property (nonatomic, assign) NSInteger *index;

@end
