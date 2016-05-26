//
//  NSSafeAddition.h
//  360CloudIPhone
//
//  Created by ai zhongyuan on 13-3-28.
//
//

#import <Foundation/Foundation.h>

#pragma mark - NSNull
@interface NSNull (SafeAddition)

- (char)safeCharValue;
- (unsigned char)safeUnsignedCharValue;
- (short)safeShortValue;
- (unsigned short)safeUnsignedShortValue;
- (int)safeIntValue;
- (unsigned int)safeUnsignedIntValue;
- (long)safeLongValue;
- (unsigned long)safeUnsignedLongValue;
- (long long)safeLongLongValue;
- (unsigned long long)safeUnsignedLongLongValue;
- (float)safeFloatValue;
- (double)safeDoubleValue;
- (BOOL)safeBoolValue;

- (NSInteger)safeIntegerValue;
- (NSUInteger)safeUnsignedIntegerValue;

- (id)safeObjectForKey:(id)aKey;

- (NSString *)safeStringValue;
- (NSArray *)safeArrayValue;
- (NSNumber *)safeNumberValue;
- (NSDictionary *)safeDictionaryValue;

@end

#pragma mark - NSNumber
@interface NSNumber (SafeAddition)

- (char)safeCharValue;
- (unsigned char)safeUnsignedCharValue;
- (short)safeShortValue;
- (unsigned short)safeUnsignedShortValue;
- (int)safeIntValue;
- (unsigned int)safeUnsignedIntValue;
- (long)safeLongValue;
- (unsigned long)safeUnsignedLongValue;
- (long long)safeLongLongValue;
- (unsigned long long)safeUnsignedLongLongValue;
- (float)safeFloatValue;
- (double)safeDoubleValue;
- (BOOL)safeBoolValue;

- (NSInteger)safeIntegerValue;
- (NSUInteger)safeUnsignedIntegerValue;

- (id)safeObjectForKey:(id)aKey;

- (NSString *)safeStringValue;
- (NSArray *)safeArrayValue;
- (NSNumber *)safeNumberValue;
- (NSDictionary *)safeDictionaryValue;

@end

#pragma mark - NSString
@interface NSString (SafeAddition)

- (char)safeCharValue;
- (unsigned char)safeUnsignedCharValue;
- (short)safeShortValue;
- (unsigned short)safeUnsignedShortValue;
- (int)safeIntValue;
- (unsigned int)safeUnsignedIntValue;
- (long)safeLongValue;
- (unsigned long)safeUnsignedLongValue;
- (long long)safeLongLongValue;
- (unsigned long long)safeUnsignedLongLongValue;
- (float)safeFloatValue;
- (double)safeDoubleValue;
- (BOOL)safeBoolValue;

- (NSInteger)safeIntegerValue;
- (NSUInteger)safeUnsignedIntegerValue;

- (id)safeObjectForKey:(id)aKey;

- (NSString *)safeStringValue;
- (NSArray *)safeArrayValue;
- (NSNumber *)safeNumberValue;
- (NSDictionary *)safeDictionaryValue;

@end

#pragma mark - NSArray
@interface NSArray (SafeAddition)

- (char)safeCharValue;
- (unsigned char)safeUnsignedCharValue;
- (short)safeShortValue;
- (unsigned short)safeUnsignedShortValue;
- (int)safeIntValue;
- (unsigned int)safeUnsignedIntValue;
- (long)safeLongValue;
- (unsigned long)safeUnsignedLongValue;
- (long long)safeLongLongValue;
- (unsigned long long)safeUnsignedLongLongValue;
- (float)safeFloatValue;
- (double)safeDoubleValue;
- (BOOL)safeBoolValue;

- (NSInteger)safeIntegerValue;
- (NSUInteger)safeUnsignedIntegerValue;

- (id)safeObjectForKey:(id)aKey;

- (NSString *)safeStringValue;
- (NSArray *)safeArrayValue;
- (NSNumber *)safeNumberValue;
- (NSDictionary *)safeDictionaryValue;

@end

#pragma mark - NSDictionary
@interface NSDictionary (SafeAddition)

- (char)safeCharValue;
- (unsigned char)safeUnsignedCharValue;
- (short)safeShortValue;
- (unsigned short)safeUnsignedShortValue;
- (int)safeIntValue;
- (unsigned int)safeUnsignedIntValue;
- (long)safeLongValue;
- (unsigned long)safeUnsignedLongValue;
- (long long)safeLongLongValue;
- (unsigned long long)safeUnsignedLongLongValue;
- (float)safeFloatValue;
- (double)safeDoubleValue;
- (BOOL)safeBoolValue;

- (NSInteger)safeIntegerValue;
- (NSUInteger)safeUnsignedIntegerValue;

- (id)safeObjectForKey:(id)aKey;

- (NSString *)safeStringValue;
- (NSArray *)safeArrayValue;
- (NSNumber *)safeNumberValue;
- (NSDictionary *)safeDictionaryValue;

@end
