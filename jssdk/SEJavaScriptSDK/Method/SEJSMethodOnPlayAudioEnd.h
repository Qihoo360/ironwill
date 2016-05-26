//
//  SEJSMethodOnPlayAudioEnd.h
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/9.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethod.h"
#import "SEJSMethodOnPlayAudioEndDelegate.h"

@interface SEJSMethodOnPlayAudioEnd : SEJSMethod
@property(nonatomic, weak) id<SEJSMethodOnPlayAudioEndDelegate> delegate;
@end
