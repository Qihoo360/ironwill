//
//  NSObject+LODealloc.h
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LODisposable.h"

@interface NSObject(LODealloc)

- (LODisposable *)lo_willDeallocDisposable;

@end
