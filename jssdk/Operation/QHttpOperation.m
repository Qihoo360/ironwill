//
//  QHttpOperation.m
//  SystemExpert
//
//  Created by aizhongyuan on 14-7-15.
//  Copyright (c) 2014年 Qihoo. All rights reserved.
//

#import "QHttpOperation.h"
#import "QHttpError.h"

@implementation QHttpOperation

@synthesize parser = _parser;
@synthesize timeout;
@synthesize httpResponse = _httpResponse;

@synthesize progressDelegate;

- (id)init
{
    self = [super init];
    if (self) {
        timeout = 30.0;
        _lastActiveTime = 0;
    }
    
    return self;
}

// 后台线程执行
- (void)doGenerateRequest
{
    // 解决问题：Domain=NSPOSIXErrorDomain Code=12 "The operation couldn’t be completed. Cannot allocate memory"
    @autoreleasepool {
        if ([self isCanceled]) {
            return;
        }
        
        @try {
            NSURLRequest * req = [_parser generateRequest];
        
            // UI主线程中执行sendRequest
            [self performSelectorOnMainThread:@selector(sendRequest:) withObject:req waitUntilDone:NO];
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([self isCanceled]) {
                    return;
                }
                
                self.error = [QHttpError errorInvalidRequest:exception];
                [self completeOperation];
            });
        }
    }
}

// UI线程执行
- (void)sendRequest:(NSMutableURLRequest *)req
{
    // 解决问题：Domain=NSPOSIXErrorDomain Code=12 "The operation couldn’t be completed. Cannot allocate memory"
    @autoreleasepool {
        if ([self isCanceled]) {
            return;
        }
        
        _connection = [NSURLConnection connectionWithRequest:req delegate:self];
        
        NSTimeInterval interval = timeout/3;
        if (timeout < 3.0) {
            interval = timeout;
        }
        // schedule timer
        _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(onTimeout:) userInfo:nil repeats:YES];
        _lastActiveTime = time(0);
        
        [self fireNetworkStarted];
    }
}

// 开始执行操作，异步执行
- (void)start
{
    [_parser prepare];
    
    // 后台线程执行doGenerateRequest
    [self performSelectorInBackground:@selector(doGenerateRequest) withObject:nil];
}

- (void)completeOperation
{
    if (_completeBlock) {
        if ([self isCanceled] == NO) {
            if (self.error) {
                _completeBlock(self.error);
            }
            else {
                _completeBlock(_parser.error);
            }
        }
    }
    else {
        [super completeOperation];
    }
}

- (void)onTimeout:(NSTimer*)theTimer
{
    time_t timeDiff = time(0) - _lastActiveTime;
    if (timeDiff < timeout)
    {
        return;
    }
    
    // 超时错误
    self.error = [QHttpError errorTimeout];
    
    // cancel connection
    [_connection cancel];
    _connection = nil;
    
    // cancel timer
    [_timer invalidate];
    _timer = nil;
    
    [self fireNetworkStopped];
    
    [self completeOperation];
}

// 取消操作
- (void)cancel
{
    [super cancel];
    
    // cancel connection
    if (_connection) {
        [_connection cancel];
        _connection = nil;
        
        // cancel timer
        [_timer invalidate];
        _timer = nil;
        
        [self fireNetworkStopped];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)err
{
    self.error = [QHttpError errorNetwork:err];
    
    _connection = nil;
    
    // cancel timer
    [_timer invalidate];
    _timer = nil;
    
    [self fireNetworkStopped];
    
    [self completeOperation];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)theResponse
{
    _httpResponse = (NSHTTPURLResponse *)theResponse;
    
    if (progressDelegate) {
        if ([progressDelegate respondsToSelector:@selector(didResponseReceived:)]) {
            [progressDelegate didResponseReceived:_httpResponse];
        }
    }
    
    _httpBody = [[NSMutableData alloc] init];
    
    _lastActiveTime = time(0);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_httpBody appendData:data];
    
    _lastActiveTime = time(0);
    
    if (progressDelegate) {
        [progressDelegate didDataReceived:[data length] totalReceivedBytes:[_httpBody length]];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    _lastActiveTime = time(0);
    
    if (progressDelegate) {
        [progressDelegate didDataSended:bytesWritten totalSendedBytes:totalBytesWritten];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([_httpResponse statusCode] != 200) {
        self.error = [QHttpError errorStatus:[_httpResponse statusCode]];
    }
    else {
        
        // 后台线程中解析Response
        [self performSelectorInBackground:@selector(doParseResponse) withObject:nil];
    }
    
    _connection = nil;
    
    // cancel timer
    [_timer invalidate];
    _timer = nil;
    
    [self fireNetworkStopped];
    
    if ([_httpResponse statusCode] != 200) {
        [self completeOperation];
    }
}

// 后台线程执行
- (void)doParseResponse
{
    @autoreleasepool {
        
        if ([self isCanceled]) {
            return;
        }
    
        // parse response
        NSError * theError = nil;
        @try {
            [_parser parseResponse:_httpResponse body:_httpBody];
        }
        @catch (NSException *exception) {
            // invalid response body
            theError = [QHttpError errorInvalidResponse:exception];
        }
        
        // UI线程中执行completeSelector
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([self isCanceled]) {
                return;
            }
            
            self.error = theError;
            [self completeOperation];
        });
    }
}

#pragma mark - NetworkDelegate
- (void)fireNetworkStarted
{
//    if (session.networkDelegate) {
//        [session.networkDelegate didNetworkStarted];
//    }
}

- (void)fireNetworkStopped
{
//    if (session.networkDelegate) {
//        [session.networkDelegate didNetworkStoped];
//    }
}

@end
