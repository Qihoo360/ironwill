//
//  QHttpParserDownloadData.m
//  Utilities
//
//  Created by aizhongyuan on 14-7-21.
//  Copyright (c) 2014年 aizhongyuan. All rights reserved.
//

#import "QHttpParserDownloadData.h"

@implementation QHttpParserDownloadData

@synthesize i_url;
@synthesize o_data;

- (void)prepare
{
    // 子类实现
}

// 生成请求
- (NSURLRequest *)generateRequest
{
    // 创建Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:i_url]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:30];
    
    [request setHTTPMethod:@"GET"];
    
    return request;
}

// 解析应答
- (void)parseResponse:(NSHTTPURLResponse *)resp body:(NSData *)body
{
    if (body == nil) {
        self.error = [QHttpError errorInvalidResponseWithDesc:@"Body is empty"];
        return;
    }
    
    o_data = body;
}

@end
