//
//  SEJSCallGetBeaconList.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/11/6.
//  Copyright © 2015年 aizhongyuan. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "SEJSCallGetBeaconList.h"

#import <Utils/QHBeaconMgr.h>

@interface SEJSCallGetBeaconList () <QHBeaconMgrDelegate>

@end

@implementation SEJSCallGetBeaconList

// 开始执行操作，异步执行
- (void)start
{
    if ([self tryGetBeaconList]) {
        return;
    }
    
    // 监控BeaconMgr状态变化
    [[QHBeaconMgr getInstance] addBeaconObserver:self];
}

// 取消操作
- (void)cancel
{
    [super cancel];
}

#pragma mark - QHBeaconMgrDelegate

- (void)didBeaconMgrRangeBeacons:(QHBeaconMgr *)mgr
{
    [self tryGetBeaconList];
}

- (void)didBeaconMgrRangeError:(QHBeaconMgr *)mgr error:(NSError *)error
{
    [self tryGetBeaconList];
}

- (void)didBeaconMgrRangeStopped:(QHBeaconMgr *)mgr
{
    // do nothing
}

// 发现Beacon，没有beacon-》有beacon
- (void)didBeaconMgrFoundBeacon:(QHBeaconMgr *)mgr
{
    // do nothing
}

// 所有beacon消失，没有beacon-》有beacon
- (void)didBeaconMgrMissBeacon:(QHBeaconMgr *)mgr
{
    // do nothing
}

// 蓝牙状态变化，通过BTState属性获取具体状态
- (void)didBeaconMgrBTStateChanged:(QHBeaconMgr *)mgr
{
    [self tryGetBeaconList];
}

- (BOOL)tryGetBeaconList
{
    QHBeaconMgr * mgr = [QHBeaconMgr getInstance];
    assert(mgr.state != QHBeaconMgrStateStopped);
    
    if (mgr.state == QHBeaconMgrStateStartPending || mgr.BTStatePending) {
        return NO;
    }
    
    // 全部启动完毕
    switch ([CLLocationManager authorizationStatus]) {
        default:
            // 定位服务未启动
            self.output = @{@"error":@(JSGetBeaconList_LocationNotEnable)};
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            switch (mgr.BTState) {
                case CBCentralManagerStateUnknown:
                    self.output = @{@"error":@(JSGetBeaconList_Other)};
                    break;
                    
                case CBCentralManagerStateResetting:
                    self.output = @{@"error":@(JSGetBeaconList_Other)};
                    break;
                    
                case CBCentralManagerStateUnsupported:
                    self.output = @{@"error":@(JSGetBeaconList_NotSupport)};
                    break;
                    
                case CBCentralManagerStateUnauthorized:
                    self.output = @{@"error":@(JSGetBeaconList_LocationNotEnable)};
                    break;
                    
                case CBCentralManagerStatePoweredOff:
                    self.output = @{@"error":@(JSGetBeaconList_BlueToothNotEnable)};
                    break;
                    
                case CBCentralManagerStatePoweredOn:
                {
                    // 获取beacon信息
                    NSArray * beacons = [mgr getAllBeacons];
                    NSMutableArray * beaconsArray = [NSMutableArray array];
                    for (CLBeacon *beacon in beacons)
                    {
                        NSDictionary * beaconDict =
                        @{
                          @"uuid" : [beacon.proximityUUID UUIDString],
                          @"major" : beacon.major,
                          @"minor" : beacon.minor,
                          @"distance" : @(beacon.accuracy),
                          };
                        [beaconsArray addObject:beaconDict];
                    }
                    
                    self.output = @{@"error":@(JSGetBeaconList_Success), @"beacons":beaconsArray};
                }
                    break;
                    
                default:
                    self.output = @{@"error":@(JSGetBeaconList_Other)};
                    break;
            }
            break;
    }
    
    [mgr removeBeaconObserver:self];
    
    [self completeOnMainThread];
    
    return YES;
}

@end
