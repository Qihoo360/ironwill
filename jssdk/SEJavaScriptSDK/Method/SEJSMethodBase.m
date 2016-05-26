//
//  SEJSMethodBase.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/4/28.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodBase.h"

@implementation SEJSMethodBase

// 返回接口名
- (NSString *)getName
{
    NSAssert(NO, @"%s not implemented", __PRETTY_FUNCTION__);
    return nil;
}

// 执行接口
// args: 输入参数
- (void)invoke:(id)args responseHandler:(void(^)(id)) responseHandler
{
    NSAssert(NO, @"%s not implemented", __PRETTY_FUNCTION__);
}

@end
