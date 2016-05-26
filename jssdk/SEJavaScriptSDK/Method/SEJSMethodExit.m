//
//  SEJSMethodExit.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/3/4.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodExit.h"

@implementation SEJSMethodExit

// 返回接口名
- (NSString *)getName
{
    return @"exit";
}

// 执行接口
- (id)invoke:(id)args
{
    if ([self.delegate respondsToSelector:@selector(onJSMethodExit)]) {
        [self.delegate onJSMethodExit];
    }

    
    // 无返回值，返回nil
    return nil;
}

@end
