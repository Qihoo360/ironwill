//
//  ABPerson+compare.m
//  QHContacts
//
//  Created by yanzhanlong on 16/3/3.
//  Copyright © 2016年 Qihoo. All rights reserved.
//
#import <objc/runtime.h>
#import "QHABPerson+compare.h"
#import "QHABMultiValue.h"
#import "NSCalendar+equalWithGranularity.h"
#import "QHABSource.h"


NSString const *isCompareExchangeSourceKey = @"isCompareExchangeSourceKey";
//NSString const *isCompareHaveExchangeSourceKey = @"isCompareHaveExchangeSourceKey";

@implementation ABPerson (compare)

-(BOOL) isExchangeSource {
    return [objc_getAssociatedObject(self, &isCompareExchangeSourceKey) boolValue];
}

-(void)setIsExchangeSource:(BOOL)exchangeSource
{
    objc_setAssociatedObject(self, &isCompareExchangeSourceKey, @(exchangeSource), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//-(BOOL) isHaveExchangeSource {
//    return [objc_getAssociatedObject(self, &isCompareHaveExchangeSourceKey) boolValue];
//}
//
//-(void)setIsHaveExchangeSource:(BOOL)exchangeSource
//{
//    objc_setAssociatedObject(self, &isCompareHaveExchangeSourceKey, @(exchangeSource), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (void)similarity:(ABPerson *)other callback:(SimilarityCompare) block {
    [self similarity:other update:NO callback:block];
}

- (BOOL)isEqualToContact:(ABPerson *)other {
    __block BOOL isSame = NO;
    [self similarity:other update:NO callback:^(NSInteger molecular, NSInteger denominator) {
        isSame = (molecular == denominator);
    }];
    return isSame;
}

- (BOOL)isEqualToContact:(ABPerson *)other byType:(ABPropertyID) typeID {
    __block BOOL isSame = NO;
    [self similarity:other type:typeID update:NO callback:^(NSInteger molecular, NSInteger denominator) {
        isSame = (molecular == denominator);
    }];
    return isSame;
}

- (void)similarity:(ABPerson *)other byType:(ABPropertyID) typeID callback:(SimilarityCompare) block {
    [self similarity:other type:typeID update:NO callback:block];
}

- (void)updateByABPerson:(ABPerson *)other {
    [self similarity:other update:YES callback:nil];
}

- (void)recoveryByABPerson:(ABPerson *)other {
    [self clearPropertyValues];
    [self updateByABPerson:other];
}

- (void)clearPropertyValues {
    
    const ABPropertyID props_ios5[] = {
        kABPersonFirstNameProperty,           // saved in [Contact contactWithABRecord:]
        kABPersonLastNameProperty,            // saved in [Contact contactWithABRecord:]
        kABPersonMiddleNameProperty,          // saved in [Contact contactWithABRecord:]
        kABPersonPrefixProperty,              // saved in [Contact contactWithABRecord:]
        kABPersonSuffixProperty,              // saved in [Contact contactWithABRecord:]
        kABPersonNicknameProperty,            // saved in [Contact contactWithABRecord:]
        kABPersonFirstNamePhoneticProperty,
        kABPersonLastNamePhoneticProperty,
        kABPersonMiddleNamePhoneticProperty,
        kABPersonOrganizationProperty,
        kABPersonJobTitleProperty,
        kABPersonDepartmentProperty,
        kABPersonEmailProperty,
        kABPersonBirthdayProperty,
        kABPersonNoteProperty,
        //kABPersonCreationDateProperty,        // ignore
        //kABPersonModificationDateProperty,    // ignore
        kABPersonAddressProperty,
        kABPersonDateProperty,
        //kABPersonKindProperty,                // ignore
        kABPersonPhoneProperty,               // ignore
        kABPersonInstantMessageProperty,        // saved in [Contact contactWithABRecord:]
        kABPersonURLProperty,
        kABPersonRelatedNamesProperty,
        kABPersonSocialProfileProperty
    };
    for (int i = 0; i < sizeof(props_ios5) / sizeof(ABPropertyID); i++) {
        id value = [self valueForProperty:props_ios5[i]];
        if(value) {
            if ([value isKindOfClass:[ABMultiValue class]]) {
                if ([(ABMultiValue *)value count] > 0) {
                    [self removeValueForProperty: props_ios5[i] error:nil];
                }
            } else {
                [self removeValueForProperty: props_ios5[i] error:nil];
            }
        }
    }
}

- (NSString *)trimPhoneNumber:(NSString *)sourcePhoneNumber {
    if (![sourcePhoneNumber isKindOfClass:[NSString class]]) {
        return @"";
    }
    if (sourcePhoneNumber.length == 0) {
        return sourcePhoneNumber;
    }
    
    NSString * phoneNumber = [sourcePhoneNumber stringByReplacingOccurrencesOfString:@"[^+0-9]+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, sourcePhoneNumber.length)];
    if (phoneNumber.length > 11) {
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"^(00|[+])[0-9]{2}" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, phoneNumber.length)];
    }
    return phoneNumber;
    
//    NSString *telNumber = sourcePhoneNumber;
//    
//    NSRange range = [sourcePhoneNumber rangeOfString:@"^[0-9+*#,;() \\-]+$" options:NSRegularExpressionSearch];
//    if (range.length == sourcePhoneNumber.length) {
//        telNumber =  [sourcePhoneNumber stringByReplacingOccurrencesOfString:@"[() \\-]" withString:@"" options:NSRegularExpressionSearch range:range];
//    }
//    
//    telNumber = [telNumber stringByReplacingOccurrencesOfString:@"^(00|[+])[0-9]{2}" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, telNumber.length)];
//    
//    return telNumber;
}

- (ABMultiValue *)replaceIMSystemLabel:(ABMultiValue *)value {
    if ([value count] == 0) {
        return value;
    }
    //根据号码生成标签
    //NSArray *systemArray = @[(__bridge_transfer NSString *)kABHomeLabel];
    
    ABMutableMultiValue *multivalue = [[ABMutableMultiValue alloc] initWithPropertyType:kABMultiDictionaryPropertyType];
    
    for (NSInteger index = 0; index < [value count]; index++) {
        //NSString *label = [value labelAtIndex:index];
        NSString *mail = [value valueAtIndex:index];
        [multivalue addValue:mail withLabel:(__bridge_transfer NSString *)kABPersonInstantMessageServiceKey identifier:nil];
    }
    
    return multivalue;
}

- (ABMultiValue *)replaceAddSystemLabel:(ABMultiValue *)value {
    if ([value count] == 0) {
        return value;
    }
    //根据号码生成标签
    //NSArray *systemArray = @[(__bridge_transfer NSString *)kABHomeLabel];
    
    ABMutableMultiValue *multivalue = [[ABMutableMultiValue alloc] initWithPropertyType:kABMultiDictionaryPropertyType];
    
    for (NSInteger index = 0; index < [value count]; index++) {
        //NSString *label = [value labelAtIndex:index];
        NSString *mail = [value valueAtIndex:index];
        [multivalue addValue:mail withLabel:(__bridge_transfer NSString *)kABHomeLabel identifier:nil];
    }
    
    return multivalue;
}

- (ABMultiValue *)replaceUrlSystemLabel:(ABMultiValue *)value {
    if ([value count] == 0) {
        return value;
    }
    //根据号码生成标签
    //NSArray *systemArray = @[(__bridge_transfer NSString *)kABHomeLabel];
    
    ABMutableMultiValue *multivalue = [[ABMutableMultiValue alloc] initWithPropertyType:kABMultiStringPropertyType];
    
    for (NSInteger index = 0; index < [value count]; index++) {
        //NSString *label = [value labelAtIndex:index];
        NSString *mail = [value valueAtIndex:index];
        [multivalue addValue:mail withLabel:(__bridge_transfer NSString *)kABPersonHomePageLabel identifier:nil];
    }
    
    return multivalue;
}

- (ABMultiValue *)replaceMailSystemLabel:(ABMultiValue *)value {
    if ([value count] == 0) {
        return value;
    }
    //根据号码生成标签
    //NSArray *systemArray = @[(__bridge_transfer NSString *)kABHomeLabel];
    
    ABMutableMultiValue *multivalue = [[ABMutableMultiValue alloc] initWithPropertyType:kABMultiStringPropertyType];
    
    for (NSInteger index = 0; index < [value count]; index++) {
        //NSString *label = [value labelAtIndex:index];
        NSString *mail = [value valueAtIndex:index];
        [multivalue addValue:mail withLabel:(__bridge_transfer NSString *)kABHomeLabel identifier:nil];
    }
    
    return multivalue; 
}

- (ABMultiValue *)replaceSystemLabel:(ABMultiValue *)value {
    if ([value count] == 0) {
        return value;
    }
    //根据号码生成标签
    NSArray *systemArray = @[(__bridge_transfer NSString *)kABHomeLabel,
                             (__bridge_transfer NSString *)kABWorkLabel,
                             (__bridge_transfer NSString *)kABOtherLabel,
                             (__bridge_transfer NSString *)kABPersonPhoneMobileLabel,
                             (__bridge_transfer NSString *)kABPersonPhoneIPhoneLabel,
                             (__bridge_transfer NSString *)kABPersonPhoneMainLabel,
                             (__bridge_transfer NSString *)kABPersonPhoneHomeFAXLabel,
                             (__bridge_transfer NSString *)kABPersonPhoneWorkFAXLabel,
                             (__bridge_transfer NSString *)kABPersonPhoneOtherFAXLabel,
                             (__bridge_transfer NSString *)kABPersonPhonePagerLabel];
    
    ABMutableMultiValue *multivalue = [[ABMutableMultiValue alloc] initWithPropertyType:kABMultiStringPropertyType];
    
    for (NSInteger index = 0; index < [value count]; index++) {
        NSString *label = [value labelAtIndex:index];
        NSString *phone = [value valueAtIndex:index];
        
        if ([systemArray containsObject:label]) {
            [multivalue addValue:phone withLabel:label identifier:nil];
        } else {
            NSString *tel = phone;
            // 替换label
            tel = [tel stringByReplacingOccurrencesOfString:@"[^+0-9]+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, tel.length)];
            if (tel.length > 11) {
                tel = [tel stringByReplacingOccurrencesOfString:@"^(00|[+])[0-9]{2}" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, tel.length)];
            }
            // 判断手机
            BOOL isMobile = (tel.length == 11 && [tel hasPrefix:@"1"]);
            NSString *newLabel = isMobile ? (__bridge_transfer NSString *)kABPersonPhoneMobileLabel : (__bridge_transfer NSString *)kABHomeLabel;
            [multivalue addValue:phone withLabel:newLabel identifier:nil];
        }
    }
    
    return multivalue;
}

- (void)similarity:(ABPerson *)other type:(ABPropertyID) typeID update:(BOOL)update callback:(SimilarityCompare) block {
    id selfCalue = [self valueForProperty:typeID];
    id otherCalue = [other valueForProperty:typeID];
    
    if (selfCalue && otherCalue) {
        if ([selfCalue isKindOfClass:[NSString class]]) {
            
            if ([selfCalue isEqualToString:otherCalue]) {
                if (block) {
                    block(1,1);
                }
            } else {
                //NSLog(@"%@,%@",selfCalue, otherCalue);
                if (update && otherCalue) {
                    [self setValue:otherCalue forProperty:typeID error:nil];
                }
                if (block) {
                    block(0,1);
                }
            }
        } else if([selfCalue isKindOfClass:[NSDate class]]) {
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            if ([calendar isDate:selfCalue equalToDate:otherCalue toUnitGranularity:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit ]) {
          
//            if ( [selfCalue isEqualToDate:otherCalue]) {
                if (block) {
                    block(1,1);
                }
             } else {
                if (update && otherCalue) {
                    [self setValue:otherCalue forProperty:typeID error:nil];
                }
                if (block) {
                    block(0,1);
                }
            }
        } else if([selfCalue isKindOfClass:[ABMultiValue class]]) {
            NSArray *selfValues = [selfCalue allValues];
            NSArray *otherValues = [otherCalue allValues];
            
            NSInteger maxCount = [selfValues count];
            if ([selfValues count] != [otherValues count]) {
                if (maxCount < [otherValues count]) {
                    maxCount = [otherValues count];
                }
            }
            
            if ([selfValues count] == 0 || [otherValues count] == 0) {
                if (update) {
                    if ([otherValues count] > 0) {
                        //判断exchange 
                        if ([self isExchangeSource]) {
                            if (typeID == kABPersonPhoneProperty) {
                                ABMultiValue *value = [self replaceSystemLabel:otherCalue];
                                [self setValue:value forProperty:typeID error:nil];
                            } else if (typeID == kABPersonEmailProperty) {
                                ABMultiValue *value = [self replaceMailSystemLabel:otherCalue];
                                [self setValue:value forProperty:typeID error:nil];
                            } else if (typeID == kABPersonURLProperty) {
                                ABMultiValue *value = [self replaceUrlSystemLabel:otherCalue];
                                [self setValue:value forProperty:typeID error:nil];
                            } else if (typeID == kABPersonAddressProperty) {
                                ABMultiValue *value = [self replaceAddSystemLabel:otherCalue];
                                [self setValue:value forProperty:typeID error:nil];
                            } else if (typeID == kABPersonInstantMessageProperty) {
                                ABMultiValue *value = [self replaceIMSystemLabel:otherCalue];
                                [self setValue:value forProperty:typeID error:nil];
                            } else{
                                [self setValue:otherCalue forProperty:typeID error:nil];
                            }
                            
                        } else {
                            [self setValue:otherCalue forProperty:typeID error:nil];
                        }
                    }
                }
                if (block) {
                    block(0,maxCount);
                }
            } else {
                
               __block NSInteger sameCount = 0;
                __block NSMutableArray *otherArray = [NSMutableArray array];
                
                if(typeID == kABPersonPhoneProperty) {
                    [otherValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [otherArray addObject:[self trimPhoneNumber:obj]];
                    }];
                } else {
                    [otherArray addObjectsFromArray:otherValues];
                }
                
                ABPropertyType type = [selfCalue propertyType];
                if (!(type & kABMultiValueMask)) {
                    type = type | kABMultiValueMask;
                }
                ABMutableMultiValue *otherCalueValues = [[ABMutableMultiValue alloc] initWithPropertyType:type];
               [otherCalueValues addMultiValue:otherCalue];
                
                [selfValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *item = obj;
                    if(typeID == kABPersonPhoneProperty) {
                        item = [self trimPhoneNumber:obj];
                    }
                    if ([otherArray containsObject:item]) {
                        sameCount++;
                        __block id selfObj = item;
                        //直接删除会导致相同的被全部删除
                        [otherArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj isEqual:selfObj]) {
                                [otherArray removeObjectsInRange:NSMakeRange(idx,1)];
                                *stop = YES;
                            }
                        }];
                        //[otherArray removeObject:obj];
                    } else {
                        NSString *label = [(ABMultiValue *)selfCalue labelAtIndex:idx];
                        [otherCalueValues addValue:item withLabel:label identifier:nil];
                    }
                }];
                if (sameCount != maxCount) {
                    if (update) {
                        if ([otherCalueValues count] > 0) {
                            //判断exchange
                            if ([self isExchangeSource]) {
                                
                                if (typeID == kABPersonPhoneProperty) {
                                    ABMultiValue *value = [self replaceSystemLabel:otherCalueValues];
                                    [self setValue:value forProperty:typeID error:nil];
                                } else if (typeID == kABPersonEmailProperty) {
                                    ABMultiValue *value = [self replaceMailSystemLabel:otherCalueValues];
                                    [self setValue:value forProperty:typeID error:nil];
                                } else if (typeID == kABPersonURLProperty) {
                                    ABMultiValue *value = [self replaceUrlSystemLabel:otherCalue];
                                    [self setValue:value forProperty:typeID error:nil];
                                } else if (typeID == kABPersonAddressProperty) {
                                    ABMultiValue *value = [self replaceAddSystemLabel:otherCalue];
                                    [self setValue:value forProperty:typeID error:nil];
                                } else if (typeID == kABPersonInstantMessageProperty) {
                                    ABMultiValue *value = [self replaceIMSystemLabel:otherCalue];
                                    [self setValue:value forProperty:typeID error:nil];
                                } else {
                                    [self setValue:otherCalueValues forProperty:typeID error:nil];
                                }
                                
                            } else {
                                [self setValue:otherCalueValues forProperty:typeID error:nil];
                            }
                            //[self setValue:otherCalueValues forProperty:typeID error:nil];
                        }
                    }
                }
                if (block) {
                    block(sameCount,maxCount);
                }
            }
        } else {
            //NSLog(@"%@",[selfCalue class]);
        }
    } else {
        if (update && otherCalue) {
             if ([self isExchangeSource]) {
                if (typeID == kABPersonPhoneProperty) {
                    ABMultiValue *value = [self replaceSystemLabel:otherCalue];
                    [self setValue:value forProperty:typeID error:nil];
                } else if (typeID == kABPersonEmailProperty) {
                    ABMultiValue *value = [self replaceMailSystemLabel:otherCalue];
                    [self setValue:value forProperty:typeID error:nil];
                } else if (typeID == kABPersonURLProperty) {
                    ABMultiValue *value = [self replaceUrlSystemLabel:otherCalue];
                    [self setValue:value forProperty:typeID error:nil];
                } else if (typeID == kABPersonAddressProperty) {
                    ABMultiValue *value = [self replaceAddSystemLabel:otherCalue];
                    [self setValue:value forProperty:typeID error:nil];
                } else if (typeID == kABPersonInstantMessageProperty) {
                    ABMultiValue *value = [self replaceIMSystemLabel:otherCalue];
                    [self setValue:value forProperty:typeID error:nil];
                } else{
                    [self setValue:otherCalue forProperty:typeID error:nil];
                }
                
            } else {
                [self setValue:otherCalue forProperty:typeID error:nil];
            }
            //[self setValue:otherCalue forProperty:typeID error:nil];
        }
        NSInteger maxCount = 0;
        if (selfCalue || otherCalue) {
            if([selfCalue isKindOfClass:[NSString class]] || [otherCalue isKindOfClass:[NSString class]]) {
                if ([selfCalue length] == 0 && [otherCalue length] == 0) {
                    //NSLog(@"空字符串");
                } else {
                    //NSLog(@"%@,%@",selfCalue, otherCalue);
                     maxCount = 1;
                }
            } else if([selfCalue isKindOfClass:[ABMultiValue class]] || [otherCalue isKindOfClass:[ABMultiValue class]]){
                if ([selfCalue count] == 0 && [otherCalue count] == 0) {
                    //NSLog(@"空字符串");
                } else {
                    maxCount = 1;
                }
            } else {
                maxCount = 1;
            }
        }
        //
        
        if (block) {
            block(0,maxCount);
        }
    }
}

- (void)similarity:(ABPerson *)other update:(BOOL)update callback:(SimilarityCompare) block {
 
    [self setIsExchangeSource:[ABSource isAllExchange]];
    
    __block NSInteger iSameSimilarity = 0;
    __block NSInteger iMaxSimilarity = 0;
    
    if ([[self name] isEqualToString:[other name]]) {
        iSameSimilarity += 1;
        iMaxSimilarity += 1;
    } else {
        iMaxSimilarity += 1;
    }
 
    const ABPropertyID props_ios5[] = {
        kABPersonFirstNameProperty,           // saved in [Contact contactWithABRecord:]
        kABPersonLastNameProperty,            // saved in [Contact contactWithABRecord:]
        kABPersonMiddleNameProperty,          // saved in [Contact contactWithABRecord:]
        kABPersonPrefixProperty,              // saved in [Contact contactWithABRecord:]
        kABPersonSuffixProperty,              // saved in [Contact contactWithABRecord:]
        kABPersonNicknameProperty,            // saved in [Contact contactWithABRecord:]
        kABPersonFirstNamePhoneticProperty,
        kABPersonLastNamePhoneticProperty,
        kABPersonMiddleNamePhoneticProperty,
        kABPersonOrganizationProperty,
        kABPersonJobTitleProperty,
        kABPersonDepartmentProperty,
        kABPersonEmailProperty,
        kABPersonBirthdayProperty,
        kABPersonNoteProperty,
        //kABPersonCreationDateProperty,        // ignore
        //kABPersonModificationDateProperty,    // ignore
        kABPersonAddressProperty,
        kABPersonDateProperty,
        //kABPersonKindProperty,                // ignore
        kABPersonPhoneProperty,               // ignore
        kABPersonInstantMessageProperty,        // saved in [Contact contactWithABRecord:]
        kABPersonURLProperty,
        kABPersonRelatedNamesProperty,
        kABPersonSocialProfileProperty
    };
    for (int i = 0; i < sizeof(props_ios5) / sizeof(ABPropertyID); i++) {
        //NSLog(@"%d %d",i,props_ios5[i]);
        [self similarity:other type:props_ios5[i] update:update callback:^(NSInteger molecular, NSInteger denominator) {
            iSameSimilarity += molecular;
            iMaxSimilarity += denominator;
        }];
    }
    
//    BOOL selfHasImage = [self hasImageData];
//    BOOL otherHasImage = [other hasImageData];
//    if (selfHasImage || otherHasImage) {
//        iMaxSimilarity += 1;
//        if (selfHasImage == otherHasImage) {
//            iSameSimilarity += 1;
//        } else {
//            //有一个没有头像
//            if(otherHasImage && update) {
//                [self setImageData:[other imageData] error:nil];
//            }
//        }
//    }
    //NSLog(@"%@ %ld / %ld",[self name],iSameSimilarity,iMaxSimilarity);
    if (block) {
        block(iSameSimilarity,iMaxSimilarity);
    }
}

@end
