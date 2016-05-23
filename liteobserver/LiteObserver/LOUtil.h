//
//  LOUtil.h
//  PhotoSync
//
//  Created by zhangfusheng on 15/12/3.
//  Copyright © 2015年 kelvin@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LODisposable;

@interface LOUtil : NSObject

+ (instancetype)utilForObserver:(NSObject *)observer;

- (LODisposable *)observeKeyPath:(NSString *)keyPath
                        onTarget:(NSObject *)target
                         options:(NSKeyValueObservingOptions)options
                observationBlock:(void (^)(NSString *keyPath,
                                           id object,
                                           NSDictionary<NSString *,id> *change))block;

- (LODisposable *)observeNotification:(NSString *)notification
                           usingBlock:(void (^)(NSNotification *note))block;

- (LODisposable *)observeNotifications:(NSArray *)notifications
                            usingBlock:(void (^)(NSNotification *note))block;

- (LODisposable *)lo_willDeallocDisposable;

@end

#define LO_Observer(object) \
    [LOUtil utilForObserver:object]

#define LO_willDeallocDisposable(object) \
    [LO_Observer(object) lo_willDeallocDisposable]
