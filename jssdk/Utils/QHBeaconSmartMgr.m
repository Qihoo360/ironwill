//
//  QHBeaconSmartMgr.m
//  Utilities
//
//  Created by aizhongyuan on 15/11/6.
//  Copyright © 2015年 aizhongyuan. All rights reserved.
//

#import "QHBeaconSmartMgr.h"

@implementation QHBeaconSmartMgr
{
    __unsafe_unretained id<QHBeaconMgrDelegate> _delegate;
    BOOL _started;
}

- (instancetype)initWithDelegate:(id<QHBeaconMgrDelegate>)delegate
{
    self = [super init];
    if (self) {
        _started = NO;
        _delegate = delegate;
        
        if (_delegate) {
            [[QHBeaconMgr getInstance] addBeaconObserver:_delegate];
        }
        
        [self start];
    }
    return self;
}

- (void)dealloc
{
    if (_delegate) {
        [[QHBeaconMgr getInstance] removeBeaconObserver:_delegate];
    }
    
    [self stop];
}

- (void)start
{
    if (_started == NO) {
        // 首次启动
        [[QHBeaconMgr getInstance] performSelector:@selector(startRanging)];
//        [[QHBeaconMgr getInstance] startRanging];
        
        _started = YES;
    }
}

- (void)stop
{
    if (_started == YES) {
        [[QHBeaconMgr getInstance] performSelector:@selector(stopRanging)];
//        [[QHBeaconMgr getInstance] stopRanging];
        _started = NO;
    }
}

- (void)startMonitor
{
    if (_delegate) {
        [[QHBeaconMgr getInstance] addBeaconObserver:_delegate];
    }
}

- (void)stopMonitor
{
    if (_delegate) {
        [[QHBeaconMgr getInstance] removeBeaconObserver:_delegate];
    }
}

@end
