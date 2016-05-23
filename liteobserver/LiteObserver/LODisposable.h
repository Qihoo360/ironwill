//
//  LODisposable.h
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LODisposable : NSObject

- (BOOL)isDisposed;
- (void)dispose;
- (void)addDisposable:(LODisposable *)disposable;
- (void)removeDisposable:(LODisposable *)disposable;

+ (instancetype)disposableWithBlock:(void (^)())disposeBlock;

@end
