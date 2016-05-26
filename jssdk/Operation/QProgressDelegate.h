//
//  QProgressDelegate.h
//  SystemExpert
//
//  Created by aizhongyuan on 14-7-15.
//  Copyright (c) 2014年 Qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QProgressDelegate <NSObject>

- (void)didResponseReceived:(NSHTTPURLResponse *)response;

- (void)didDataReceived:(NSInteger)receivedBytes totalReceivedBytes:(NSInteger)totalBytes;

- (void)didDataSended:(NSInteger)sendedBytes totalSendedBytes:(NSInteger)totalBytes;

@end
