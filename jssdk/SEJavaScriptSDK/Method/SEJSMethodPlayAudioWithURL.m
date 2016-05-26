//
//  SEJSMethodPlayAudioWithURL.m
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/9.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodPlayAudioWithURL.h"

@implementation SEJSMethodPlayAudioWithURL

// 返回接口名
- (NSString *)getName
{
    return @"playAudioWithURL";
}

// 执行接口
- (id)invoke:(id)args
{
    NSString *url = [args objectForKey:@"url"];
    int loops = [[args objectForKey:@"loops"] intValue];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onJSMethodPlayAudioWithURL:loops:)]) {
        [_delegate onJSMethodPlayAudioWithURL:url loops:loops];
    }
    
    return nil;
}

@end
