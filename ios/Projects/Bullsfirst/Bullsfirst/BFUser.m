//
//  BFUser.m
//  Bullsfirst
//
//  Created by Pong Choa on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BFUser.h"

@implementation BFUser
@synthesize firstName, lastName, userName;

+ (BFUser *)userFromJSONData:(NSData *)jsonData
{
    BFUser *user = [[BFUser alloc] init];

    if (user != nil) {
        NSError *err;
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
        NSLog(@"jsonObject = %@", jsonObject);
        
        NSDictionary* nameObj=(NSDictionary*)jsonObject;
        
        user.firstName=[nameObj objectForKey:@"firstName"];
        user.lastName=[nameObj objectForKey:@"lastName"];
        user.userName=[nameObj objectForKey:@"username"];
    }
    return user;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.firstName = @"";
        self.lastName = @"";
        self.userName = @"";
        
    }
    
    return self;
}

@end
