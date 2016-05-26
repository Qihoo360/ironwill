//
//  SEJSCall.h
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/4/29.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "Operation/QOperation.h"

// 一次异步调用
@interface SEJSCall : QOperation

// 输入参数
@property (nonatomic, strong) id input;

// 输出参数
@property (nonatomic, strong) id output;

// 返回结果的回调，框架使用
@property (nonatomic, strong) void (^responseHandler)(id);


@end
