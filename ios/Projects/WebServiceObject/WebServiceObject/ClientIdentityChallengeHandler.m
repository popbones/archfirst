/*
    File:       ClientIdentityChallengeHandler.m

    Contains:   Handles HTTPS client identity challenges.

    Written by: Pong Choa
 
    Copyright:  Copyright (c) 2011 Sapient. All Rights Reserved.

*/

/**********
 How to create the Certificate.p12
 
 The certificate.p12 is the idententy of an individual or an application in the
 2 factor mutual authentication. To create the .p12 file.
 
 1. Import both the private and public key from a key issuing authority into the OSX keychain.
 2. In keychain, select "all item" in "category". Select both the private and public key in 
    the keychain by holding down the command key.
 3. File->Export items,  select .p12 format. If you change the file name from default name 
    "Certificate.p12", remember to change the name in "_bringUpView". keychain also prompt 
    a password for the .p12 file. Enter a password and put the password in "extractIdentityAndTrust"
 4. Add the resulting .p12 file in the project.
 
 **********/

#import "ClientIdentityChallengeHandler.h"
#import "Credentials.h"

@interface ClientIdentityChallengeHandler ()

OSStatus extractIdentityAndTrust(CFDataRef inPKCS12Data,
                                 SecIdentityRef *outIdentity,
                                 SecTrustRef *outTrust);

@end

@implementation ClientIdentityChallengeHandler

+ (void)registerHandlers
    // Called by the handler registry within ChallengeHandler to request that the 
    // concrete subclass register itself.
{
    [ChallengeHandler registerHandlerClass:[self class] forAuthenticationMethod:NSURLAuthenticationMethodClientCertificate];
}

OSStatus extractIdentityAndTrust(CFDataRef inPKCS12Data,
                                 SecIdentityRef *outIdentity,
                                 SecTrustRef *outTrust)

{
    OSStatus securityError = errSecSuccess;
    CFStringRef password = CFSTR("test123");    
    
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(
                                                           NULL, keys,
                                                           values, 1,
                                                           NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    securityError = SecPKCS12Import(inPKCS12Data,
                                    optionsDictionary,
                                    &items);
    if (securityError == 0) {                                 
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust,
                                             kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    }
        
    if (optionsDictionary)
        CFRelease(optionsDictionary);                          
    
    return securityError;
}

- (void)_clientIdentityResolvedWithIdentity:(SecIdentityRef)identity
    // Some common code that's called in a variety of places to finally 
    // resolve the challenge.
{
    // identity may be NULL
    NSURLCredential *           credential;

    // If we got an identity, create a credential for that identity.
    
    credential = nil;
    if (identity != NULL) {
        NSURLCredentialPersistence  persistence;

        persistence = NSURLCredentialPersistenceForSession;
        // assert(persistence >= NSURLCredentialPersistenceNone);   -- not necessary because NSURLCredentialPersistence is unsigned
        assert(persistence <= NSURLCredentialPersistencePermanent);
        
        credential = [NSURLCredential credentialWithIdentity:identity certificates:nil persistence:persistence];
        assert(credential != nil);
    }
    
    // Pass the final credential to the base class's stop code (which in turn 
    // tells us to tear down our UI) and then tell our delegate.
    
    [self stopWithCredential:credential];
    [self.delegate challengeHandlerDidFinish:self];
}

- (void)_bringUpView
    // Displays the authentication user interface.  
{
    NSArray *   identities;

    identities = [Credentials sharedCredentials].identities;
    assert(identities != nil);

    NSString *thePath = [[NSBundle mainBundle]
                         pathForResource:@"Certificate" ofType:@"p12"];
    
    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:thePath];
    
    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
    OSStatus status = noErr;
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    
    status = extractIdentityAndTrust(
                                     inPKCS12Data,
                                     &myIdentity,
                                     &myTrust);
    
    if (status == 0)
        [self _clientIdentityResolvedWithIdentity:myIdentity];
}

#pragma mark * Override points

- (void)didStart
    // Called by our base class to tell us to create our UI.
{
    [super didStart];
    [self _bringUpView];
}

- (void)willFinish
    // Called by our base class to tell us to tear down our UI.
{
    [super willFinish];
}

@end
