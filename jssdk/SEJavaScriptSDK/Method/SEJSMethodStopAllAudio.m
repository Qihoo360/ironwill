//
//  SEJSMethodStopAllAudio.m
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/9.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodStopAllAudio.h"

@implementation SEJSMethodStopAllAudio

// 返回接口名
- (NSString *)getName
{
    return @"stopAllAudio";
}

// 执行接口
- (id)invoke:(id)args
{
    if (_delegate && [_delegate respondsToSelector:@selector(onJSMethodStopAllAudio)]) {
        [_delegate onJSMethodStopAllAudio];
    }
    
    return nil;
}

@end
