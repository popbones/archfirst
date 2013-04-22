//
//  WebServiceObject.m
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
#import "WebServiceObject.h"
#import "BFConstants.h"

@interface WebServiceObject ()
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end

@implementation WebServiceObject

@synthesize responseObject, receivedData, loginCredential, responseObjectExited;
@synthesize currentChallenge;

static NSURLCredential * userLogin;

+ (NSURLCredential *)userLoginCredential
{
    assert(userLogin != nil);
    return userLogin;
}

+ (NSURLCredential *)userLoginCredentialWithUsername:(NSString *)usernamae password:(NSString *)password
{
    userLogin = [NSURLCredential credentialWithUser:usernamae password:password persistence:NSURLCredentialPersistenceNone];
    assert(userLogin != nil);
    return userLogin;
}

-(id)initWithObject:(id)successObj responseSelector:(SEL)responseSel receiveDataSelector:(SEL)receiveDataSel successSelector:(SEL)successSel errorSelector:(SEL)errorSel
{
	self = [super init];
	if (self){
		_connection = nil;
		receivedData = [[NSMutableData alloc] initWithLength:0];
		responseObject = successObj;
		responseSelector = responseSel;
		receiveDataSelector = receiveDataSel;
		successSelector = successSel;
		errorSelector = errorSel;
        responseObjectExited = NO;
	}
	return self;
}

-(void)getRequestWithURL:(NSURL*)url
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kRequestTimeout];
    [request setHTTPMethod:@"GET"];

	if (_connection){
		NSLog(@"cancelling connection");
		[_connection cancel];
		_connection = nil;
		[receivedData setLength:0];
	}
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)postRequestWithURL:(NSURL*)url body:(NSData *)body contentType:(NSString *)type
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kRequestTimeout];	
    [request setHTTPMethod:@"POST"];
    [request setValue:type forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:body];

	if (_connection){
		NSLog(@"cancelling connection");
		[_connection cancel];
		_connection = nil;
		[receivedData setLength:0];
	}
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


-(void)requestWithURL:(NSURL*)url
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kRequestTimeout];
	
	if (_connection){
		NSLog(@"cancelling connection");
		[_connection cancel];
		_connection = nil;
		[receivedData setLength:0];
	}
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [receivedData setLength:0];
	
	if ([(NSHTTPURLResponse *)response statusCode] < 400)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        if (responseObject != nil && [responseObject respondsToSelector:responseSelector])
            [responseObject performSelector:responseSelector withObject:response];    
	} else {
		[connection cancel];
		[self connection:connection didFailWithError:[NSError errorWithDomain:@"HTTP Error" code:[(NSHTTPURLResponse *)response statusCode] userInfo:NULL]];
	}
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (responseObjectExited == YES)
        return;
    
    [receivedData appendData:data];
    if (responseObject != nil && [responseObject respondsToSelector:receiveDataSelector])
        [responseObject performSelector:receiveDataSelector withObject:receivedData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseObjectExited == YES)
        return;
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    if (responseObject != nil && [responseObject respondsToSelector:successSelector])
        [responseObject performSelector:successSelector withObject:receivedData];
	
    // release the connection, and the data object
	_connection = nil;
    [receivedData setLength:0];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (responseObjectExited == YES)
        return;
    
    // inform the user
    NSLog(@"URL -> %@", [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
	
	if (responseObject != NULL && errorSelector != NULL){
		
        if ([responseObject respondsToSelector:errorSelector])
            [responseObject performSelector:errorSelector withObject:error];
        
	}else{
		
		NSString *errMsg = [NSString stringWithFormat:@"The attempted request for data has failed. Please try again. If this issue persists, please contact Steve Jobs. (Error: %@)", [error localizedDescription]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request Failed" message:errMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show];
	}
	
	// receivedData is declared as a method instance elsewhere
	_connection = nil;
    [receivedData setLength:0];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark * Authentication challenge

-(void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"didReceiveAuthenticationChallenge %@", [[challenge protectionSpace] authenticationMethod]);
    
    assert(self.currentChallenge == nil);
    if ([challenge previousFailureCount] < 1) {
        self.currentChallenge = [ChallengeHandler handlerForChallenge:challenge];
        if (self.currentChallenge == nil) {
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        } else {
            self.currentChallenge.delegate = self;
            [self.currentChallenge start];
        }
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}


-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    BOOL    result;
    
    result = [ChallengeHandler supportsProtectionSpace:protectionSpace];
    NSLog(@"canAuthenticateAgainstProtectionSpace %@", [protectionSpace authenticationMethod]);
    return result;
	
}


- (void)challengeHandlerDidFinish:(ChallengeHandler *)handler
// Called by the authentication challenge handler once the challenge is 
// resolved.  We twiddle our internal state and then call the -resolve method 
// to apply the challenge results to the NSURLAuthenticationChallenge.
{
#pragma unused(handler)
    ChallengeHandler *  challenge;
    
    assert(handler == self.currentChallenge);
    
    // We want to nil out currentChallenge because we've really done with this 
    // challenge now and, for example, if the next operation kicks up a new 
    // challenge, we want to make sure that currentChallenge is ready to receive 
    // it.
    // 
    // We want the challenge to hang around after we've nilled out currentChallenge, 
    // so retain/autorelease it.
    
    challenge = self.currentChallenge;
    self.currentChallenge = nil;
    
    // If the credential isn't present, this will trigger a -connection:didFailWithError: 
    // callback.
    
    NSLog(@"resolve %@", [[challenge.challenge protectionSpace] authenticationMethod]);
    [challenge resolve];
}



-(void)dealloc
{
    
	if (_connection) {
        [_connection cancel];
    }
    
}






@end
