//
//  SEJSMethodOpenURL.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/3/4.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodOpenURL.h"
#import <UIKit/UIKit.h>

@implementation SEJSMethodOpenURL

// 返回接口名
- (NSString *)getName
{
    return @"openURL";
}

// 执行接口
- (id)invoke:(id)args
{
    if (_delegate) {
        return @([_delegate onJSMethodOpenURL:args[@"url"]]);
    }
    
    NSString * url = [args objectForKey:@"url"];
    return @([[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]);
}

@end
