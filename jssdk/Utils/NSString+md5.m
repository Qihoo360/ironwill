//
//  NSString+md5.m
//  fail
//
//  Created by Felix Gabel on 30.10.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#include <Foundation/Foundation.h>
#import "NSString+md5.h"
#import <CommonCrypto/CommonDigest.h>


#define MD5_LENGTH 16

@implementation NSString (MD5)

// 计算md5，全小写
- (NSString *)md5String {
    
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([data bytes], (CC_LONG)[data length], result);
	
	return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

// 计算md5，全大写
- (NSString *)md5StringInUpperCase {
    
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([data bytes], (CC_LONG)[data length], result);
	
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

- (NSData *)md5Data {
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([data bytes], (CC_LONG)[data length], result);
    
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

- (NSString*)md5Encrypt16 {
    return [self md5String];
}

@end