//
//  NSObject+KVObserver.m
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import "NSObject+KVObserver.h"
#import "LOKVObserver.h"

@implementation NSObject(KVObserver)

- (LODisposable *)observeKeyPath:(NSString *)keyPath
                        onTarget:(NSObject *)target
                         options:(NSKeyValueObservingOptions)options
                observationBlock:(void (^)(NSString *,
                                           id,
                                           NSDictionary<NSString *,id> *))block {
    
    return [[LOKVObserver alloc] initWithTarget:target
                                        keyPath:keyPath
                                        options:options
                                       observer:self
                               observationBlock:block];
}

@end
