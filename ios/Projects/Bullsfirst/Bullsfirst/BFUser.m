//
//  BFUser.m
//  Bullsfirst
//
//  Created by Pong Choa
//  Copyright 2012 Archfirst
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
