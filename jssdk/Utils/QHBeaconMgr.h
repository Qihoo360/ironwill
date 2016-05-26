//
//  QHBeaconMgr.h
//  Utilities
//
//  Created by aizhongyuan on 15/8/27.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

// BeconMgr状态
typedef NS_ENUM(NSInteger, QHBeaconMgrState)
{
    QHBeaconMgrStateStopped, // 停止
    QHBeaconMgrStateStartPending, // 启动中
    QHBeaconMgrStateStarted, // 启动完毕
};


@class QHBeaconMgr;

@protocol QHBeaconMgrDelegate <NSObject>

@optional

- (void)didBeaconMgrRangeBeacons:(QHBeaconMgr *)mgr;

- (void)didBeaconMgrRangeError:(QHBeaconMgr *)mgr error:(NSError *)error;

- (void)didBeaconMgrRangeStopped:(QHBeaconMgr *)mgr;

// 发现Beacon，没有beacon-》有beacon
- (void)didBeaconMgrFoundBeacon:(QHBeaconMgr *)mgr;

// 所有beacon消失，没有beacon-》有beacon
- (void)didBeaconMgrMissBeacon:(QHBeaconMgr *)mgr;

// 蓝牙状态变化，通过BTState属性获取具体状态
- (void)didBeaconMgrBTStateChanged:(QHBeaconMgr *)mgr;

@end

@interface QHBeaconMgr : NSObject

// 正在启动Beacon检测
@property (nonatomic, readonly) QHBeaconMgrState state;

// 正在检查蓝牙状态
@property (nonatomic, readonly) BOOL BTStatePending;
// 蓝牙状态
@property (nonatomic, readonly) CBCentralManagerState BTState;

+ (QHBeaconMgr *)getInstance;

// 是否支持Beacon
+ (BOOL)isSupportBeacon;

// 数组中数据类型为CLBeacon
- (NSArray *)getAllBeacons;

// 获取所有beacon的数量
- (NSInteger)getAllBeaconCount;

- (BOOL)addBeaconObserver:(id<QHBeaconMgrDelegate>)observer;

- (BOOL)removeBeaconObserver:(id<QHBeaconMgrDelegate>)observer;

@end
