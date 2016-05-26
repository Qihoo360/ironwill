//
//  QHBeaconSmartMgr.h
//  Utilities
//
//  Created by aizhongyuan on 15/11/6.
//  Copyright © 2015年 aizhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QHBeaconMgr.h"

// QHBeaconMgr启动和停止控制智能管理
// 确保QHBeaconMgr的startRanging和stopRanging成对出现
@interface QHBeaconSmartMgr : NSObject

- (instancetype)initWithDelegate:(id<QHBeaconMgrDelegate>)delegate;

- (void)start;

- (void)stop;

@end
