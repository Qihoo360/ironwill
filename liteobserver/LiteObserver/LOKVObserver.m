//
//  LOKVObserver.m
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import "LOKVObserver.h"
#import "LOUtil.h"

@implementation LOKVObserver {
    __weak NSObject *_target;
    NSString *_keyPath;
    __weak NSObject *_observer;
    void (^_observationBlock)(NSString *keyPath,
                              id object,
                              NSDictionary<NSString *,id> *change);
}

- (instancetype)initWithTarget:(NSObject *)target
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                      observer:(NSObject *)observer
              observationBlock:(void (^)(NSString *,
                                         id,
                                         NSDictionary<NSString *,id> *))block {
    if (!target || !keyPath || !observer || !block) {
        return nil;
    }
    
    if ((self = [super init])) {
        _target = target;
        _keyPath = keyPath.copy;
        _observer = observer;
        _observationBlock = [block copy];
        
        [LO_willDeallocDisposable(_target) addDisposable:self];
        [LO_willDeallocDisposable(_observer) addDisposable:self];
        
        [_target addObserver:self
                  forKeyPath:_keyPath
                     options:options
                     context:(__bridge void * _Nullable)(self)
         ];
    }
    return self;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"dealloc %@", self);
#endif
}

- (void)dispose {
    if ([super isDisposed]) {
        return;
    }
    
    [super dispose];
    
    [_target removeObserver:self
                 forKeyPath:_keyPath
                    context:(__bridge void * _Nullable)(self)];
    [LO_willDeallocDisposable(_target) removeDisposable:self];
    [LO_willDeallocDisposable(_observer) removeDisposable:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([object isEqual:_target]) {
        if (_observationBlock) {
            _observationBlock(keyPath, object, change);
        }
    }
}

@end
