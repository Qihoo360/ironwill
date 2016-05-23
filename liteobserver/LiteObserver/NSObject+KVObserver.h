//
//  NSObject+KVObserver.h
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import "LODisposable.h"

@interface NSObject(KVObserver)

- (LODisposable *)observeKeyPath:(NSString *)keyPath
                        onTarget:(NSObject *)target
                         options:(NSKeyValueObservingOptions)options
                observationBlock:(void (^)(NSString *keyPath,
                                           id object,
                                           NSDictionary<NSString *,id> *change))block;

@end
