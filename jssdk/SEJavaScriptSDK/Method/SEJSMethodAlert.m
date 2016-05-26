//
//  SEJSMethodAlert.m
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/11.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodAlert.h"
#import <UIKit/UIKit.h>
#import <Utils/NSSafeAddition.h>

@implementation SEJSMethodAlert

// 返回接口名
- (NSString *)getName
{
    return @"alert";
}

// 执行接口
- (id)invoke:(id)args
{
    NSString *title = [[args objectForKey:@"title"] safeStringValue];
    NSString *msg = [[args objectForKey:@"msg"] safeStringValue];
    NSString *cancel_title = [[args objectForKey:@"cancel_title"] safeStringValue];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancel_title otherButtonTitles:nil, nil];
    [alert show];
    
    return nil;
}


@end
