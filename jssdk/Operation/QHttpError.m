//
//  QHttpError.m
//  SystemExpert
//
//  Created by aizhongyuan on 14-7-15.
//  Copyright (c) 2014年 Qihoo. All rights reserved.
//

#import "QHttpError.h"

#define KErrorMessage @"errormsg"

@implementation QHttpError

- (id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict
{
    self = [super initWithDomain:domain code:code userInfo:dict];
    if (self) {
        
    }
    return self;
}

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict
{
    return [[QHttpError alloc] initWithDomain:domain code:code userInfo:dict];
}

+ (id)errorInvalidRequest:(NSException *)exception
{
    NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[exception description], KErrorMessage, nil];
    return [self errorWithDomain:ERROR_DOMAIN_QHTTP code:QHttpErrorInvalidRequest userInfo:userInfo];
}

+ (id)errorInvalidResponse:(NSException *)exception
{
    return [self errorInvalidResponseWithDesc:[exception description]];
}

+ (id)errorInvalidResponseWithDesc:(NSString *)desc
{
    NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:desc, KErrorMessage, nil];
    return [self errorWithDomain:ERROR_DOMAIN_QHTTP code:QHttpErrorInvalidResponse userInfo:userInfo];
}

+ (id)errorNetwork:(NSError *)error
{
    NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[error localizedDescription], KErrorMessage, nil];
    return [self errorWithDomain:ERROR_DOMAIN_QHTTP code:QHttpErrorNetwork userInfo:userInfo];
}

+ (id)errorTimeout
{
    return [self errorWithDomain:ERROR_DOMAIN_QHTTP code:QHttpErrorTimeout userInfo:nil];
}

+ (id)errorStatus:(NSInteger)statusCode
{
    NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(statusCode), KErrorMessage, nil];
    return [self errorWithDomain:ERROR_DOMAIN_QHTTP code:QHttpErrorStatus userInfo:userInfo];
}

- (NSString *)localizedDescription
{
    switch ([self code]) {
        case QHttpErrorInvalidRequest:
            return [NSString stringWithFormat:@"请求无效！%@", [[self userInfo] objectForKey:KErrorMessage]];
            break;
            
        case QHttpErrorInvalidResponse:
            return [NSString stringWithFormat:@"应答无效！%@", [[self userInfo] objectForKey:KErrorMessage]];
            break;
            
        case QHttpErrorNetwork:
            return [NSString stringWithFormat:@"网络错误！%@", [[self userInfo] objectForKey:KErrorMessage]];
            break;
            
        case QHttpErrorStatus:
            return [NSString stringWithFormat:@"HTTP错误:%@", [[self userInfo] objectForKey:KErrorMessage]];
            break;
            
        case QHttpErrorTimeout:
            return @"网络超时";
            break;
            
        default:
            return [NSString stringWithFormat:@"HttpError:%ld", (long)[self code]];
            break;
    }
}

@end
