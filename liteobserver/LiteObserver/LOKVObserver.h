//
//  LOKVObserver.h
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import "LODisposable.h"

@interface LOKVObserver : LODisposable

- (instancetype)initWithTarget:(NSObject *)target
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                      observer:(NSObject *)observer
              observationBlock:(void (^)(NSString *keyPath,
                                         id object,
                                         NSDictionary<NSString *,id> *change))block;

@end
