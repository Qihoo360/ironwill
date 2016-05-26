//
//  SEJSMethodAsync.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/4/29.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodAsync.h"

@implementation SEJSMethodAsync
{
    NSMutableArray * _calls;
}

- (void)dealloc
{
    // 取消所有正在执行的Call
    for (SEJSCall * call in _calls) {
        [call cancel];
    }
}

- (SEJSCall *)createCall
{
    NSAssert(NO, @"%s not implemented", __PRETTY_FUNCTION__);
    return nil;
}

// 执行接口
// args: 输入参数
- (void)invoke:(id)args responseHandler:(void(^)(id)) responseHandler
{
    SEJSCall * call = [self createCall];
    
    call.input = args;
    call.responseHandler = responseHandler;
    
    call.target = self;
    call.completeSelector = @selector(onJSCallComplete:);
    
    if (_calls == nil) {
        _calls = [[NSMutableArray alloc] init];
    }
    
    if (call != nil) {
        [_calls addObject:call];
        
        [call start];
    }
}

- (void)onJSCallComplete:(SEJSCall *)call
{
    [_calls removeObjectIdenticalTo:call];
    
    // 发给JS
    call.responseHandler(call.output);
}

@end
