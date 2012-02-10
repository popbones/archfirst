//
//  BFUser.h
//  Bullsfirst
//
//  Created by Pong Choa on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFUser : NSObject {
    NSString *firstName;
    NSString *lastName;
    NSString *userName;
}

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *userName;

+ (BFUser *)userFromJSONData:(NSData *)jsonData;

@end
