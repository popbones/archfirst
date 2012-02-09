//
//  webService.h
//  SapientViewer
//
//  Created by Pong Choa on 6/6/11.
//  Copyright 2011 Sapient Nitro Inc. All rights reserved.
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
