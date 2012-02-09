/*
    File:       ServerTrustChallengeHandler.h

    Contains:   Handles HTTPS server trust challenges.

    Written by: Pong Choa
 
    Copyright:  Copyright (c) 2011 Sapient. All Rights Reserved.

*/

#import "ChallengeHandler.h"

@interface ServerTrustChallengeHandler : ChallengeHandler
{
    UIAlertView *   _alertView;
}

+ (void)resetTrustedCertificates;

@end
