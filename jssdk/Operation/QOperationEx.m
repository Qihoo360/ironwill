//
//  QOperationEx.m
//  Utilities
//
//  Created by aizhongyuan on 14/12/2.
//  Copyright (c) 2014年 aizhongyuan. All rights reserved.
//

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#import "QOperationEx.h"

@implementation QOperationEx

@synthesize stateChangeSelector;

- (void)fireOperationStateChange
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(fireOperationStateChange) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if ([self isCanceled] == NO && self.stateChangeSelector != nil) {
        SuppressPerformSelectorLeakWarning([self.target performSelector: self.stateChangeSelector withObject:self]);
    }
}

@end
