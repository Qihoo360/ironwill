//
//  QHContactProperty.m
//  QHContacts
//
//  Created by yanzhanlong on 16/4/1.
//  Copyright © 2016年 Qihoo. All rights reserved.
//
#import <AddressBookUI/AddressBookUI.h>
#import "QHContactProperty.h"

#define CONTACT_PROPERTY_KEY_ID             @"k1"
#define CONTACT_PROPERTY_KEY_LABEL          @"k2"
#define CONTACT_PROPERTY_KEY_VALUE          @"k3"

@interface QHContactProperty()

@property (nonatomic, strong) NSString *valueForSort;
@property (nonatomic, strong) NSString *displayLabel;
@property (nonatomic, strong) NSString *displayValue;

#if SHOW_PHONE_NUMBER_LOCATION
@property (nonatomic, strong) NSString *displayLabelWithLocation;
#endif

@end

@implementation QHContactProperty

#pragma mark phone number

+ (NSString *)trimPhoneNumber:(NSString *)sourcePhoneNumber {
    if (sourcePhoneNumber.length == 0) {
        return sourcePhoneNumber;
    }
    
    NSRange range =NSMakeRange(0,sourcePhoneNumber.length);// [sourcePhoneNumber rangeOfString:@"^[0-9+*#,;() \\-]+$" options:NSRegularExpressionSearch];
   // if (range.length == sourcePhoneNumber.length) {
        sourcePhoneNumber = [sourcePhoneNumber stringByReplacingOccurrencesOfString:@"[\\s () \\- ]" withString:@"" options:NSRegularExpressionSearch range:range];
    //}
    
    sourcePhoneNumber = [sourcePhoneNumber stringByReplacingOccurrencesOfString:@"^(00|[+])[0-9]{2}" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, sourcePhoneNumber.length)];
    
    if(sourcePhoneNumber.length == 13) {
        if([sourcePhoneNumber hasPrefix:@"86"]) {
            sourcePhoneNumber = [sourcePhoneNumber substringFromIndex:2];
        }
    }
 
    return sourcePhoneNumber;
}

-(id)copyWithZone:(NSZone *)zone
{
    QHContactProperty *copy =[QHContactProperty property:self.propertyID
                                               withValue:self.propertyValue
                                                forLabel:self.propertyLabel];
    return copy;
}

#pragma mark compare

- (NSUInteger)hash {
    return self.propertyID + self.valueForSort.hash + self.propertyLabel.hash;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[QHContactProperty class]]) {
        return [self isEqualToProperty:object];
    } else {
        return NO;
    }
}

- (BOOL)isEqualToProperty:(QHContactProperty *)object {
    
    if (_propertyID != object.propertyID) {
        return NO;
    }
    
    NSString *label1 = _propertyLabel ?: @"";
    NSString *label2 = object.propertyLabel ?: @"";
    if (![label1 isEqualToString:label2]) {
        return NO;
    }
    
    id value1 = _propertyValue;
    id value2 = object.propertyValue;
    if (value1 || value2) {
        
        if ([value1 isKindOfClass:[NSDictionary class]] &&
            [value2 isKindOfClass:[NSDictionary class]]) {
            
            NSArray *keys = [value1 allKeys];
            if (keys.count != [value2 allKeys].count) {
                return NO;
            }
            
            for (id key in keys) {
                id v1 = value1[key];
                id v2 = value2[key];
                
                if ([v1 isKindOfClass:[NSDate class]] &&
                    [v2 isKindOfClass:[NSDate class]]) {
                    if (![[v1 description] isEqualToString:[v2 description]]) {
                        return NO;
                    }
                    
                } else {
                    
                    if (![v1 isEqual:v2]) {
                        return NO;
                    }
                }
            }
            
        } else if ([value1 isKindOfClass:[NSDate class]] &&
                   [value2 isKindOfClass:[NSDate class]]) {
            if (![[value1 description] isEqualToString:[value2 description]]) {
                return NO;
            }
            
        } else {
            
            if (![value1 isEqual:value2]) {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark encode & decode

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt32:_propertyID forKey:CONTACT_PROPERTY_KEY_ID];
    [aCoder encodeObject:_propertyLabel forKey:CONTACT_PROPERTY_KEY_LABEL];
    [aCoder encodeObject:_propertyValue forKey:CONTACT_PROPERTY_KEY_VALUE];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        _propertyID = [aDecoder decodeInt32ForKey:CONTACT_PROPERTY_KEY_ID];
        _propertyLabel = [aDecoder decodeObjectForKey:CONTACT_PROPERTY_KEY_LABEL];
        _propertyValue = [aDecoder decodeObjectForKey:CONTACT_PROPERTY_KEY_VALUE];
        _valueForSort = nil;
    }
    return self;
}

#pragma mark sort

+ (NSArray *)sortDescriptors {
    static NSArray * sortDescriptors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sortDescriptors = [[NSArray alloc] initWithObjects:
                           [NSSortDescriptor sortDescriptorWithKey:@"propertyID" ascending:YES],
                           [NSSortDescriptor sortDescriptorWithKey:@"valueForSort" ascending:YES],
                           [NSSortDescriptor sortDescriptorWithKey:@"propertyLabel" ascending:YES],
                           nil];
    });
    
    return sortDescriptors;
}

- (void)setPropertyValue:(id)propertyValue {
    _propertyValue = propertyValue;
    _valueForSort = nil;
}

- (NSString *)valueForSort {
    if (!_valueForSort) {
        if ([_propertyValue isKindOfClass:[NSDictionary class]]) {
            //
            // assume there's no '\n' in dictionary values
            //
            NSArray *array = [[_propertyValue description] componentsSeparatedByString:@"\n"];
            array = [array sortedArrayUsingSelector:@selector(localizedCompare:)];
            _valueForSort = array.description;
        } else {
            _valueForSort = _propertyValue;
        }
    }
    return _valueForSort;
}

#pragma mark instance


+ (instancetype)propertyByType:(ABPropertyID)propertyID
                      withValue:(id)propertyValue
                       forLabel:(NSString *)propertyLabel {
    
#if DISMISS_EMPTY_STRING_VALUE
    //NSLog(@"propertyValue = %@",propertyValue);
    
    if ([propertyValue isKindOfClass:[NSString class]] &&
        [(NSString *)propertyValue length] == 0) {
        return nil;
    }
#endif
    
#if DISMISS_EMPTY_STRING_VALUE
    if ([propertyValue isKindOfClass:[NSDictionary class]]) {
        BOOL changed = NO;
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        NSArray *allKeys = [propertyValue allKeys];
        for (id key in allKeys) {
            
#if DISMISS_ADDRESS_DISPLAY_NAME
            if ([key isEqualToString:PERSON_ADDRESS_PROPERTY_VALUE_KEY_DISPLAYNAME]) {
                continue;
            }
#endif
            
            id value = propertyValue[key];
            
            //NSLog(@"value = %@",value);
            
            if ([value isKindOfClass:[NSString class]] &&
                [value length] == 0) {
                changed = YES;
                continue;
            } else {
                dictionary[key] = value;
            }
        }
        
        if (dictionary.allKeys.count == 0) {
            return nil;
        }
        
        if (changed) {
            return [QHContactProperty property:propertyID
                                     withValue:dictionary
                                      forLabel:propertyLabel];
        }
    }
#endif
    
    return [QHContactProperty property:propertyID
                             withValue:propertyValue
                              forLabel:propertyLabel];
}


+ (instancetype)property:(ABPropertyID)propertyID
               withValue:(id)propertyValue
                forLabel:(NSString *)propertyLabel {
    QHContactProperty *property = [[QHContactProperty alloc] init];
    property.propertyID = propertyID;
    property.propertyLabel = propertyLabel;
    property.propertyValue = propertyValue;
    return property;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"(%d, %@) - %@", self.propertyID, self.propertyLabel, self.propertyValue];
}

#pragma mark properties for display

- (NSString *)displayName {
    static NSDictionary *id2Name = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *dictionary = @{
                                     @(kABPersonNicknameProperty): @"昵称",
                                     @(kABPersonPhoneProperty): @"电话",
                                     @(kABPersonOrganizationProperty): @"公司",
                                     @(kABPersonJobTitleProperty): @"职务",
                                     @(kABPersonDepartmentProperty): @"部门",
                                     @(kABPersonEmailProperty): @"电子邮件",
                                     @(kABPersonBirthdayProperty): @"生日",
                                     @(kABPersonNoteProperty): @"备注",
                                     @(kABPersonAddressProperty): @"地址",
                                     @(kABPersonDateProperty): @"日期",
                                     @(kABPersonInstantMessageProperty): @"即时聊天通信",
                                     @(kABPersonURLProperty): @"URL",
                                     @(kABPersonRelatedNamesProperty): @"关联人",
                                     @(kABPersonSocialProfileProperty): @"社交信息",
                                     };
        id2Name = [[NSDictionary alloc] initWithDictionary:dictionary];
    });
    NSString *name = id2Name[@(self.propertyID)];
    return name ?: @"其它属性";
}

- (NSString *)displayLabel {
    if (!_displayLabel) {
        if ([_propertyLabel isKindOfClass:[NSString class]] && _propertyLabel.length > 0) {
            _displayLabel = (__bridge_transfer id)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)_propertyLabel);
        } else {
            _displayLabel = @"";
        }
    }
    return _displayLabel;
}

#if SHOW_PHONE_NUMBER_LOCATION
- (NSString *)displayLabelWithLocation {
    if (!_displayLabelWithLocation) {
        _displayLabelWithLocation = self.displayLabel;
        
        if (_propertyID == kABPersonPhoneProperty) {
            NSString *province = nil;
            NSString *city     = nil;
            NSString *provider = nil;
            if ([_propertyValue sKindOfClass:[NSString class]]) {
                NSLog(@"displayLabelWithLocation %@",_propertyValue);
                NSString *tel      = [_propertyValue stringByReplacingOccurrencesOfString:@"[^+0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_propertyValue length])];
                NSData   *data     = [tel dataUsingEncoding:NSUTF8StringEncoding];
                [[QHPhoneNumberLocation getInstance] getLocation:(const char *)data.bytes
                                                        province:&province
                                                            city:&city
                                                        provider:&provider];
                NSString *suffix = @"";
                if (city.length > 0 || province.length > 0) {
                    suffix = (city.length > 0) ? city : province;
                }
                if (provider.length > 0) {
                    suffix = [suffix stringByAppendingFormat:@"-%@", provider];
                }
                if (suffix.length > 0) {
                    _displayLabelWithLocation = [self.displayLabel stringByAppendingFormat:@"(%@)", suffix];
                }
            } 
        }
    }
    return _displayLabelWithLocation;
}
#endif

- (NSString *)displayValue {
    static NSCharacterSet *addressDelimiters = nil;
    static NSArray *sortedKeys = nil;
    static NSDictionary *dictKey2Label = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        addressDelimiters = [NSCharacterSet characterSetWithCharactersInString:@" \t\r\n"];
        
        NSArray *array = @[
                           // Address
                           (__bridge id)kABPersonAddressStreetKey,
                           (__bridge id)kABPersonAddressCityKey,
                           (__bridge id)kABPersonAddressStateKey,
                           (__bridge id)kABPersonAddressZIPKey,
                           (__bridge id)kABPersonAddressCountryKey,
                           (__bridge id)kABPersonAddressCountryCodeKey,
                           // IM
                           (__bridge id)kABPersonInstantMessageServiceKey,
                           (__bridge id)kABPersonInstantMessageUsernameKey,
                           // Social
                           (__bridge id)kABPersonSocialProfileURLKey,
                           (__bridge id)kABPersonSocialProfileServiceKey,
                           (__bridge id)kABPersonSocialProfileUsernameKey,
                           (__bridge id)kABPersonSocialProfileUserIdentifierKey,
                           ];
        sortedKeys = [[NSArray alloc] initWithArray:array];
        
        NSDictionary *dict = @{
                               // Address
                               (__bridge id)kABPersonAddressStreetKey:
                                   @"街道",
                               (__bridge id)kABPersonAddressCityKey:
                                   @"城市",
                               (__bridge id)kABPersonAddressStateKey:
                                   @"省份",
                               (__bridge id)kABPersonAddressZIPKey:
                                   @"邮编",
                               (__bridge id)kABPersonAddressCountryKey:
                                   @"国家",
                               (__bridge id)kABPersonAddressCountryCodeKey:
                                   @"国家码",
                               // IM
                               (__bridge id)kABPersonInstantMessageServiceKey:
                                   @"服务",
                               (__bridge id)kABPersonInstantMessageUsernameKey:
                                   @"用户名",
                               // Social
                               (__bridge id)kABPersonSocialProfileURLKey:
                                   @"URL",
                               (__bridge id)kABPersonSocialProfileServiceKey:
                                   @"服务",
                               (__bridge id)kABPersonSocialProfileUsernameKey:
                                   @"用户名",
                               (__bridge id)kABPersonSocialProfileUserIdentifierKey:
                                   @"ID",
                               };
        dictKey2Label = [[NSDictionary alloc] initWithDictionary:dict];
    });
    
    if (!_displayValue && _propertyValue) {
        if (_propertyID == kABPersonAddressProperty) {
            NSString *address = ABCreateStringWithAddressDictionary(_propertyValue, NO);
            _displayValue = [[address componentsSeparatedByCharactersInSet:addressDelimiters] componentsJoinedByString:@","] ;
            return _displayValue;
        }
        if (_propertyID == kABPersonInstantMessageProperty) {
            id value = _propertyValue[(__bridge id)kABPersonInstantMessageUsernameKey];
            if ([value isKindOfClass:[NSString class]]) {
                _displayValue = value;
            } else {
                _displayValue = [value stringValue];
            }
            return _displayValue;
        }
        switch (ABPersonGetTypeOfProperty(_propertyID) & ~kABMultiValueMask) {
            case kABStringPropertyType:
//                if ([_propertyValue isKindOfClass:[NSString class]]) {
                    _displayValue = _propertyValue;
//                } else {
//                    if ([_propertyValue isKindOfClass:[NSDictionary class]]) {
//                        NSMutableArray *array = [NSMutableArray array];
//                        id value = nil;
//                        for (NSString *key in sortedKeys) {
//                            value = _propertyValue[key];
//                            if (value) {
//                                [array addObject:[NSString stringWithFormat:@"%@",
//                                                  value]];
//                            }
//                        }
//                        if (array.count > 0) {
//                            _displayValue = [array componentsJoinedByString:@" , "];
//                        }
//                    } else {
//                        _displayValue = [NSString stringWithFormat:@"%@",_propertyValue];
//                    }
//                }
                break;
            case kABIntegerPropertyType:
                _displayValue = [(NSNumber *)_propertyValue stringValue];
                break;
            case kABRealPropertyType:
                _displayValue = [(NSNumber *)_propertyValue stringValue];
                break;
            case kABDateTimePropertyType:
                _displayValue = [NSDateFormatter localizedStringFromDate:_propertyValue dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
                break;
            case kABDictionaryPropertyType:
            {
                NSMutableArray *array = [NSMutableArray array];
                id value = nil;
                for (NSString *key in sortedKeys) {
                    value = _propertyValue[key];
                    if (value) {
                        [array addObject:[NSString stringWithFormat:@"%@(%@)",
                                          value,
                                          dictKey2Label[key]]];
                    }
                }
                if (array.count > 0) {
                    _displayValue = [array componentsJoinedByString:@" , "];
                }
            }
                break;
            default:
                break;
        }
    }
    return _displayValue;
}
 
@end
