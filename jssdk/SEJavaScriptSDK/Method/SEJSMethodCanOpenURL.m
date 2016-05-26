//
//  SEJSMethodCanOpenURL.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/3/3.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodCanOpenURL.h"
#import <UIKit/UIKit.h>

@implementation SEJSMethodCanOpenURL

// 返回接口名
- (NSString *)getName
{
    return @"canOpenURL";
}

// 执行接口
- (id)invoke:(id)args
{
    NSString * url = [args objectForKey:@"url"];
    return @([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]);
}

@end
