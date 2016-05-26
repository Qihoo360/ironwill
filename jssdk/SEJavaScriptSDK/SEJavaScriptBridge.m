//
//  SEJavaScriptBridge.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/3/2.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJavaScriptBridge.h"
#import "WebViewJavascriptBridge.h"
#import "SEJSConfiguration.h"
#import <Utils/SysUtils.h>

@interface SEJavaScriptBridge () <UIWebViewDelegate>
@end

@implementation SEJavaScriptBridge {
    __weak UIWebView *_webView;
    __weak id<UIWebViewDelegate> _webViewDelegate;
    SEJavaScriptSDKBuilder *_builder;
    NSUInteger _numRequestsLoading;
    WebViewJavascriptBridge *_bridge;
    NSBundle *_resourceBundle;
}

+ (instancetype)bridgeWithWebView:(UIWebView *)webView
                  webViewDelegate:(id<UIWebViewDelegate>)webViewDelegate
                          handler:(SEJSBInvokeHandler)handler
                   resourceBundle:(NSBundle*)bundle
                          builder:(SEJavaScriptSDKBuilder *)builder {
    SEJavaScriptBridge *bridge = [[SEJavaScriptBridge alloc] init];
    [bridge initBridge:webView
       webViewDelegate:webViewDelegate
               handler:handler
        resourceBundle:bundle
               builder:builder];
    return bridge;
}

- (void)dealloc {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)initBridge:(UIWebView *)webView
   webViewDelegate:(id<UIWebViewDelegate>)webViewDelegate
           handler:(SEJSBInvokeHandler)handler
    resourceBundle:(NSBundle *)bundle
           builder:(SEJavaScriptSDKBuilder *)builder {
    _webView = webView;
    _webViewDelegate = webViewDelegate;
    _builder = builder;
    _numRequestsLoading = 0;
    _resourceBundle = bundle;
    
    WVJBHandler tmpHandler = ^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        if (responseCallback) {
            responseCallback(@"");
        }
    };
    
    // 创建Bridge对象
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView
                                        webViewDelegate:self
                                                handler:tmpHandler
                                         resourceBundle:bundle];
}

- (void)addHandler:(NSString *)name handler:(SEJSBInvokeHandler)handler {
//    [_bridge registerHandler:name
//                     handler:^(id data, WVJBResponseCallback responseCallback) {
//                         id result = handler(data);
//                         if (result) {
//                             responseCallback(result);
//                         }
//                     }];
    [_bridge registerHandler:name
                     handler:handler];
}

// App向JS发起的回调，几种场景：
// 1、播放音乐结束时发起的回调
// 2、分享取消，分享完成时发起的回调
// 3、用户点击barRightButton
- (void)callback:(NSString *)method args:(id)args {
    [_bridge callHandler:method data:args];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView != _webView) {
        return;
    }
    
    _numRequestsLoading--;
    
    // 注入JavaScript脚本
    if (
//        _numRequestsLoading == 0 && // 全部资源下载完后在注入脚本，会导致其他问题 aizy 2015.08.28
        ![[webView stringByEvaluatingJavaScriptFromString:@"typeof SESDK == 'object'"] isEqualToString:@"true"]) {
        NSString *js = [self jsCode];
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
    
    __strong id<UIWebViewDelegate> strongDelegate = _webViewDelegate;
    if (strongDelegate &&
        [strongDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [strongDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (webView != _webView) {
        return;
    }
    
    _numRequestsLoading--;
    
    __strong id<UIWebViewDelegate> strongDelegate = _webViewDelegate;
    if (strongDelegate &&
        [strongDelegate
         respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
            [strongDelegate webView:webView didFailLoadWithError:error];
        }
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    if (webView != _webView) {
        return YES;
    }
    
    __strong id<UIWebViewDelegate> strongDelegate = _webViewDelegate;
    if (strongDelegate &&
        [strongDelegate respondsToSelector:@selector(webView:
                                                     shouldStartLoadWithRequest:
                                                     navigationType:)]) {
        return [strongDelegate webView:webView
            shouldStartLoadWithRequest:request
                        navigationType:navigationType];
    } else {
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (webView != _webView) {
        return;
    }
    
    _numRequestsLoading++;
    
    __strong id<UIWebViewDelegate> strongDelegate = _webViewDelegate;
    if (strongDelegate &&
        [strongDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [strongDelegate webViewDidStartLoad:webView];
    }
}

#pragma mark - 注入的JS代码
- (NSString *)jsCode {
    NSBundle *bundle =
    _resourceBundle ? _resourceBundle : [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"SEJSBridge" ofType:@"js"];
    NSMutableString *js = [NSMutableString stringWithContentsOfFile:filePath
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    
    [js appendFormat:@";(function(){\n"];
    [js appendFormat:@"SESDK.version = \'%@\';\n",SEJSVersion];
    [js appendFormat:@"SESDK.isBroken = %@;\n",[SysUtils isBreaked] ? @"true" : @"false"];
    [js appendFormat:@"SESDK.osVersion = \'%@\';\n",[UIDevice currentDevice].systemVersion];
    [js appendFormat:@"SESDK.deviceID = \'%@\';\n",[SysUtils uniqueIdentifier]];
    [js appendFormat:@"SESDK.model = \'%@\';\n",[SysUtils platform]];
    [js appendFormat:@"SESDK.appVersion = \'%@\';\n",[SysUtils GetAppFullVer]];
    [js appendFormat:@"SESDK.init();\n"];
    [js appendFormat:@"})();\n"];
    return js;
}

@end
