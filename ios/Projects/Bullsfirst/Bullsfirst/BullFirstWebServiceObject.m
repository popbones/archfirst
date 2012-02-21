//
//  BullFirstWebServiceObject.m
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

#import "BullFirstWebServiceObject.h"
#import "NSData+Base64.h"

@implementation BullFirstWebServiceObject

-(void)getRequestWithURL:(NSURL*)url
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kRequestTimeout];
    [request setHTTPMethod:@"GET"];
    
     NSURLCredential *credential = [WebServiceObject userLoginCredential];
     NSString *authStr = [NSString stringWithFormat:@"%@:%@", credential.user, credential.password];
     NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
     NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]];
     [request setValue:authValue forHTTPHeaderField:@"Authorization"];
         
    
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
    NSURLCredential *credential = [WebServiceObject userLoginCredential];
    [request setValue:credential.password forHTTPHeaderField:@"password"];
	
	if (_connection){
		NSLog(@"cancelling connection");
		[_connection cancel];
		_connection = nil;
		[receivedData setLength:0];
	}
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

@end
