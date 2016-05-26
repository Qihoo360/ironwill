//
//  SEJavaScriptAudioKit.h
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/9.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEJavaScriptAudioKitDelegate.h"

@interface SEJavaScriptAudioKit : NSObject

/**
 * 推荐实例化方法
 */
+ (instancetype)kit;

/**
 * 方法 of SEJSMethod
 */
@property(nonatomic, strong) NSArray *methods;

/**
 * 回调
 */
@property(nonatomic, weak) id<SEJavaScriptAudioKitDelegate> delegate;

@end
