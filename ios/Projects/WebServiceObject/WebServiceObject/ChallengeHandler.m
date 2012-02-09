
/*
    File:       ChallengeHandler.m

    Contains:   Base class for handling various authentication challenges.

    Written by: Pong Choa
 
    Copyright:  Copyright (c) 2011 Sapient. All Rights Reserved.

*/

#import "ChallengeHandler.h"

@interface ChallengeHandler ()
@property (nonatomic, assign, readwrite, getter=isRunning)  BOOL        running;
@end

@implementation ChallengeHandler

static NSMutableDictionary * sAuthenticationMethodToHandlerClassArray;

+ (void)registerHandlers
{
    assert(NO);         // must be overridden by subclass
}

+ (void)registerAllHandlers
{
    // Register all of our support challenge handlers.  There are various ways 
    // you can automate this (objc_getClassList anyone?), but I decided to just 
    // hardwire the classes right now.
    
    static BOOL sHaveRegistered;
    if ( ! sHaveRegistered ) {
        for (NSString * className in [NSArray arrayWithObjects:@"AuthenticationChallengeHandler", @"ServerTrustChallengeHandler", @"ClientIdentityChallengeHandler", nil]) {
            Class   cls;

            cls = NSClassFromString(className);
            assert(cls != nil);
            [cls registerHandlers];
        }
        sHaveRegistered = YES;
    }
}

+ (BOOL)supportsProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    BOOL                result;
    NSString *          authenticationMethod;
    NSMutableArray *    handlerClasses;

    assert(protectionSpace != nil);

    [self registerAllHandlers];

    authenticationMethod = [protectionSpace authenticationMethod];
    assert(authenticationMethod != nil);

    result = NO;
    if (sAuthenticationMethodToHandlerClassArray != nil) {
        handlerClasses = (NSMutableArray *) [sAuthenticationMethodToHandlerClassArray objectForKey:authenticationMethod];
        if (handlerClasses != nil) {
            assert([handlerClasses isKindOfClass:[NSMutableArray class]]);
            result = YES;
        }
    }
    return result;
}

+ (ChallengeHandler *)handlerForChallenge:(NSURLAuthenticationChallenge *)challenge
{
    ChallengeHandler *  result;
    NSString *          authenticationMethod;
    NSMutableArray *    handlerClasses;
    
    assert([NSThread isMainThread]);
    assert(challenge != nil);
    
    [self registerAllHandlers];
    
    authenticationMethod = [[challenge protectionSpace] authenticationMethod];
    assert(authenticationMethod != nil);
    
    result = nil;
    if (sAuthenticationMethodToHandlerClassArray != nil) {
        handlerClasses = (NSMutableArray *) [sAuthenticationMethodToHandlerClassArray objectForKey:authenticationMethod];
        if (handlerClasses != nil) {
            assert([handlerClasses isKindOfClass:[NSMutableArray class]]);
            
            for (Class candidateClass in handlerClasses) {
                result = [[candidateClass alloc] initWithChallenge:challenge];
                if (result != nil) {
                    break;
                }
            }
        }
    }
    return result;
}


+ (void)registerHandlerClass:(Class)handlerClass forAuthenticationMethod:(NSString *)authenticationMethod
{
    NSMutableArray *    handlerClasses;
    
    assert([NSThread isMainThread]);
    assert(handlerClass != nil);
    assert(authenticationMethod != nil);
    
    if (sAuthenticationMethodToHandlerClassArray == nil) {
        sAuthenticationMethodToHandlerClassArray = [[NSMutableDictionary alloc] init];
        assert(sAuthenticationMethodToHandlerClassArray != nil);
    }
    
    handlerClasses = (NSMutableArray *) [sAuthenticationMethodToHandlerClassArray objectForKey:authenticationMethod];
    if (handlerClasses == nil) {
        handlerClasses = [NSMutableArray array];
        assert(handlerClasses != nil);
        
        [sAuthenticationMethodToHandlerClassArray setObject:handlerClasses forKey:authenticationMethod];
    }
    assert([handlerClasses isKindOfClass:[NSMutableArray class]]);
    
    // Don't register the same class twice.  This is necessary because 
    // NSURLAuthenticationMethodDefault and NSURLAuthenticationMethodHTTPBasic both 
    // have the same value, so you end up with AuthenticationChallengeHandler registered 
    // twice for that value.  That doesn't cause problems, but it's unnecessarily 
    // inefficient.
    //
    // It's also makes life easier for our clients as the user switches between 
    // various states, all of which require the same challenge handler.
    
    if ( ! [handlerClasses containsObject:handlerClass] ) {
        [handlerClasses addObject:handlerClass];
    }
}

+ (void)deregisterHandlerClass:(Class)handlerClass forAuthenticationMethod:(NSString *)authenticationMethod
{
    NSMutableArray *    handlerClasses;

    assert(handlerClass != nil);
    assert(authenticationMethod != nil);

    // As a matter of policy we allow clients to deregister stuff they haven't registered.
    // This makes it easier for clients to set up their initial state.
    
    if (sAuthenticationMethodToHandlerClassArray != nil) {
        handlerClasses = (NSMutableArray *) [sAuthenticationMethodToHandlerClassArray objectForKey:authenticationMethod];
        if (handlerClasses != nil) {
            assert([handlerClasses isKindOfClass:[NSMutableArray class]]);
            
            [handlerClasses removeObject:handlerClass];
            
            if (handlerClasses.count == 0) {
                [sAuthenticationMethodToHandlerClassArray removeObjectForKey:authenticationMethod];
            }
        }
    }
}


- (id)initWithChallenge:(NSURLAuthenticationChallenge *)challenge
{
    assert([NSThread isMainThread]);
    
    assert(challenge != nil);
    self = [super init];
    if (self != nil) {
        self->_challenge            = challenge;
    }
    return self;
}


- (void)dealloc
{
    assert( ! self->_running );          // should not still be displaying UI
    assert([NSThread isMainThread]);
}

@synthesize challenge            = _challenge;
@synthesize credential           = _credential;
@synthesize delegate             = _delegate;
@synthesize running              = _running;

- (void)start
{
    assert([NSThread isMainThread]);
    assert( ! self.running );
    self.running = YES;
    [self didStart];
}

- (void)didStart
{
    // this is just an override point
}

- (void)willFinish
{
    // this is just an override point
}

- (void)didFinish
{
    // this is just an override point
}

+ (NSURLCredential *)noCredential
{
    static NSURLCredential * sNoCredential;
    assert([NSThread isMainThread]);
    if (sNoCredential == nil) {
        // The actual values we supply here are irrelevant.  We always use pointer comparison to detect this singleton.
        sNoCredential = [[NSURLCredential alloc] initWithUser:@"" password:@"" persistence:NSURLCredentialPersistenceNone];
        assert(sNoCredential != nil);
    }
    return sNoCredential;
}

- (void)stopWithCredential:(NSURLCredential *)credential
{
    assert([NSThread isMainThread]);
    
    // Allow duplicate cancels to make life easier for our clients.
    
    if (self.running) {
        [self willFinish];
        assert(self->_credential == nil);
        self->_credential = credential;
        self.running = NO;
        [self didFinish];
    }
}

- (void)stop
{
    [self stopWithCredential:nil];
}

- (void)resolve
{
    assert([NSThread isMainThread]);
    assert( ! self.running );
    if (self.credential == nil) {
        [[self.challenge sender] cancelAuthenticationChallenge:self.challenge];
    } else if (self.credential == [ChallengeHandler noCredential]) {
        [[self.challenge sender] continueWithoutCredentialForAuthenticationChallenge:self.challenge];
    } else {
        [[self.challenge sender] useCredential:self.credential forAuthenticationChallenge:self.challenge];
    }
}

@end
