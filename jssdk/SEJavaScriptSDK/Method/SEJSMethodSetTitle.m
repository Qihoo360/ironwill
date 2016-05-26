//
//  SEJSMethodSetTitle.m
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/5.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodSetTitle.h"

@implementation SEJSMethodSetTitle

// 返回接口名
- (NSString *)getName
{
    return @"setTitle";
}

// 执行接口
- (id)invoke:(id)args
{
    NSString *title = [args objectForKey:@"title"];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onJSMethodSetTitle:)]) {
        [_delegate onJSMethodSetTitle:title];
    }
    
    return nil;
}

@end
