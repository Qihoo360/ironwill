//
//  LODisposable.m
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import "LODisposable.h"

@interface LODisposable() {
    void (^_disposeBlock)();
    BOOL _disposed;
    NSMutableSet *_disposables;
}

@end

@implementation LODisposable

+ (instancetype)disposableWithBlock:(void (^)())disposeBlock {
    LODisposable *disposable = [[LODisposable alloc] init];
    disposable->_disposeBlock = [disposeBlock copy];
    return disposable;
}

- (void)dealloc {
    [self dispose];
}

- (BOOL)isDisposed {
    @synchronized(self) {
        return _disposed;
    }
}

- (void)dispose {
    NSSet *disposables = nil;
    @synchronized(self) {
        if (_disposed) {
            return;
        }
        _disposed = YES;
        disposables = _disposables.copy;
    }
    
    for (LODisposable *disposable in disposables) {
        [disposable dispose];
    }
    
    if (_disposeBlock) {
        _disposeBlock();
    }
}

- (void)addDisposable:(LODisposable *)disposable {
    if (!disposable) {
        return;
    }
    
    @synchronized(self) {
        if (!_disposables) {
            _disposables = [NSMutableSet set];
        }
        [_disposables addObject:disposable];
        if (_disposed) {
            [disposable dispose];
        }
    }
}

- (void)removeDisposable:(LODisposable *)disposable {
    if (!disposable) {
        return;
    }
    
    @synchronized(self) {
        [_disposables removeObject:disposable];
    }
}

@end
