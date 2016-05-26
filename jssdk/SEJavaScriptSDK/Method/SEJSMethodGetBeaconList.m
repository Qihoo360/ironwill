//
//  SEJSMethodGetBeaconList.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/11/6.
//  Copyright © 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodGetBeaconList.h"

#import "SEJSCallGetBeaconList.h"

#import <Utils/QHBeaconSmartMgr.h>

@implementation SEJSMethodGetBeaconList
{
    QHBeaconSmartMgr * _beaconSmartMgr;
}

// 返回接口名
- (NSString *)getName
{
    return @"getBeaconList";
}

- (SEJSCall *)createCall
{
    if (_beaconSmartMgr == nil) {
        // 启动BeaconMgr
        // SEJSMethodGetBeaconList释放的时候，自动停止
        _beaconSmartMgr = [[QHBeaconSmartMgr alloc] initWithDelegate:nil];
    }
    
    return [[SEJSCallGetBeaconList alloc] init];
}

// 执行接口
// args: 输入参数
- (void)invoke:(id)args responseHandler:(void(^)(id)) responseHandler
{
    if ([QHBeaconMgr isSupportBeacon]) {
        // 支持beacon，使用JSCall执行
        [super invoke:args responseHandler:responseHandler];
    }
    else {
        // 不支持beacon，直接返回错误
        if (responseHandler) {
            responseHandler(@{@"error":@(JSGetBeaconList_NotSupport)});
        }
    }
}

@end
