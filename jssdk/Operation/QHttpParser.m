//
//  QHttpParser.m
//  SystemExpert
//
//  Created by aizhongyuan on 14-7-15.
//  Copyright (c) 2014年 Qihoo. All rights reserved.
//

#import "QHttpParser.h"

@implementation QHttpParser

@synthesize error;

+ (NSString *)generateBoundary
{
    CFUUIDRef uuid = CFUUIDCreate(nil);
	NSString * strUuid = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuid);
	CFRelease(uuid);
    
    return [NSString stringWithFormat:@"qh360xBhLbOuArY-%@",strUuid];
}

- (void)prepare
{
    // 子类实现
}

// 生成请求
- (NSURLRequest *)generateRequest
{
    // 子类实现
    NSAssert(NO, @"generateRequest not implemented!");
    return nil;
}

// 解析应答
- (void)parseResponse:(NSHTTPURLResponse *)resp body:(NSData *)body
{
    // 子类实现
    NSAssert(NO, @"parseResponse not implemented!");
}

@end
