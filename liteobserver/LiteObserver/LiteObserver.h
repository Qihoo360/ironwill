//
//  LiteObserver.h
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for LiteObserver.
FOUNDATION_EXPORT double LiteObserverVersionNumber;

//! Project version string for LiteObserver.
FOUNDATION_EXPORT const unsigned char LiteObserverVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <LiteObserver/PublicHeader.h>

#import <LiteObserver/LOMacros.h>
#import <LiteObserver/LODisposable.h>
#import <LiteObserver/LONotificationObserver.h>
#import <LiteObserver/LOKVObserver.h>

// Observer for dealloc, NSNotification, KVO
#import <LiteObserver/LOUtil.h>

//// To use categories below, set -ObjC linker flag in your project's settings
//#import <LiteObserver/NSObject+LODealloc.h>
//#import <LiteObserver/NSObject+KVObserver.h>
//#import <LiteObserver/NSObject+NotificationObserver.h>
