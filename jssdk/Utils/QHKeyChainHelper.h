//
//  QHKeyChainHelper.h
//  SystemExpert
//
//  Created by zhangfusheng on 14/11/28.
//  Copyright (c) 2014年 Qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface QHKeyChainHelper : NSObject

+ (instancetype)keyChainHelperForService:(NSString *)service;
+ (instancetype)keyChainHelperForService:(NSString *)service accessGroup:(NSString *)accessGroup;

@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSString *accessGroup;

- (BOOL)addItem:(NSData *)data errorMsg:(NSString **)errorMsg accessControl:(BOOL)accessControl;

// aizhongyuan add 2014.12.19
- (OSStatus)addItem:(NSData *)data errorMsg:(__autoreleasing NSString **)anErrorMsg protection:(CFTypeRef)protection;

- (BOOL)updateItem:(NSData *)data prompt:(NSString *)prompt errorMsg:(NSString **)errorMsg;
- (BOOL)deleteItemAndReturnErrorMsg:(NSString **)errorMsg;
- (NSData *)queryItem:(NSString *)prompt errorMsg:(NSString **)errorMsg;

// aizhongyuan add 2014.12.19
- (NSData *)queryItem:(NSString **)anErrorMsg;
- (BOOL)updateItem:(NSData *)data errorMsg:(NSString **)anErrorMsg;
- (OSStatus)updateItem:(NSData *)data;

@end
