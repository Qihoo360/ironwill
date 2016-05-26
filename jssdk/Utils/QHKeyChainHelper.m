//
//  QHKeyChainHelper.m
//  SystemExpert
//
//  Created by zhangfusheng on 14/11/28.
//  Copyright (c) 2014年 Qihoo. All rights reserved.
//

#import "QHKeyChainHelper.h"

#import "SysUtils.h"

#ifndef __IPHONE_8_0
#define __IPHONE_8_0     80000
#endif // __IPHONE_8_0

@implementation QHKeyChainHelper

+ (instancetype)keyChainHelperForService:(NSString *)service {
    return [self keyChainHelperForService:service accessGroup:nil];
}

+ (instancetype)keyChainHelperForService:(NSString *)service accessGroup:(NSString *)accessGroup
{
    QHKeyChainHelper *helper = [[QHKeyChainHelper alloc] init];
    helper.service = service;
    helper.accessGroup = accessGroup;
    return helper;
}

- (BOOL)addItem:(NSData *)data errorMsg:(__autoreleasing NSString **)anErrorMsg accessControl:(BOOL)accessControl {

    CFTypeRef protection = NULL;
    
    if (accessControl && [SysUtils getIOSVersion] >= __IPHONE_8_0) {
        protection = kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly;
    }
    
    return errSecSuccess == [self addItem:data errorMsg:anErrorMsg protection:protection];
}

// aizhongyuan add 2014.12.19
- (OSStatus)addItem:(NSData *)data errorMsg:(__autoreleasing NSString **)anErrorMsg protection:(CFTypeRef)protection {
    
    __autoreleasing NSString *str = nil;
    __autoreleasing NSString **errorMsg = anErrorMsg ?: &str;
    
    CFErrorRef error = NULL;
    
    // we want the operation to fail if there is an item which needs authentication so we will use
    // kSecUseNoAuthenticationUI
    NSMutableDictionary *attributes = [@{
                                         (__bridge id)kSecClass:
                                             (__bridge id)kSecClassGenericPassword,
                                         (__bridge id)kSecAttrService:
                                             self.service,
                                         (__bridge id)kSecValueData:
                                             data,
                                         } mutableCopy];
    
    if (self.accessGroup) {
        attributes[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
    
    if ([SysUtils getIOSVersion] >= __IPHONE_8_0) {
        attributes[(__bridge id)kSecUseNoAuthenticationUI] = @YES;
        attributes[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly;
    }
    else {
        attributes[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    }
    
    if (protection != NULL) {
        SecAccessControlRef sacObject;
        sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                    protection,
                                                    kSecAccessControlUserPresence,
                                                    &error);
        attributes[(__bridge id)kSecAttrAccessControl] = (__bridge_transfer id)sacObject;
    }
    
    OSStatus status =  SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
    if (status == errSecSuccess) {
        *errorMsg = nil;
    } else {
        *errorMsg = [self keychainErrorToString:status];
    }
    
    return status;
}

- (BOOL)updateItem:(NSData *)data prompt:(NSString *)prompt errorMsg:(NSString **)anErrorMsg {

    __autoreleasing NSString *str = nil;
    __autoreleasing NSString **errorMsg = anErrorMsg ?: &str;

//    NSDictionary *query = @{
//                            (__bridge id)kSecClass:
//                                (__bridge id)kSecClassGenericPassword,
//                            (__bridge id)kSecAttrService:
//                                self.service,
//                            (__bridge id)kSecUseOperationPrompt:
//                                prompt ?: @""
//                            };
    
    NSMutableDictionary * query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:self.service forKey:(__bridge id)kSecAttrService];
    
    if (self.accessGroup) {
        query[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
    
    if ([SysUtils getIOSVersion] >= __IPHONE_8_0) {
        [query setObject:(prompt ?: @"") forKey:(__bridge id)kSecUseOperationPrompt];
    }

    NSDictionary *changes = @{
                              (__bridge id)kSecValueData: data
                              };

    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)changes);
    if (status == errSecSuccess) {
        *errorMsg = nil;
        return YES;
    } else {
        *errorMsg = [self keychainErrorToString:status];
        return NO;
    }
}

- (BOOL)deleteItemAndReturnErrorMsg:(NSString **)anErrorMsg {

    __autoreleasing NSString *str = nil;
    __autoreleasing NSString **errorMsg = anErrorMsg ?: &str;

    NSMutableDictionary *query = [@{
                            (__bridge id)kSecClass:
                                (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService:
                                self.service
                            } mutableCopy];
    
    if (self.accessGroup) {
        query[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)(query));
    if (status == errSecSuccess) {
        *errorMsg = nil;
        return YES;
    } else {
        *errorMsg = [self keychainErrorToString:status];
        return NO;
    }
}

- (NSData *)queryItem:(NSString *)prompt errorMsg:(NSString **)anErrorMsg {

    __autoreleasing NSString *str = nil;
    __autoreleasing NSString **errorMsg = anErrorMsg ?: &str;
    
    NSMutableDictionary * query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:self.service forKey:(__bridge id)kSecAttrService];
    [query setObject:@YES forKey:(__bridge id)kSecReturnData];
    
    if (self.accessGroup) {
        query[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
    
    if ([SysUtils getIOSVersion] >= __IPHONE_8_0) {
        [query setObject:(prompt ?: @"") forKey:(__bridge id)kSecUseOperationPrompt];
    }

    CFTypeRef dataTypeRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)(query), &dataTypeRef);
    if (status == errSecSuccess) {
        *errorMsg = nil;
        return (__bridge_transfer NSData *)dataTypeRef;
    } else {
        *errorMsg = [self keychainErrorToString:status];
        return nil;
    }
}

- (NSData *)queryItem:(NSString **)anErrorMsg {
    
    __autoreleasing NSString *str = nil;
    __autoreleasing NSString **errorMsg = anErrorMsg ?: &str;
    
    NSMutableDictionary * query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:self.service forKey:(__bridge id)kSecAttrService];
    [query setObject:@YES forKey:(__bridge id)kSecReturnData];
    
    if (self.accessGroup) {
        query[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
    
    if ([SysUtils getIOSVersion] >= __IPHONE_8_0) {
        query[(__bridge id)kSecUseNoAuthenticationUI] = @YES;
        query[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly;
    }
    else {
        query[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    }
    
    CFTypeRef dataTypeRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)(query), &dataTypeRef);
    if (status == errSecSuccess) {
        *errorMsg = nil;
        return (__bridge_transfer NSData *)dataTypeRef;
    } else {
        *errorMsg = [self keychainErrorToString:status];
        return nil;
    }
}

- (BOOL)updateItem:(NSData *)data errorMsg:(NSString **)anErrorMsg {
    
    __autoreleasing NSString *str = nil;
    __autoreleasing NSString **errorMsg = anErrorMsg ?: &str;
    
    OSStatus status = [self updateItem:data];

    if (status == errSecSuccess) {
        *errorMsg = nil;
        return YES;
    } else {
        *errorMsg = [self keychainErrorToString:status];
        return NO;
    }
}

- (OSStatus)updateItem:(NSData *)data {
    
    NSMutableDictionary * query = [[NSMutableDictionary alloc] init];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setObject:self.service forKey:(__bridge id)kSecAttrService];
    
    if (self.accessGroup) {
        query[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
    
    if ([SysUtils getIOSVersion] >= __IPHONE_8_0) {
        query[(__bridge id)kSecUseNoAuthenticationUI] = @YES;
        query[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly;
    }
    
    NSDictionary *changes = [[NSDictionary alloc] initWithObjectsAndKeys:data, (__bridge id)kSecValueData, nil];
    
    return SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)changes);
}

#pragma mark - Tools

- (NSString *)keychainErrorToString:(OSStatus)error {

    NSString *msg = [NSString stringWithFormat:@"error: %ld", (long)error];

    switch (error) {
        case errSecSuccess:
            msg = NSLocalizedString(@"SUCCESS", nil);
            break;
        case errSecDuplicateItem:
            msg = NSLocalizedString(@"ERROR_ITEM_ALREADY_EXISTS", nil);
            break;
        case errSecItemNotFound :
            msg = NSLocalizedString(@"ERROR_ITEM_NOT_FOUND", nil);
            break;
        case errSecAuthFailed:
            msg = NSLocalizedString(@"ERROR_ITEM_AUTHENTICATION_FAILED", nil);
            break;
        default:
            break;
    }

    return msg;
}

@end
