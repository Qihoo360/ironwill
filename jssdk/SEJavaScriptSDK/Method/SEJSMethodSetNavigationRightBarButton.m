//
//  SEJSMethodSetNavigationRightBarButton.m
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/5.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodSetNavigationRightBarButton.h"

@implementation SEJSMethodSetNavigationRightBarButton

// 返回接口名
- (NSString *)getName
{
    return @"setNavigationRightBarButton";
}

// 执行接口
- (id)invoke:(id)args
{
    NSString *title = nil;
    if ([args isKindOfClass:[NSDictionary class]]) {
        title = [args objectForKey:@"title"];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(onJSMethodSetNavigationRightBarButton:)]) {
        [_delegate onJSMethodSetNavigationRightBarButton:title];
    }
    
    return nil;
}

@end
