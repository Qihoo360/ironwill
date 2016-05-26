//
//  VCard.h
//  App360Contacts
//
//  Created by Zhang Liang on 5/13/11.
//  Copyright 2013 RebornInfo Co.,Ltd. All right reserved.
//

#import <Foundation/Foundation.h>

@interface VCardProperty : NSObject {
	NSString *key;
	NSString *value;
}

@property(nonatomic, retain) NSString *key;
@property(nonatomic, retain) NSString *value;

+ (id)propertyWithString:(NSString *)propertyString;

@end


@interface VCardLabel : NSObject {
	NSString *name;
	NSArray *properties;
}

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSArray *properties;

+ (id)labelWithString:(NSString *)labelString;

@end


@interface VCardValue : NSObject {
	NSString *value;
	NSArray *values;
}
@property(nonatomic, retain) NSString *value;
@property(nonatomic, retain) NSArray *values;

+ (id)valueWithString:(NSString *)valueString;
+ (id)valueWithString:(NSString *)valueString forceValueString:(BOOL)force;

@end

@interface VCardItem : NSObject {
	VCardLabel *label;
	VCardValue *value;
}
@property(nonatomic, retain) VCardLabel *label;
@property(nonatomic, retain) VCardValue *value;

+ (id)itemWithString:(NSString *)itemString;
+ (id)itemWithString:(NSString *)itemString forceValueString:(BOOL)force;
- (BOOL)isQuotedPrintable;
@end

@interface VCard : NSObject {
}

+ (NSDictionary *)dictionaryFromVCardDateString:(VCardValue *)value;

+ (NSDate *)dateFromVCardDateString:(NSString *)vcardDateString;
+ (id)quotatedPrintableString:(NSString *)s isRealQuoted:(BOOL *)isRealQuoted;
+ (id)utf8Decode:(NSString *)s;
+ (BOOL)isQuatedPrintable:(VCardLabel *)label;
+ (CFStringRef)labelCategory:(VCardLabel *)label;
+ (CFStringRef)telLabelCategory:(VCardLabel *)label;
+ (CFStringRef)dateLabelCategory:(VCardLabel *)label;
+ (id)utf8EncodeForVcard:(NSString *)s;
+ (id)quotatedDecode:(NSString *)s;
//+ (void)test;
+ (CFStringRef)labelPersonCategory:(VCardLabel *)label;
@end