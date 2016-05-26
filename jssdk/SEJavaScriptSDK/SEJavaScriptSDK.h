//
//  SEJavaScriptSDK.h
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/3/2.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SEJavaScriptSDKBuilder.h"

@class SEJSMethodBase;

@interface SEJavaScriptSDK : NSObject


- (instancetype)initWithBuilder:(SEJavaScriptSDKBuilder *)builder;

+ (instancetype)SDKWithBuilder:(Class)builderClass block:(SEJavaScriptSDKBuilderBlock)block;


// App向JS发起的回调，几种场景：
// 1、播放音乐结束时发起的回调
// 2、分享取消，分享完成时发起的回调
// 3、用户点击barRightButton
- (void)callback:(NSString *)method args:(id)args;

- (void)addMethod:(SEJSMethodBase *)method;



#pragma mark - 回调方法
/**
 * 点击标题栏右上角按钮回调
 */
- (void)onNavigationRightBarButtonClick;

@end
