//
//  QOperationEx.h
//  Utilities
//
//  Created by aizhongyuan on 14/12/2.
//  Copyright (c) 2014年 aizhongyuan. All rights reserved.
//

#import "QOperation.h"

@interface QOperationEx : QOperation

@property (nonatomic, assign) SEL stateChangeSelector;

- (void)fireOperationStateChange;

@end
