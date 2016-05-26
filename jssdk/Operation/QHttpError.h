//
//  QHttpError.h
//  SystemExpert
//
//  Created by aizhongyuan on 14-7-15.
//  Copyright (c) 2014年 Qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ERROR_DOMAIN_QHTTP @"net.qihoo.error.http"

typedef NS_ENUM(int, QHttpErrorCode) {
    QHttpErrorInvalidRequest, // 请求无效，构建请求时出现异常
    QHttpErrorInvalidResponse,// 应答无效，解析瑛大师出现异常
    QHttpErrorNetwork,        // 网络错误或超时
    QHttpErrorStatus,         // HTTP错误，statuscode不是200
    QHttpErrorTimeout,        // 网络超时
};

@interface QHttpError : NSError

+ (id)errorInvalidRequest:(NSException *)exception;
+ (id)errorInvalidResponse:(NSException *)exception;
+ (id)errorInvalidResponseWithDesc:(NSString *)desc;
+ (id)errorNetwork:(NSError *)error;
+ (id)errorStatus:(NSInteger)statusCode;
+ (id)errorTimeout;

@end
