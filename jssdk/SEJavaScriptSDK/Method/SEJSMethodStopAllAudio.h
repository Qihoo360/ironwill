//
//  SEJSMethodStopAllAudio.h
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/9.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethod.h"
#import "SEJSMethodStopAllAudioDelegate.h"

@interface SEJSMethodStopAllAudio : SEJSMethod
@property(nonatomic, weak) id<SEJSMethodStopAllAudioDelegate> delegate;
@end
