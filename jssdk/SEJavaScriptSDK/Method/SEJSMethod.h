//
//  SEJSMethod.h
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/3/2.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodBase.h"

// 同步方法
@interface SEJSMethod : SEJSMethodBase

// 执行接口
// args: 输入参数
// retrun: 返回值，返回nil表示无返回值
- (id)invoke:(id)args;

@end
