//
//  LOUtil.m
//  PhotoSync
//
//  Created by zhangfusheng on 15/12/3.
//  Copyright © 2015年 kelvin@163.com. All rights reserved.
//

#import "LOUtil.h"
#import "LOMacros.h"
#import "LODisposable.h"
#import "LONotificationObserver.h"
#import "LOKVObserver.h"

@implementation LOUtil {
    __weak NSObject *_observer;
}

+ (instancetype)utilForObserver:(NSObject *)observer {
    LOUtil *util = [[LOUtil alloc] init];
    util->_observer = observer;
    return util->_observer ? util : nil;
}

- (LODisposable *)observeKeyPath:(NSString *)keyPath
                        onTarget:(NSObject *)target
                         options:(NSKeyValueObservingOptions)options
                observationBlock:(void (^)(NSString *,
                                           id,
                                           NSDictionary<NSString *,id> *))block {
    return [[LOKVObserver alloc] initWithTarget:target
                                        keyPath:keyPath
                                        options:options
                                       observer:_observer
                               observationBlock:block];
}

- (LODisposable *)observeNotification:(NSString *)notification
                           usingBlock:(void (^)(NSNotification *note))block {
    return [[LONotificationObserver alloc] initWithNotification:notification
                                                       observer:_observer
                                               observationBlock:block];
    
}

- (LODisposable *)observeNotifications:(NSArray *)notifications
                            usingBlock:(void (^)(NSNotification *note))block {
    return [[LONotificationObserver alloc] initWithNotifications:notifications
                                                        observer:_observer
                                                observationBlock:block];
}

LO_OBJECT_PROPERTY_DEFINE(willDeallocDisposable, LODisposable)

- (LODisposable *)lo_willDeallocDisposable {
    return LO_OBJECT_PROPERTY_GET(LOUtil, _observer, willDeallocDisposable);
}

@end
