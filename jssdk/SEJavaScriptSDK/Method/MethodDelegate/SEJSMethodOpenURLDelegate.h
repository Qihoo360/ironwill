//
//  SEJSMethodOpenURLDelegate.h
//  SEJavaScriptSDK
//
//  Created by zhangfusheng on 15/6/1.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#ifndef SEJavaScriptSDK_SEJSMethodOpenURLDelegate_h
#define SEJavaScriptSDK_SEJSMethodOpenURLDelegate_h

#import <Foundation/Foundation.h>

@protocol SEJSMethodOpenURLDelegate <NSObject>
- (BOOL)onJSMethodOpenURL:(NSString *)url;
@end

#endif
