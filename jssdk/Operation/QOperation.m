//
//  QOperation.m
//  SystemExpert
//
//  Created by aizhongyuan on 14-7-15.
//  Copyright (c) 2014年 Qihoo. All rights reserved.
//

#import "QOperation.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation QOperation

@synthesize target;
@synthesize completeSelector;
@synthesize error;

- (id)init
{
    self = [super init];
    if (self) {
        _canceled = NO;
    }
    
    return self;
}

// 开始执行操作，异步执行
- (void)start
{
    // do nothing
}

// 开始执行操作，异步执行
- (void)start:(QOperationCompleteBlock)complete
{
    _completeBlock = complete;
    
    [self start];
}

// 取消操作
- (void)cancel
{
    _canceled = YES;
    
    _completeBlock = nil;
}

- (BOOL)isCanceled
{
    return _canceled;
}

// UI线程执行
- (void)completeOperation
{
    if ([self isCanceled] == NO) {
        if (_completeBlock) {
            QOperationCompleteBlock tmpBlock = _completeBlock;
            _completeBlock = nil;
            tmpBlock(self.error);
        } else {
            SuppressPerformSelectorLeakWarning([self.target performSelector: self.completeSelector withObject:self]);
        }
    }
}

- (void)completeOnMainThread
{
    if ([NSThread isMainThread]) {
        [self completeOperation];
    }
    else {
        [self performSelectorOnMainThread:@selector(completeOperation) withObject:nil waitUntilDone:NO];
    }
}

@end
