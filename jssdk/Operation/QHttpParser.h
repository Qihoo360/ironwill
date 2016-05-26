//
//  QHttpParser.h
//  SystemExpert
//
//  Created by aizhongyuan on 14-7-15.
//  Copyright (c) 2014年 Qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHttpError.h"

@interface QHttpParser : NSObject

@property (nonatomic, strong) NSError * error;

+ (NSString *)generateBoundary;

// 准备请求
// 注意：改方法在UI线程中执行
- (void)prepare;

// 生成请求
// 注意：改方法在后台线程中执行，注意并发问题
//      涉及到并发访问的数据，可以在prepare中准备好
- (NSURLRequest *)generateRequest;

// 解析应答
// 注意：改方法在后台线程中执行，注意并发问题
- (void)parseResponse:(NSHTTPURLResponse *)resp body:(NSData *)body;

@end
