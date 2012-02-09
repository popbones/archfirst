/*
    File:       AuthenticationChallengeHandler.m

    Contains:   Handles HTTP authentication challenges.

    Written by: Pong Choa

    Copyright:  Copyright (c) 2011 Sapient. All Rights Reserved.

*/

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
