//
//  SEJSMethodStopAudioWithURL.h
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/9.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethod.h"
#import "SEJSMethodStopAudioWithURLDelegate.h"

@interface SEJSMethodStopAudioWithURL : SEJSMethod
@property(nonatomic, weak) id<SEJSMethodStopAudioWithURLDelegate> delegate;
@end
