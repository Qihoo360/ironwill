//
//  SEJSMethodOnPlayAudioEnd.m
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/9.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodOnPlayAudioEnd.h"

@implementation SEJSMethodOnPlayAudioEnd

// 返回接口名
- (NSString *)getName
{
    return @"onPlayAudioEnd";
}

// 执行接口
- (id)invoke:(id)args
{
//    NSString *methodName = args objectForKey:@"
    if (_delegate && [_delegate respondsToSelector:@selector(onJSMethodOnPlayAudioEnd:)]) {
        [_delegate onJSMethodOnPlayAudioEnd:nil];
    }
    
    return nil;
}

@end
