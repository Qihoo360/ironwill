//
//  SEJSMethodGetCalendarAuthStatus.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/5/21.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodGetCalendarAuthStatus.h"

#import <EventKit/EventKit.h>

@implementation SEJSMethodGetCalendarAuthStatus

// 返回接口名
- (NSString *)getName
{
    return @"getCalendarAuthStatus";
}

// 执行接口
- (id)invoke:(id)args
{
    return @([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent]);
}

@end
