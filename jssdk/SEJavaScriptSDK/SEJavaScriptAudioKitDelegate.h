//
//  SEJavaScriptAudioKitDelegate.h
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/9.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SEJavaScriptAudioKitDelegate <NSObject>
- (void)onPlayEndWithURL:(NSString *)url;
@end
