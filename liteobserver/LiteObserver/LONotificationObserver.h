//
//  LONotificationObserver.h
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import "LODisposable.h"

@interface LONotificationObserver : LODisposable

- (instancetype)initWithNotification:(NSString *)notificationName
                            observer:(NSObject *)observer
                    observationBlock:(void (^)(NSNotification *note))block;

- (instancetype)initWithNotifications:(NSArray *)notificationNames
                             observer:(NSObject *)observer
                     observationBlock:(void (^)(NSNotification *note))block;

@end
