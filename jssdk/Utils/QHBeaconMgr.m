//
//  QHBeaconMgr.m
//  Utilities
//
//  Created by aizhongyuan on 15/8/27.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "QHBeaconMgr.h"

#import <CoreLocation/CoreLocation.h>

#import <Utils/SysUtils.h>
#import <Utils/NSMutableArray+WeakReference.h>

static NSString * const kIdentifier = @"360SystemExpert";

static NSArray * g_sBeaconUUIDs = nil;

@interface QHBeaconMgr () <CLLocationManagerDelegate, CBCentralManagerDelegate>

@end

@implementation QHBeaconMgr
{
    NSInteger _startCounter;
    
    CLLocationManager * _locationManager;
    NSArray * _beaconRegions;
    
    NSMutableArray * _observers;
    
    NSMutableDictionary * _beacons;
    
    CBCentralManager * _centralMgr;
    
    // 启动中的BeaconUUID
    // value是计数器，计数器初始化为2，当计数器变为0时，状态变为QHBeaconMgrStateStarted
    NSMutableDictionary<NSUUID *, NSNumber *> * _startingUUIDs;
}

@synthesize BTStatePending;
@synthesize BTState;

- (QHBeaconMgrState)state
{
    if (_startCounter == 0) {
        return QHBeaconMgrStateStopped;
    }
    
    if (_startingUUIDs.count == 0) {
        return QHBeaconMgrStateStarted;
    }
    else {
        return QHBeaconMgrStateStartPending;
    }
}

+ (void)initialize
{
    g_sBeaconUUIDs = @[
                     @"701D1040-084A-466A-A67E-11C7BBF4D316", // 360
                     @"FDA50693-A4E2-4FB1-AFCF-C6EB07647825", // 微信
                     ];
}

+ (NSArray *)getBeaconUUIDs
{
    return g_sBeaconUUIDs;
}

+ (QHBeaconMgr *)getInstance
{
    static QHBeaconMgr * instance = nil;
    if (instance == nil) {
        instance = [[QHBeaconMgr alloc] init];
    }
    return instance;
}

// 是否支持Beacon
+ (BOOL)isSupportBeacon
{
    if ([SysUtils getIOSVersion] < __IPHONE_7_0) {
        return NO;
    }
    
    if (![CLLocationManager isRangingAvailable]) {
        return NO;
    }
    
    return YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _observers = [NSMutableArray mutableArrayUsingWeakReferences];
        _beacons = [NSMutableDictionary dictionary];
        
        BTState = CBCentralManagerStateUnknown;
    }
    return self;
}

#pragma mark - Beacon ranging

- (BOOL)turnOnRanging:(NSArray *)uuids identifier:(NSString *)identifier
{
    NSMutableArray * beaconRegions = [NSMutableArray array];
    _startingUUIDs = [NSMutableDictionary dictionary];
    
    NSInteger i = 0;
    for (NSString * uuid in uuids) {
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
        NSString * strId = [identifier stringByAppendingFormat:@"_%zd", i++];
        CLBeaconRegion * region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:strId];
        [beaconRegions addObject:region];
        
        // 保存UUID，计数器初始化为2，每检测到一次，计数器减去1，计数器为0时，从_startingUUIDs中删除
        _startingUUIDs[proximityUUID] = @(2);
        
        [_locationManager startRangingBeaconsInRegion:region];
    }
    
    _beaconRegions = beaconRegions;
    
    return YES;
}

- (BOOL)startRanging
{
    // 先检查是否支持Beacon
    if ([QHBeaconMgr isSupportBeacon] == NO) {
        return NO;
    }
    
    ++_startCounter;
    
    if (_startCounter == 1) {
        [self doStartRanging];
    }
    
    return YES;
}

- (BOOL)doStartRanging
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if ([SysUtils getIOSVersion] >= __IPHONE_8_0) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    
    [self turnOnRanging:g_sBeaconUUIDs identifier:kIdentifier];
    
    if ([SysUtils getIOSVersion] >= __IPHONE_7_0) {
        _centralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@(NO)}];
    }
    else {
        _centralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    BTStatePending = YES;
    
    return YES;
}

- (BOOL)stopRanging
{
    // 先检查是否支持Beacon
    if ([QHBeaconMgr isSupportBeacon] == NO) {
        return NO;
    }
    
    assert(_startCounter > 0);
    
    --_startCounter;
    if (_startCounter == 0) {
        [self doStopRanging];
    }
    
    return YES;
}

- (BOOL)doStopRanging
{
    _locationManager.delegate = nil;
    for (CLBeaconRegion * region in _beaconRegions) {
        [_locationManager stopRangingBeaconsInRegion:region];
    }
    
    _startingUUIDs = nil;
    
    BTState = CBCentralManagerStateUnknown;
    
    [self fireDidBeaconMgrRangeStopped];
    
    @synchronized(_beacons) {
        [_beacons removeAllObjects];
    }
    
    _centralMgr.delegate = nil;
    _centralMgr = nil;
    
    return YES;
}

// 数组中数据类型为CLBeacon
- (NSArray *)getAllBeacons
{
    NSMutableArray * allBeacons = [NSMutableArray array];
    
    @synchronized(_beacons) {
        for (NSUUID * uuid in _beacons) {
            [allBeacons addObjectsFromArray:_beacons[uuid]];
        }
    }
    
    return allBeacons;
}

// 获取所有beacon的数量
- (NSInteger)getAllBeaconCount
{
    NSInteger count = 0;
    
    @synchronized(_beacons) {
        for (NSUUID * uuid in _beacons) {
            count += [_beacons[uuid] count];
        }
    }
    
    return count;
}

- (void)tryRemoveStartingUUID:(NSUUID *)uuid beacons:(NSArray *)beacons
{
    if (beacons.count > 0) {
        // 发现beacon，直接删除，忽略计数器
        [_startingUUIDs removeObjectForKey:uuid];
        return;
    }
    
    NSNumber * objCounter = _startingUUIDs[uuid];
    if (objCounter == nil) {
        return;
    }
    
    NSInteger newCounter = [objCounter integerValue] - 1;
    if (newCounter <= 0) {
        // 计数器为0，删除
#ifdef DEBUG
        NSLog(@"%s startingUUID counter is zero, remove is.", __PRETTY_FUNCTION__);
#endif
        [_startingUUIDs removeObjectForKey:uuid];
    }
    else {
        // 计数器不为0，继续保留
#ifdef DEBUG
        NSLog(@"%s startingUUID counter is not zero, hold is.", __PRETTY_FUNCTION__);
#endif
        _startingUUIDs[uuid] = @(newCounter);
    }
}

#pragma mark - Beacon ranging delegate methods

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
#ifdef DEBUG
    NSLog(@"%s %@", __PRETTY_FUNCTION__, beacons);
#endif
    
    if (_startCounter <= 0) {
        return;
    }
    
    // 尝试删除startingUUID
    [self tryRemoveStartingUUID:region.proximityUUID beacons:beacons];
    
    BOOL preEmpty = YES;
    BOOL afterEmpty = YES;
    
    @synchronized(_beacons) {
        preEmpty = ([_beacons count] == 0);
        
        if ([beacons count] == 0) {
            [_beacons removeObjectForKey:region.proximityUUID];
        }
        else {
            _beacons[region.proximityUUID] = beacons;
        }
        
        afterEmpty = ([_beacons count] == 0);
    }
        
    [self fireDidBeaconMgrRangeBeacons];
    
    if (preEmpty) {
        if (afterEmpty) {
            // do nothing
        }
        else {
            // 无beacon-》有beacon
            [self fireDidBeaconMgrFoundBeacon];
        }
    }
    else {
        if (afterEmpty) {
            // 有beacon-》无beacon
            [self fireDidBeaconMgrMissBeacon];
        }
        else {
            // do nothing
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
#endif
    
    if (_startCounter <= 0) {
        return;
    }
    
    // 尝试删除startingUUID
    [self tryRemoveStartingUUID:region.proximityUUID beacons:nil];
    
    BOOL preEmpty = YES;
    BOOL afterEmpty = YES;
    
    @synchronized(_beacons) {
        preEmpty = ([_beacons count] == 0);
        
        if (region == nil) {
            [_beacons removeAllObjects];
        }
        else {
            [_beacons removeObjectForKey:region.proximityUUID];
        }
        
        afterEmpty = ([_beacons count] == 0);
    }
    
    [self fireBeaconMgrRangeError:error];
    
    if (preEmpty) {
        if (afterEmpty) {
            // do nothing
        }
        else {
            // 无beacon-》有beacon
            [self fireDidBeaconMgrFoundBeacon];
        }
    }
    else {
        if (afterEmpty) {
            // 有beacon-》无beacon
            [self fireDidBeaconMgrMissBeacon];
        }
        else {
            // do nothing
        }
    }
}

#pragma mark - Observer

- (BOOL)addBeaconObserver:(id<QHBeaconMgrDelegate>)observer
{
    if ([_observers indexOfObjectIdenticalTo:observer] != NSNotFound) {
        // 已经存在
        return NO;
    }
    
    [_observers addObject:observer];
    return YES;
}

- (BOOL)removeBeaconObserver:(id<QHBeaconMgrDelegate>)observer
{
    if ([_observers indexOfObjectIdenticalTo:observer] == NSNotFound) {
        // 不存在
        return NO;
    }
    
    [_observers removeObject:observer];
    return YES;
}

- (void)fireDidBeaconMgrRangeBeacons
{
    NSArray * copy = [_observers copy];
    for (id<QHBeaconMgrDelegate> observer in copy)
    {
        if ([observer respondsToSelector:@selector(didBeaconMgrRangeBeacons:)]) {
            [observer didBeaconMgrRangeBeacons:self];
        }
    }
}

- (void)fireBeaconMgrRangeError:(NSError *)error
{
    NSArray * copy = [_observers copy];
    for (id<QHBeaconMgrDelegate> observer in copy)
    {
        if ([observer respondsToSelector:@selector(didBeaconMgrRangeError:error:)]) {
            [observer didBeaconMgrRangeError:self error:error];
        }
    }
}

- (void)fireDidBeaconMgrRangeStopped
{
    NSArray * copy = [_observers copy];
    for (id<QHBeaconMgrDelegate> observer in copy)
    {
        if ([observer respondsToSelector:@selector(didBeaconMgrRangeStopped:)]) {
            [observer didBeaconMgrRangeStopped:self];
        }
    }
}

// 发现Beacon，没有beacon-》有beacon
- (void)fireDidBeaconMgrFoundBeacon
{
    NSArray * copy = [_observers copy];
    for (id<QHBeaconMgrDelegate> observer in copy)
    {
        if ([observer respondsToSelector:@selector(didBeaconMgrFoundBeacon:)]) {
            [observer didBeaconMgrFoundBeacon:self];
        }
    }
}

// 所有beacon消失，没有beacon-》有beacon
- (void)fireDidBeaconMgrMissBeacon
{
    NSArray * copy = [_observers copy];
    for (id<QHBeaconMgrDelegate> observer in copy)
    {
        if ([observer respondsToSelector:@selector(didBeaconMgrMissBeacon:)]) {
            [observer didBeaconMgrMissBeacon:self];
        }
    }
}

// 蓝牙状态变化，通过BTState属性获取具体状态
- (void)fireDidBeaconMgrBTStateChanged
{
    NSArray * copy = [_observers copy];
    for (id<QHBeaconMgrDelegate> observer in copy)
    {
        if ([observer respondsToSelector:@selector(didBeaconMgrBTStateChanged:)]) {
            [observer didBeaconMgrBTStateChanged:self];
        }
    }
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    BTStatePending = NO;
    
    if (BTState == central.state) {
        return;
    }
    
    BTState = central.state;
    [self fireDidBeaconMgrBTStateChanged];
}

@end
