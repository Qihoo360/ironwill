//
//  SEJSMethodGetNetworkStatus.m
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/5.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodGetNetworkStatus.h"
#import <UIKit/UIKit.h>
#import <Utils/SysUtils.h>
#import <Utils/Reachability.h>

typedef enum {
    kNoNetwork = 0,
    kWifi = 1,
    k2G = 2,
    k3G = 3,
    k4G = 4,
    kUnknownWWAN = 9,
    kUnknown = -1,
}__SEJSNetworkStatus;

@implementation SEJSMethodGetNetworkStatus

// 返回接口名
- (NSString *)getName
{
    return @"getNetworkStatus";
}

// 执行接口
- (id)invoke:(id)args
{
    
    return @{@"networkType":@([self currentNetworkStatus])};
}

- (__SEJSNetworkStatus)currentNetworkStatus {
    __SEJSNetworkStatus status = kUnknown;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    switch ([reachability currentReachabilityStatus]) {
        case ReachableViaWiFi:
            status = kWifi;
            break;
        case NotReachable:
            status = kNoNetwork;
            break;
        case ReachableViaWWAN:
        {
            QHMobileGeneration mg = [SysUtils GetMobileGenerationNumber];
            switch (mg) {
                case QHMobile2G: // 2G
                    status = k2G;
                    break;
                case QHMobile3G: // 3G
                    status = k3G;
                    break;
                case QHMobile4G: // 4G
                    status = k4G;
                    break;
                default: // unknown
                    status = kUnknownWWAN;
                    break;
            }
        }
            break;
        default:
            status = kUnknown;
            break;
    }
    
    return status;
}

@end
