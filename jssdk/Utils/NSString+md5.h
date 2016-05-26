//
//  NSString+md5.h
//  fail
//
//  Created by Felix Gabel on 30.10.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Foundation/NSString.h>

@interface NSString (MD5)

// 计算md5，全小写
- (NSString *)md5String;
// 计算md5，全大写
- (NSString *)md5StringInUpperCase;

- (NSData *)md5Data;

- (NSString*)md5Encrypt16;

@end

