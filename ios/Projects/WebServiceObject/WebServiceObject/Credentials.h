/*
    File:       Credentials.h

    Contains:   A model object for credentials.

    Written by: Pong Choa
 
    Copyright:  Copyright (c) 2011 Sapient. All Rights Reserved.
*/

#include <Security/Security.h>

@interface Credentials : NSObject
{
    NSMutableArray *        _identities;
    NSMutableArray *        _certificates;
}

@property (nonatomic, copy, readonly) NSArray *     identities;     // sorted by subject summary of certificate
@property (nonatomic, copy, readonly) NSArray *     certificates;   // sorted by subject summary; does not include certificates 
                                                                    // that are part of an identity

// identities and certificates are observable

+ (Credentials *)sharedCredentials;
    // Returns a singleton object for use by clients.

- (void)refresh;
    // Causes a rebuild of the identities and certificates properties.  Call this 
    // after you've done something that modifies the keychain.
    //
    // Also called by the CredentialsController when the user taps Refresh Credentials. 

- (void)resetCredentials;
    // Called by the CredentialsController when the user taps Reset Credentials. 
    // Nukes all the credentials in our keychain so that we start from green fields. 
    // Calls refresh internally.

- (void)dumpCredentials;
    // Called by the CredentialsController when the user taps Dump Credentials. 
    // Prints the credentials in our keychain.

@end
