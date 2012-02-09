/*
    File:       ServerTrustChallengeHandler.m

    Contains:   Handles HTTPS server trust challenges.

    Written by: Pong Choa
 
    Copyright:  Copyright (c) 2011 Sapient. All Rights Reserved.

*/

#import "ServerTrustChallengeHandler.h"
#import "Credentials.h"

@interface ServerTrustChallengeHandler ()

@property (nonatomic, strong, readwrite) UIAlertView *  alertView;

@end

@implementation ServerTrustChallengeHandler

+ (void)registerHandlers
    // Called by the handler registry within ChallengeHandler to request that the 
    // concrete subclass register itself.
{
    [ChallengeHandler registerHandlerClass:[self class] forAuthenticationMethod:NSURLAuthenticationMethodServerTrust];
    
}

- (void)dealloc
{
    assert(self.alertView == nil);
}

#pragma mark * Core code

@synthesize alertView = _alertView;

static SecCertificateRef SecTrustGetLeafCertificate(SecTrustRef trust)
    // Returns the leaf certificate from a SecTrust object (that is always the 
    // certificate at index 0).
{
    SecCertificateRef   result;
    
    assert(trust != NULL);
    
    if (SecTrustGetCertificateCount(trust) > 0) {
        result = SecTrustGetCertificateAtIndex(trust, 0);
        assert(result != NULL);
    } else {
        result = NULL;
    }
    return result;
}

static NSMutableDictionary * sSiteToCertificateMap;     // keys are host names as NSString 
                                                        // values are SecCertificateRef

+ (void)resetTrustedCertificates
{
    // We don't just release the entire array because the _serverTrustResolvedWithSuccess 
    // code assumes that, if execution gets that far, sSiteToCertificateMap is not nil.
    if (sSiteToCertificateMap != nil) {
        [sSiteToCertificateMap removeAllObjects];
    }
}

- (void)_serverTrustResolvedWithSuccess:(BOOL)success rememberSuccess:(BOOL)rememberSuccess
    // Some common code that's called in a variety of places to finally resolve the 
    // challenge.  Also, if rememberSuccess is set, we add an entry for this challenge 
    // into sSiteToCertificateMap so that future challenges can be automatically resolved.
{
    NSURLCredential *   credential;
    
    // ! success && rememberSuccess is a weird combination, but we allow is so 
    // that our clients don't have to jump through too many hoops.
    
    // On succes, create a credential with which to resolve the challenge.

    credential = nil;
    if (success) {
        NSURLProtectionSpace *  protectionSpace;
        SecTrustRef             trust;
        NSString *              host;
        SecCertificateRef       serverCert;

        protectionSpace = [self.challenge protectionSpace];
        assert(protectionSpace != nil);
        
        trust = [protectionSpace serverTrust];
        assert(trust != NULL);
        
        credential = [NSURLCredential credentialForTrust:trust];
        assert(credential != nil);
        
        // If we've been asked to remember the response, do so now.
        
        if (rememberSuccess) {
            assert(sSiteToCertificateMap != nil);
            
            host = [[self.challenge protectionSpace] host];
            assert(host != nil);
            if ( [sSiteToCertificateMap objectForKey:host] == nil ) {

                serverCert = SecTrustGetLeafCertificate(trust);
                if (serverCert != NULL) {
                    [sSiteToCertificateMap setObject:(__bridge id)serverCert forKey:host];
                }
            }
        }
    }

    // Pass the final credential to the base class's stop code (which in turn 
    // tells us to tear down our UI) and then tell our delegate.

    [self stopWithCredential:credential];
    [self.delegate challengeHandlerDidFinish:self];
}

- (void)_evaluateAskPerUntrustedSiteTrust
    // Implements the kDebugOptionsServerValidationAskPerUntrustedSite server trust 
    // validation option.
{
    OSStatus                err;
    NSURLProtectionSpace *  protectionSpace;
    SecTrustRef             trust;
    BOOL                    trusted;
    SecTrustResultType      trustResult;
    SecCertificateRef       previousCert;

    protectionSpace = [self.challenge protectionSpace];
    assert(protectionSpace != nil);
    
    trust = [protectionSpace serverTrust];
    assert(trust != NULL);
    
    // Evaluate the trust the standard way.
    
    err = SecTrustEvaluate(trust, &trustResult);
    trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed) || (trustResult == kSecTrustResultUnspecified));
    
    // If the standard policy says that it's trusted, allow it right now. 
    // Otherwise do our custom magic.
    
    if (trusted) {
        [self _serverTrustResolvedWithSuccess:YES rememberSuccess:NO];
    } else {
        if (sSiteToCertificateMap == nil) {
            sSiteToCertificateMap = [[NSMutableDictionary alloc] init];
            assert(sSiteToCertificateMap != nil);
        }
    
        // Check to see if we've previously seen this server.
        
        previousCert = (__bridge SecCertificateRef) [sSiteToCertificateMap objectForKey:[protectionSpace host]];
        assert( (previousCert == NULL) || (CFGetTypeID(previousCert) == SecCertificateGetTypeID()) );
        
        if (previousCert == NULL) {
            /* if you disallow the user from accepting a untrusted certificate, uncomment this block of code and comment the following block.
            assert(self.alertView == nil);
            self.alertView = [[[UIAlertView alloc] initWithTitle:@"INVALID WEBSITE CERTIFICATE" 
                                                         message:@"THE CERTIFICATE FOR THIS WEBSITE IS INVALID. CAN NOT LOGIN TO THE NETWEORK." 
                                                        delegate:self 
                                               cancelButtonTitle:@"EXIT" 
                                               otherButtonTitles:nil
                               ] autorelease];
            assert(self.alertView != nil);
            [self.alertView show];
             */
            
            /* if you allow the user accepting a untrusted certificate, uncomment this block of code and comment the above block.*/

            SecCertificateRef certificate = SecTrustGetLeafCertificate(trust); 
            NSString* description = (__bridge NSString*)SecCertificateCopySubjectSummary(certificate); 

            NSString *msg = [NSString stringWithFormat:@"THE CERTIFICATE FROM %@ IS INVALID. TAP ACCEPT TO CONNECT.", description];
            // We've not seen this server before.  Ask the user.
            assert(self.alertView == nil);
            self.alertView = [[UIAlertView alloc] initWithTitle:@"ACCEPT WEBSITE CERTIFICATE" 
                                                         message: msg
                                                        delegate:self 
                                               cancelButtonTitle:@"Accept" 
                                               otherButtonTitles:@"Cancel", 
                               nil
                               ];
            assert(self.alertView != nil);
            
            /*******/
            
            [self.alertView show];
            // continues in -alertView:clickedButtonAtIndex:
        } else {
            BOOL                success;
            SecCertificateRef   serverCert;
            
            // We've seen this server before.  Check to see whether the 
            // certificate from the connection matches the certificate 
            // we saw last time.  If so, allow the connection.  If not, 
            // deny the connection.
            
            success = NO;
            serverCert = SecTrustGetLeafCertificate(trust);
            if (serverCert != NULL) {
                CFDataRef       previousCertData;
                CFDataRef       serverCertData;
                
                previousCertData = SecCertificateCopyData(previousCert);
                serverCertData   = SecCertificateCopyData(serverCert  );

                assert(previousCertData != NULL);
                assert(serverCertData   != NULL);
                
                success = CFEqual(previousCertData, serverCertData);
                
                CFRelease(previousCertData);
                CFRelease(serverCertData);
            }
            
            if (success) {
                [self _serverTrustResolvedWithSuccess:YES rememberSuccess:NO];
            } else {
                [self _serverTrustResolvedWithSuccess:NO  rememberSuccess:NO];
            }
        }
    }
}

- (void)_evaluateImportedCertificatesTrust
    // Implements the kDebugOptionsServerValidationTrustImportedCertificates server 
    // trust validation option.
{
    OSStatus                err;
    NSURLProtectionSpace *  protectionSpace;
    SecTrustRef             trust;
    SecTrustResultType      trustResult;
    BOOL                    trusted;
    
    protectionSpace = [self.challenge protectionSpace];
    assert(protectionSpace != nil);
    
    trust = [protectionSpace serverTrust];
    assert(trust != NULL);

    // Evaluate the trust the standard way.
    
    err = SecTrustEvaluate(trust, &trustResult);
    trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed) || (trustResult == kSecTrustResultUnspecified));
    
    // If that fails, apply our certificates as anchors and see if that helps.
    // 
    // It's perfectly acceptable to apply all of our certificates to the SecTrust 
    // object, and let the SecTrust object sort out the mess.  Of course, this assumes 
    // that the user trusts all certificates equally in all situations, which is implicit 
    // in our user interface; you could provide a more sophisticated user interface 
    // to allow the user to trust certain certificates for certain sites and so on).
    
    if ( ! trusted ) {
        err = SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef) [Credentials sharedCredentials].certificates);
        if (err == noErr) {
            err = SecTrustEvaluate(trust, &trustResult);
        }
        trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed) || (trustResult == kSecTrustResultUnspecified));
    }
    
    if (trusted) {
        [self _serverTrustResolvedWithSuccess:YES rememberSuccess:NO];
    } else {
        [self _serverTrustResolvedWithSuccess:NO  rememberSuccess:NO];
    }
}

- (void)_handleServerTrustChallenge
    // Handles a server trust challenge according to the serverValidation debug option. 
    // This is called out of -didStart, and thus can present UI.  However, it may 
    // or not present UI depending on the specific server trust and debug options.
{
    [self _evaluateAskPerUntrustedSiteTrust];
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
    // An alert view delegate callback that's called when the alert is dismissed.  
    // We use the tapped button index to decide how to resolve the challenge.
{
    #pragma unused(alertView)
    assert(alertView == self.alertView);
//    [self _serverTrustResolvedWithSuccess:NO rememberSuccess:YES];
    [self _serverTrustResolvedWithSuccess:(buttonIndex == 0) rememberSuccess:YES];
}

#pragma mark * Override points

- (void)didStart
    // Called by our base class to tell us to create our UI.
{
    [super didStart];
    [self _handleServerTrustChallenge];
}

- (void)willFinish
    // Called by our base class to tell us to tear down our UI.
{
    [super willFinish];
    
    // If an alert is still up, tear it down immediately.
    
    if (self.alertView != nil) {
        self.alertView.delegate = nil;
        [self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:NO];
        self.alertView = nil;
    }
}

@end
