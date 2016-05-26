//
//  SEJSMethodGetAssetsAuthStatus.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/5/21.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodGetAssetsAuthStatus.h"

#import <AssetsLibrary/AssetsLibrary.h>

@implementation SEJSMethodGetAssetsAuthStatus

// 返回接口名
- (NSString *)getName
{
    return @"getAssetsAuthStatus";
}

// 执行接口
- (id)invoke:(id)args
{
    return @([ALAssetsLibrary authorizationStatus]);
}

@end
