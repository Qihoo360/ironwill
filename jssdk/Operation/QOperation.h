//
//  QOperation.h
//  SystemExpert
//
//  Created by aizhongyuan on 14-7-15.
//  Copyright (c) 2014年 Qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^QOperationCompleteBlock)(NSError * error);

@interface QOperation : NSObject {
    
@protected
    BOOL _canceled;
    QOperationCompleteBlock _completeBlock;
}

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL completeSelector;
@property (nonatomic, strong) NSError * error;

// 开始执行操作，异步执行
- (void)start;

// 开始执行操作，异步执行
- (void)start:(QOperationCompleteBlock)complete;

// 取消操作
- (void)cancel;

- (BOOL)isCanceled;

- (void)completeOperation;

- (void)completeOnMainThread;

@end
