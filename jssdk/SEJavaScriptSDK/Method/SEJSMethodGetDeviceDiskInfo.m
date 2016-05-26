//
//  SEJSMethodGetDeviceDiskInfo.m
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/9.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodGetDeviceDiskInfo.h"
#import <Utils/SysUtils.h>

@implementation SEJSMethodGetDeviceDiskInfo
// 返回接口名
- (NSString *)getName
{
    return @"getDeviceDiskInfo";
}

// 执行接口
- (id)invoke:(id)args
{
    uint64_t total = 0;
    uint64_t avaliable = 0;
    [SysUtils getAvaliSpace:&avaliable andTotalSpace:&total];
    return @{
             @"totalBytes": @(total),
             @"availableBytes": @(avaliable)
             };
}
@end
