//
//  SEJSMethodGetBatteryState.m
//  SystemExpert
//
//  Created by aizhongyuan on 15/5/11.
//  Copyright (c) 2015年 Qihoo. All rights reserved.
//

#import "SEJSMethodGetBatteryState.h"

#import <UIKit/UIKit.h>

@implementation SEJSMethodGetBatteryState

// 返回接口名
- (NSString *)getName
{
    return @"getBatteryState";
}

// 执行接口
- (id)invoke:(id)args
{
    UIDevice * device = [UIDevice currentDevice];
    
    return @{
             @"state": @(device.batteryState),
             @"level": @(device.batteryLevel)
             };
}

@end
