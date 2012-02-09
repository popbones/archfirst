/*
    File:       AuthenticationChallengeHandler.h

    Contains:   Handles HTTP authentication challenges.

    Written by: Pong Choa
 
    Copyright:  Copyright (c) 2011 Sapient. All Rights Reserved.

*/

#import "ChallengeHandler.h"

@class AuthenticationController;

@interface AuthenticationChallengeHandler : ChallengeHandler
{
    AuthenticationController *  _viewController;
    BOOL                        _didEnterCredential;
}

@end
