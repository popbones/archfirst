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

+ (BFUser *)userFromJSONData:(NSData *)data
{
    NSError *err;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    NSLog(@"jsonObject = %@", jsonObject);
    
    NSDictionary* nameObj=(NSDictionary*)jsonObject;
    
    return [[BFUser alloc] initWithName:[nameObj objectForKey:@"firstName"]
                               lastName:[nameObj objectForKey:@"lastName"] 
                               username:[nameObj objectForKey:@"username"]];
}

- (id)initWithName:(NSString *)first lastName:(NSString *)last username:(NSString *)user
{
    self = [super init];
    
    if(self)
    {
        self.firstName = [NSString stringWithString:first];
        self.lastName = [NSString stringWithString:last];
        self.userName = [NSString stringWithString:user];
        
    }
    
    return self;
}


- (id)init
{
    return [[BFUser alloc] initWithName:@""
                               lastName:@"" 
                               username:@""];
}

@end
