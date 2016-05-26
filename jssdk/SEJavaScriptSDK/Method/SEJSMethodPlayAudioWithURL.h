//
//  SEJSMethodPlayAudioWithURL.h
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/9.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethod.h"
#import "SEJSMethodPlayAudioWithURLDelegate.h"

@interface SEJSMethodPlayAudioWithURL : SEJSMethod
@property(nonatomic, weak) id<SEJSMethodPlayAudioWithURLDelegate> delegate;
@end
