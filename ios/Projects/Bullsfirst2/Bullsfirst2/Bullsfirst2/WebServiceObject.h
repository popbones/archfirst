//
//  WebServiceObject.h
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
#import <Foundation/Foundation.h>
#import "ChallengeHandler.h"

@interface WebServiceObject : NSObject <ChallengeHandlerDelegate>{
    
    NSMutableData *receivedData;
    NSURLConnection *_connection;
    NSURLCredential *loginCredential;
    id responseObject;
    SEL responseSelector;
    SEL receiveDataSelector;
    SEL successSelector;
    SEL errorSelector;

    BOOL responseObjectExited;
}

@property (nonatomic, assign) BOOL responseObjectExited;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLCredential *loginCredential;
@property (nonatomic, strong, readwrite) ChallengeHandler *currentChallenge;


-(id)initWithObject:(id)successObj responseSelector:(SEL)responseSel receiveDataSelector:(SEL)receiveDataSel successSelector:(SEL)successSel errorSelector:(SEL)errorSel;
-(void)requestWithURL:(NSURL *)url;
-(void)getRequestWithURL:(NSURL*)url;
-(void)postRequestWithURL:(NSURL*)url body:(NSData *)body contentType:(NSString *)type;

+ (NSURLCredential *)userLoginCredentialWithUsername:(NSString *)usernamae password:(NSString *)password;
+ (NSURLCredential *)userLoginCredential;


@end
