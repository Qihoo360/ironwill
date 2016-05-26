//
//  SEJavaScriptSDKBuilder.h
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/4.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark - SEJSMethodDelegate
#import "Method/MethodDelegate/SEJSMethodSetTitleDelegate.h"
#import "Method/MethodDelegate/SEJSMethodExitDelegate.h"
#import "Method/MethodDelegate/SEJSMethodSetNavigationRightBarButtonDelegate.h"
#import "Method/MethodDelegate/SEJSMethodOpenURLDelegate.h"

@class SEJavaScriptSDKBuilder;
typedef void (^SEJavaScriptSDKBuilderBlock)(SEJavaScriptSDKBuilder *builder);

@class SEJavaScriptSDK;
@interface SEJavaScriptSDKBuilder : NSObject

- (SEJavaScriptSDK *)build;

#pragma mark - 必填字段

/**
 * setTitle方法回调
 */
@property(nonatomic, weak) id<SEJSMethodSetTitleDelegate> setTitleDelegate;

/**
 * exit方法回调
 */
@property(nonatomic, weak) id<SEJSMethodExitDelegate> exitDelegate;

/**
 * setNavigationRightBarButton方法回调
 */
@property(nonatomic, weak) id<SEJSMethodSetNavigationRightBarButtonDelegate> setNavigationRightBarButtonDelegate;

/**
 * openURL方法回调
 */
@property(nonatomic, weak) id<SEJSMethodOpenURLDelegate> openURLDelegate;

/**
 * 要注入的webView
 */
@property(nonatomic, strong) UIWebView *webView;

/**
 * webView的delegate
 */
@property(nonatomic, weak) id<UIWebViewDelegate> webViewDelegate;

/**
 * 存放WebViewJavascriptBridge.js.txt文件的bundle
 */
@property(nonatomic, strong) NSBundle *bundle;

/**
 * 方法 of SEJSMethod
 */
@property(nonatomic, readonly) NSArray *methods;

// 构建JSSDK接口，子类可以扩展和修改
- (void)buildMethods:(NSMutableArray *)methods;


@end
