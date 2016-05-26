//
//  SEJSMethodStopAudioWithURL.m
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/9.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodStopAudioWithURL.h"

@implementation SEJSMethodStopAudioWithURL

// 返回接口名
- (NSString *)getName
{
    return @"stopAudioWithURL";
}

// 执行接口
- (id)invoke:(id)args
{
    NSString *url = [args objectForKey:@"url"];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onJSMethodStopAudioWithURL:)]) {
        [_delegate onJSMethodStopAudioWithURL:url];
    }
    
    return nil;
}

@end
