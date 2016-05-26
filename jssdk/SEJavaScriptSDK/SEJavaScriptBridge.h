//
//  SEJavaScriptBridge.h
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/3/2.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SEJavaScriptSDKBuilder.h"

@interface SEJavaScriptBridge : NSObject

typedef void (^SEJSBResponseHandler)(id responseData);
typedef void (^SEJSBInvokeHandler)(id data, SEJSBResponseHandler responseCallback);

// handler: JS中调用invoke触发的block
+ (instancetype)bridgeWithWebView:(UIWebView *)webView
                  webViewDelegate:(id<UIWebViewDelegate>)webViewDelegate
                          handler:(SEJSBInvokeHandler)handler
                   resourceBundle:(NSBundle*)bundle
                          builder:(SEJavaScriptSDKBuilder *)builder;

- (void)addHandler:(NSString *) method handler:(SEJSBInvokeHandler)handler;

// App向JS发起的回调，几种场景：
// 1、播放音乐结束时发起的回调
// 2、分享取消，分享完成时发起的回调
// 3、用户点击barRightButton
- (void)callback:(NSString *) method args:(NSDictionary *)args;

@end
