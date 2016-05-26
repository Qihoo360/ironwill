//
//  NSSafeAddition.m
//  360CloudIPhone
//
//  Created by ai zhongyuan on 13-3-28.
//
//

#import "NSSafeAddition.h"

#pragma mark - NSNull
@implementation NSNull (SafeAddition)

- (char)safeCharValue
{
    return 0;
}
- (unsigned char)safeUnsignedCharValue
{
    return 0;
}
- (short)safeShortValue
{
    return 0;
}
- (unsigned short)safeUnsignedShortValue
{
    return 0;
}
- (int)safeIntValue
{
    return 0;
}
- (unsigned int)safeUnsignedIntValue
{
    return 0;
}
- (long)safeLongValue
{
    return 0;
}
- (unsigned long)safeUnsignedLongValue
{
    return 0;
}
- (long long)safeLongLongValue
{
    return 0;
}
- (unsigned long long)safeUnsignedLongLongValue
{
    return 0;
}
- (float)safeFloatValue
{
    return .0;
}
- (double)safeDoubleValue
{
    return .0f;
}
- (BOOL)safeBoolValue
{
    return NO;
}

- (NSInteger)safeIntegerValue
{
    return 0;
}
- (NSUInteger)safeUnsignedIntegerValue
{
    return 0;
}

- (id)safeObjectForKey:(id)aKey
{
    return nil;
}

- (NSString *)safeStringValue
{
    return nil;
}
- (NSArray *)safeArrayValue
{
    return nil;
}
- (NSNumber *)safeNumberValue
{
    return nil;
}
- (NSDictionary *)safeDictionaryValue
{
    return nil;
}

@end

#pragma mark - NSNumber
@implementation NSNumber (SafeAddition)

- (char)safeCharValue
{
    return [self charValue];
}
- (unsigned char)safeUnsignedCharValue
{
    return [self unsignedCharValue];
}
- (short)safeShortValue
{
    return [self shortValue];
}
- (unsigned short)safeUnsignedShortValue
{
    return [self unsignedShortValue];
}
- (int)safeIntValue
{
    return [self intValue];
}
- (unsigned int)safeUnsignedIntValue
{
    return [self unsignedIntValue];
}
- (long)safeLongValue
{
    return [self longValue];
}
- (unsigned long)safeUnsignedLongValue
{
    return [self unsignedLongValue];
}
- (long long)safeLongLongValue
{
    return [self longLongValue];
}
- (unsigned long long)safeUnsignedLongLongValue
{
    return [self unsignedLongLongValue];
}
- (float)safeFloatValue
{
    return [self floatValue];
}
- (double)safeDoubleValue
{
    return [self doubleValue];
}
- (BOOL)safeBoolValue
{
    return [self boolValue];
}

- (NSInteger)safeIntegerValue
{
    return [self integerValue];
}
- (NSUInteger)safeUnsignedIntegerValue
{
    return [self unsignedIntegerValue];
}

- (id)safeObjectForKey:(id)aKey
{
    return nil;
}

- (NSString *)safeStringValue
{
    return [self stringValue];
}
- (NSArray *)safeArrayValue
{
    return nil;
}
- (NSNumber *)safeNumberValue
{
    return self;
}
- (NSDictionary *)safeDictionaryValue
{
    return nil;
}

@end

#pragma mark - NSString
@implementation NSString (SafeAddition)

- (char)safeCharValue
{
    return [self intValue];
}
- (unsigned char)safeUnsignedCharValue
{
    return [self intValue];
}
- (short)safeShortValue
{
    return [self intValue];
}
- (unsigned short)safeUnsignedShortValue
{
    return [self intValue];
}
- (int)safeIntValue
{
    return [self intValue];
}
- (unsigned int)safeUnsignedIntValue
{
    return [self intValue];
}
- (long)safeLongValue
{
    return [self intValue];
}
- (unsigned long)safeUnsignedLongValue
{
    return [self intValue];
}
- (long long)safeLongLongValue
{
    return [self longLongValue];
}
- (unsigned long long)safeUnsignedLongLongValue
{
    return [self longLongValue];
}
- (float)safeFloatValue
{
    return [self floatValue];
}
- (double)safeDoubleValue
{
    return [self doubleValue];
}
- (BOOL)safeBoolValue
{
    return [self boolValue];
}

- (NSInteger)safeIntegerValue
{
    return [self integerValue];
}
- (NSUInteger)safeUnsignedIntegerValue
{
    return [self integerValue];
}

- (id)safeObjectForKey:(id)aKey
{
    return nil;
}

- (NSArray *)safeArrayValue
{
    return nil;
}
- (NSString *)safeStringValue
{
    return self;
}
- (NSNumber *)safeNumberValue
{
    return nil;
}
- (NSDictionary *)safeDictionaryValue
{
    return nil;
}

@end

#pragma mark - NSArray
@implementation NSArray (SafeAddition)

- (char)safeCharValue
{
    return 0;
}
- (unsigned char)safeUnsignedCharValue
{
    return 0;
}
- (short)safeShortValue
{
    return 0;
}
- (unsigned short)safeUnsignedShortValue
{
    return 0;
}
- (int)safeIntValue
{
    return 0;
}
- (unsigned int)safeUnsignedIntValue
{
    return 0;
}
- (long)safeLongValue
{
    return 0;
}
- (unsigned long)safeUnsignedLongValue
{
    return 0;
}
- (long long)safeLongLongValue
{
    return 0;
}
- (unsigned long long)safeUnsignedLongLongValue
{
    return 0;
}
- (float)safeFloatValue
{
    return 0;
}
- (double)safeDoubleValue
{
    return 0;
}
- (BOOL)safeBoolValue
{
    return 0;
}

- (NSInteger)safeIntegerValue
{
    return 0;
}
- (NSUInteger)safeUnsignedIntegerValue
{
    return 0;
}

- (id)safeObjectForKey:(id)aKey
{
    return nil;
}

- (NSString *)safeStringValue
{
    return nil;
}
- (NSArray *)safeArrayValue
{
    return self;
}
- (NSNumber *)safeNumberValue
{
    return nil;
}
- (NSDictionary *)safeDictionaryValue
{
    return nil;
}

@end

#pragma mark - NSDictionary
@implementation NSDictionary (SafeAddition)

- (char)safeCharValue
{
    return 0;
}
- (unsigned char)safeUnsignedCharValue
{
    return 0;
}
- (short)safeShortValue
{
    return 0;
}
- (unsigned short)safeUnsignedShortValue
{
    return 0;
}
- (int)safeIntValue
{
    return 0;
}
- (unsigned int)safeUnsignedIntValue
{
    return 0;
}
- (long)safeLongValue
{
    return 0;
}
- (unsigned long)safeUnsignedLongValue
{
    return 0;
}
- (long long)safeLongLongValue
{
    return 0;
}
- (unsigned long long)safeUnsignedLongLongValue
{
    return 0;
}
- (float)safeFloatValue
{
    return 0;
}
- (double)safeDoubleValue
{
    return 0;
}
- (BOOL)safeBoolValue
{
    return 0;
}

- (NSInteger)safeIntegerValue
{
    return 0;
}
- (NSUInteger)safeUnsignedIntegerValue
{
    return 0;
}

- (id)safeObjectForKey:(id)aKey
{
    return [self objectForKey:aKey];
}

- (NSString *)safeStringValue
{
    return nil;
}
- (NSArray *)safeArrayValue
{
    return nil;
}
- (NSNumber *)safeNumberValue
{
    return nil;
}
- (NSDictionary *)safeDictionaryValue
{
    return self;
}

@end
