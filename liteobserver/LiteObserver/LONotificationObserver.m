//
//  LONotificationObserver.m
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import "LONotificationObserver.h"
#import "LOUtil.h"

@implementation LONotificationObserver {
    NSArray *_notificationNames;
    __weak NSObject *_observer;
    void (^_observationBlock)(NSNotification *note);
}

- (instancetype)initWithNotification:(NSString *)notificationName
                            observer:(NSObject *)observer
                    observationBlock:(void (^)(NSNotification *))block {
    if (!notificationName) {
        return nil;
    }
    
    return [self initWithNotifications:@[notificationName]
                              observer:observer
                      observationBlock:block];
}

- (instancetype)initWithNotifications:(NSArray *)notificationNames
                             observer:(NSObject *)observer
                     observationBlock:(void (^)(NSNotification *))block {
    
    if (notificationNames.count == 0 || !observer || !block) {
        return nil;
    }
    
    if ((self = [super init])) {
        _observer = observer;
        [LO_willDeallocDisposable(_observer) addDisposable:self];
        _notificationNames = notificationNames.copy;
        _observationBlock = [block copy];
        
        for (NSString *notificationName in _notificationNames) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(onNotification:)
                                                         name:notificationName
                                                       object:nil];
        }
    }
    return self;
}

//- (void)dealloc {
//#if DEBUG
//    NSLog(@"dealloc %@", self);
//#endif
//}

- (void)dispose {
    if ([super isDisposed]) {
        return;
    }
    
    [super dispose];
    
    [LO_willDeallocDisposable(_observer) removeDisposable:self];
    for (NSString *notificationName in _notificationNames) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:notificationName
                                                      object:nil];
    }
}

- (void)onNotification:(NSNotification *)notification {
    if (_observationBlock) {
        _observationBlock(notification);
    }
}

@end
