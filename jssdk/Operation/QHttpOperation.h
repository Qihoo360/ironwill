//
//  QHttpOperation.h
//  SystemExpert
//
//  Created by aizhongyuan on 14-7-15.
//  Copyright (c) 2014年 Qihoo. All rights reserved.
//

#import "QOperation.h"

#import "QHttpParser.h"
#import "QProgressDelegate.h"

@interface QHttpOperation : QOperation <NSURLConnectionDataDelegate> {
    
@protected
    QHttpParser * _parser;
    
    NSURLConnection * _connection;
    
    NSTimer * _timer;
    time_t _lastActiveTime;
    
    NSHTTPURLResponse * _httpResponse;
    NSMutableData * _httpBody;
}

@property (nonatomic, strong) QHttpParser * parser;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, readonly) NSHTTPURLResponse * httpResponse;
@property (nonatomic, weak) id<QProgressDelegate> progressDelegate;

@end
