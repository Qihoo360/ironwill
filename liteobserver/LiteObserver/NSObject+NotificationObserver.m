//
//  NSObject+NotificationObserver.m
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import "NSObject+NotificationObserver.h"
#import "LONotificationObserver.h"
#import "NSObject+LODealloc.h"

@implementation NSObject(NotificationObserver)

- (LODisposable *)observeNotification:(NSString *)notification
                           usingBlock:(void (^)(NSNotification *note))block {
    return [[LONotificationObserver alloc] initWithNotification:notification
                                                       observer:self
                                               observationBlock:block];
}

- (LODisposable *)observeNotifications:(NSArray *)notifications
                            usingBlock:(void (^)(NSNotification *note))block {
    return [[LONotificationObserver alloc] initWithNotifications:notifications
                                                        observer:self
                                                observationBlock:block];
}

@end
