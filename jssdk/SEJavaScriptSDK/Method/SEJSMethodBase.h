//
//  SEJSMethodBase.h
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/4/28.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

// 抽象SDK接口类
@interface SEJSMethodBase : NSObject

// 返回接口名
- (NSString *)getName;

// 执行接口，子类实现
// args: 输入参数
- (void)invoke:(id)args responseHandler:(void(^)(id)) responseHandler;

@end
