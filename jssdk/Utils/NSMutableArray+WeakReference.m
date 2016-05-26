//
//  NSMutableArray+WeakReference.m
//  360CloudIPhone
//
//  Created by zhongyuan ai on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+WeakReference.h"

@implementation NSMutableArray (WeakReference)

+ (id)mutableArrayUsingWeakReferences {
return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    // We create a weak reference array
    return (__bridge_transfer id)(CFArrayCreateMutable(0, capacity, &callbacks));
}

@end

