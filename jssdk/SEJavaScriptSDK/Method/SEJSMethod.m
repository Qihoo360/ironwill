//
//  SEJSMethod.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/3/2.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethod.h"

@implementation SEJSMethod

// 执行接口，子类实现
// args: 输入参数
- (void)invoke:(id)args responseHandler:(void(^)(id)) responseHandler
{
    id result = [self invoke:args];
    if (result != nil) {
        responseHandler(result);
    }
}

// 执行接口
- (id)invoke:(id)args
{
    NSAssert(NO, @"%s not implemented", __PRETTY_FUNCTION__);
    return nil;
}

@end
