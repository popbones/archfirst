//
//  AuthenticationChallengeHandler.m
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

#import "AuthenticationChallengeHandler.h"
#import "WebServiceObject.h"

@implementation AuthenticationChallengeHandler

+ (void)registerHandlers
    // Called by the handler registry within ChallengeHandler to request that the 
    // concrete subclass register itself.
{
    [ChallengeHandler registerHandlerClass:[self class] forAuthenticationMethod:NSURLAuthenticationMethodDefault];
    [ChallengeHandler registerHandlerClass:[self class] forAuthenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    [ChallengeHandler registerHandlerClass:[self class] forAuthenticationMethod:NSURLAuthenticationMethodHTTPDigest];
    [ChallengeHandler registerHandlerClass:[self class] forAuthenticationMethod:NSURLAuthenticationMethodNTLM];
}


#pragma mark * View management

- (void)_gotCredential:(NSURLCredential *)credential
// Called by one of the two AuthenticationController delegate callbacks when the user 
// taps Cancel or Log In.  We tell the base class to stop (which in turn 
// tells us to tear down our UI) and then we tell our delegate.
{
    // credential may be nil
    [self stopWithCredential:credential];
    [self.delegate challengeHandlerDidFinish:self];
}

#pragma mark * Override points

- (void)didStart
    // Called by our base class to tell us to create our UI.
{
    [super didStart];
    NSURLCredential *credential = [WebServiceObject userLoginCredential];
    [self _gotCredential:credential];
}

- (void)willFinish
    // Called by our base class to tell us to tear down our UI.
{
    [super willFinish];
}

@end
