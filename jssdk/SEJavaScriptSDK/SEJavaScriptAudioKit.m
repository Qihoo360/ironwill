//
//  SEJavaScriptAudioKit.m
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/9.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJavaScriptAudioKit.h"
#import "SEJSMethodPlayAudioWithURL.h"
#import "SEJSMethodStopAudioWithURL.h"
#import "SEJSMethodStopAllAudio.h"
#import <AVFoundation/AVFoundation.h>
#import <Operation/QHttpOperation.h>
#import "QHttpParserDownloadDataJSEx.h"


@interface SEJavaScriptAudioKit ()
<SEJSMethodPlayAudioWithURLDelegate,
SEJSMethodStopAudioWithURLDelegate,
SEJSMethodStopAllAudioDelegate,
AVAudioPlayerDelegate>
{
    /**
     * 播放器 key: URL(NSString), value: AVAudioPlayer
     */
    NSMutableDictionary *_players;
    
    /**
     * 下载器 of QHttpParserDownloadDataJSEx
     */
    NSMutableDictionary *_downOprations;
}
@end

@implementation SEJavaScriptAudioKit

- (void)dealloc {
    [self cancelAll];
}

+ (instancetype)kit {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _players = [NSMutableDictionary dictionary];
        _downOprations = [NSMutableDictionary dictionary];
        
        [self buildMethods];
        
    }
    return self;
}

- (void)buildMethods {
    NSMutableArray *methods = [NSMutableArray array];
    
    // playAudioWithURL
    {
        SEJSMethodPlayAudioWithURL *method = [[SEJSMethodPlayAudioWithURL alloc] init];
        method.delegate = self;
        [methods addObject:method];
    }
    
    // stopAudioWithURL
    {
        SEJSMethodStopAudioWithURL *method = [[SEJSMethodStopAudioWithURL alloc] init];
        method.delegate = self;
        [methods addObject:method];
    }
    
    // stopAllAudio
    {
        SEJSMethodStopAllAudio *method = [[SEJSMethodStopAllAudio alloc] init];
        method.delegate = self;
        [methods addObject:method];
    }
    
    self.methods = methods;
}

#pragma mark - download
- (void)asyncDownload:(NSString *)url loops:(int)loops
{
    if (!url || ![url isKindOfClass:[NSString class]] || url.length <= 0) {
        return;
    }
    
    if (_downOprations[url]) {
        //已在下载
        return;
    }
    
    QHttpParserDownloadDataJSEx * parser = [[QHttpParserDownloadDataJSEx alloc] init];
    parser.i_url = url;
    parser.i_loops = loops;
    
    QHttpOperation * operation = [[QHttpOperation alloc] init];
    operation.target = self;
    operation.completeSelector = @selector(onDownloadFinish:);
    operation.parser = parser;
    
    [operation start];
    
    _downOprations[url] = operation;
}

- (void)onDownloadFinish:(QHttpOperation *)operation
{
    QHttpParserDownloadDataJSEx * parser = (QHttpParserDownloadDataJSEx *)operation.parser;
    if ([parser isKindOfClass:[QHttpParserDownloadDataJSEx class]]) {
        [_downOprations removeObjectForKey:parser.i_url];
    } else {
        return;
    }
    
    if (operation.error) {
        return;
    }
    
    if ([parser.o_data isKindOfClass:[NSData class]] && parser.o_data.length > 0) {
        [self playWithData:parser.o_data url:parser.i_url loops:parser.i_loops];
    }
}

- (void)playWithData:(NSData *)data url:(NSString *)url loops:(int)loops {
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    if (player && !error) {
        player.delegate = self;
        player.numberOfLoops = loops;
        if ([player prepareToPlay]) {
            _players[url] = player;
            [player play];
        }
    }
}

// 取消操作
- (void)cancelAll
{
    for (NSString *url in _downOprations) {
        QHttpOperation *op = _downOprations[url];
        [op cancel];
    }
    [_downOprations removeAllObjects];
}

#pragma mark - delegates
- (void)onJSMethodPlayAudioWithURL:(NSString *)url loops:(int)loops {
    if (![url isKindOfClass:[NSString class]] || url.length <= 0) {
        //参数不合法
        return;
    }
    
    AVAudioPlayer *player = _players[url];
    if (player) {
        //正在播放
        return;
    }
    
    //开始下载
    [self asyncDownload:url loops:loops];
}

- (void)onJSMethodStopAudioWithURL:(NSString *)url {
    if (![url isKindOfClass:[NSString class]] || url.length <= 0) {
        //参数不合法
        return;
    }
    
    if (_downOprations[url]) {
        [_downOprations removeObjectForKey:url];
    }
    
    AVAudioPlayer *player = _players[url];
    if (player) {
        [player stop];
        [_players removeObjectForKey:url];
    }
}

- (void)onJSMethodStopAllAudio {
    for (NSString *key in _players) {
        AVAudioPlayer *player = _players[key];
        if (player) {
            [player stop];
        }
    }
    
    [_players removeAllObjects];
}

#pragma mark - <AVAudioPlayerDelegate>
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSString *removeURL = nil;
    for (NSString *key in _players) {
        AVAudioPlayer *p = _players[key];
        if (p == player) {
            removeURL = key;
            break;
        }
    }
    
    if (removeURL) {
        [_players removeObjectForKey:removeURL];
    }
    
    
    //通知播放完成
    if (_delegate && [_delegate respondsToSelector:@selector(onPlayEndWithURL:)]) {
        [_delegate onPlayEndWithURL:removeURL];
    }
}

@end
