//
//  SEJavaScriptSDK.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/3/2.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJavaScriptSDK.h"
#import "SEJavaScriptBridge.h"
#import "SEJSMethodBase.h"
#import "SEJavaScriptAudioKit.h"


@interface SEJavaScriptSDK ()
<SEJavaScriptAudioKitDelegate>
@end

@implementation SEJavaScriptSDK
{
    SEJavaScriptBridge      *_bridge;
    SEJavaScriptAudioKit    *_audioKit;
}

- (instancetype)initWithBuilder:(SEJavaScriptSDKBuilder *)builder {
    self = [self init];
    if (self) {
        _bridge = [SEJavaScriptBridge bridgeWithWebView:builder.webView webViewDelegate:builder.webViewDelegate handler:NULL resourceBundle:builder.bundle builder:builder];
        
        for (SEJSMethodBase *method in builder.methods) {
            [self addMethod:method];
        }
        
        _audioKit = [SEJavaScriptAudioKit kit];
        _audioKit.delegate = self;
        for (SEJSMethodBase *method in _audioKit.methods) {
            [self addMethod:method];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onAppDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onAppDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

+ (instancetype)SDKWithBuilder:(Class)builderClass block:(SEJavaScriptSDKBuilderBlock)block {
    
    NSParameterAssert(block);
    
    SEJavaScriptSDKBuilder *builder = nil;
    if (builderClass == nil) {
        builder = [[SEJavaScriptSDKBuilder alloc] init];
    }
    else {
        builder = [[builderClass alloc] init];
        NSParameterAssert([builder isKindOfClass:[SEJavaScriptSDKBuilder class]]);
    }
    
    if (block) {
        block(builder);
    }
    return [builder build];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// App向JS发起的回调，几种场景：
// 1、播放音乐结束时发起的回调
// 2、分享取消，分享完成时发起的回调
// 3、用户点击barRightButton
- (void)callback:(NSString *)method args:(id)args
{
    [_bridge callback:method args:args];
}

#pragma mark - method management

- (void)addMethod:(SEJSMethodBase *)method
{
    [_bridge addHandler:[method getName] handler:^(id data, SEJSBResponseHandler responseCallback) {
        [method invoke:data responseHandler:responseCallback];
    }];
    
//    [_bridge addHandler:[method getName] handler:^id(id args) {
//        return [method invoke:args];
//    }];
//    _methods[[method getName]] = method;
}

#pragma mark - <SEJavaScriptAudioKitDelegate>
- (void)onPlayEndWithURL:(NSString *)url {
    [self callback:@"onPlayAudioEnd" args:url ? @{@"url": url} : @{}];
}

#pragma mark - callback
- (void)onNavigationRightBarButtonClick {
    [self callback:@"onNavigationRightBarButtonClick" args:nil];
}

#pragma mark - application lifecycle
- (void)onAppDidBecomeActive {
    [self callback:@"onAppDidBecomeActive" args:nil];
}

- (void)onAppDidEnterBackground {
    [self callback:@"onAppDidEnterBackground" args:nil];
}

@end
