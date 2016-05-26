//
//  SEJSMethodAsync.h
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/4/29.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodBase.h"

#import "SEJSCall.h"

// 异步方法
@interface SEJSMethodAsync : SEJSMethodBase

// 创建Call对象，子类实现
- (SEJSCall *)createCall;

@end
