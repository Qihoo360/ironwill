//
//  NSObject+LODealloc.m
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import "NSObject+LODealloc.h"
#import "LOMacros.h"
#import "LOUtil.h"

@implementation NSObject(LODealloc)

//LO_PROPERTY_DEFINE(willDeallocDisposable, LODisposable)

- (LODisposable *)lo_willDeallocDisposable {
    return LO_willDeallocDisposable(self);
}

@end
