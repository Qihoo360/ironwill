//
//  ABRecord+vCard.m
//  QHContacts
//
//  Created by yanzhanlong on 16/2/18.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABRecord+vCard.h"
#import "QHVCard.h"
#import "QHABConfigure.h"
#import "QHABMultiValue.h"
#import "QHABMutableMultiValue+vCard.h"
#import "QHABRecord.h"

#define LabelEqual(a,b) [(__bridge NSString *)a isEqualToString:(NSString *)b]

@implementation ABRecord (vCard)

- (NSString*)replaceString:(NSString*)realString
{
    return [realString stringByReplacingOccurrencesOfString:@";" withString:@"\\;"];
}
 
- (NSString *)formateABRecordLabel:(CFStringRef)labelText {
    NSString *labelValue = @"";
    
    if (LabelEqual(labelText, kABHomeLabel)) {
        labelValue = LabelCategoryHome;
    } else if(LabelEqual(labelText, kABWorkLabel)) {
        labelValue = LabelCategoryWork;
    } else if (LabelEqual(labelText, kABOtherLabel)) {
        labelValue = LabelCategoryOther;
    } else if (LabelEqual(labelText, kABPersonPhoneMobileLabel)) {
        labelValue = LabelCategoryCell;
    } else if (LabelEqual(labelText, kABPersonPhoneMainLabel)) {
        labelValue = LabelCategoryMain;
    } else if (LabelEqual(labelText, kABPersonPhoneWorkFAXLabel) ) {
        labelValue = @"WORK;FAX";
    } else if (LabelEqual(labelText, kABPersonPhonePagerLabel)) {
        labelValue = LabelCategoryPager;
    } else if (LabelEqual(labelText, kABPersonPhoneHomeFAXLabel)) {
        labelValue = @"HOME;FAX";
    } else if (LabelEqual(labelText, kABPersonPhoneIPhoneLabel)) {
        labelValue = LabelCategoryIPhone;
    } else if (LabelEqual(labelText, kABPersonPhoneOtherFAXLabel)) {
        labelValue = LabelCategoryOtherFAX;
    } else if (LabelEqual(labelText, kABPersonAnniversaryLabel)) {
        labelValue = LabelCategoryAnniversary;
    } else if(LabelEqual(labelText, kABPersonFatherLabel)){
        return FATHER;
    } else if(LabelEqual(labelText, kABPersonMotherLabel)){
        return MOTHER;
    } else if(LabelEqual(labelText, kABPersonParentLabel)){
        return PARENT;
    } else if(LabelEqual(labelText, kABPersonBrotherLabel)){
        return BROTHER;
    } else if(LabelEqual(labelText, kABPersonSisterLabel)){
        return SISTER;
    } else if(LabelEqual(labelText, kABPersonChildLabel)){
        return CHILD;
    } else if(LabelEqual(labelText, kABPersonFriendLabel)){
        return FRIEND;
    } else if(LabelEqual(labelText, kABPersonSpouseLabel)){
        return SPOUSE;
    } else if(LabelEqual(labelText, kABPersonPartnerLabel)){
        return PARTNER;
    } else if(LabelEqual(labelText, kABPersonAssistantLabel)){
        return ASSISTANT;
    } else if(LabelEqual(labelText, kABPersonManagerLabel)){
        return MANAGER;
    } else {
        labelValue = (__bridge NSString *)(labelText);//[NSString stringWithFormat:@"%@%@",CUSTOM_ANDROID,labelText];
    }
    return labelValue;
}

- (BOOL)isMultiValueProperty: (ABPropertyID)property
{
    ABPropertyType type = ABPersonGetTypeOfProperty(property);
    return ((type & kABMultiValueMask) == kABMultiValueMask);
}

- (NSString *)vcardStringValue:(NSString *)value {
    NSMutableString *formattedVcard = [NSMutableString string];
    BOOL isRealQuoted = NO;
    NSString* ret =  [VCard quotatedPrintableString:[self replaceString:value] isRealQuoted:&isRealQuoted];
    if (isRealQuoted) {
        [formattedVcard appendString:@";ENCODING=QUOTED-PRINTABLE;CHARSET=UTF-8:"];
    } else {
        [formattedVcard appendString:@";ENCODING=QUOTED-PRINTABLE:"];
    }
    [formattedVcard appendFormat:@"%@\r\n",ret];
    return formattedVcard;
}

- (NSString *)vcardString:(NSString *)labelText value:(NSString *)value {
    NSMutableString *formattedVcard = [NSMutableString string];
    BOOL isRealQuoted = NO;
    NSString*ret = [VCard quotatedPrintableString:[self replaceString:(NSString*)value] isRealQuoted:&isRealQuoted];
    if(isRealQuoted) {
        if (labelText) {
            [formattedVcard appendFormat:@";%@;ENCODING=QUOTED-PRINTABLE;CHARSET=UTF-8:%@\r\n",[self formateABRecordLabel:(__bridge CFStringRef)(labelText)], ret];
        } else {
            [formattedVcard appendFormat:@";ENCODING=QUOTED-PRINTABLE;CHARSET=UTF-8:%@\r\n", ret];
        }
    } else {
        if (labelText) {
            [formattedVcard appendFormat:@";%@:%@\r\n",[self formateABRecordLabel:(__bridge CFStringRef)(labelText)], ret];
        } else {
            [formattedVcard appendFormat:@":%@\r\n", ret];
        }
    }
    
    return formattedVcard;
} 

- (NSString*)vcardString:(NSString *)title property:(ABPropertyID)property customizeValues:(Customize)customizeValus{
    
    NSMutableString *formattedVcard = [NSMutableString string];
  
    id abValue = [self valueForProperty:property];
    if (abValue != NULL) { 
        if ([abValue isKindOfClass:[ABMultiValue class]]) {
            NSInteger count = [abValue count];
            
            for (NSInteger index = 0; index<count; index++) {
                [formattedVcard appendString:title];
                NSString *labelText = [abValue labelAtIndex:index];
                id value = [(ABMultiValue *)abValue valueAtIndex:index];
                
                if ([value isKindOfClass:[NSString class]]) {
                    [formattedVcard appendString:[self vcardString:labelText value:value]];
                } else if ([value isKindOfClass:[NSDate class]]) {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    if(property == kABPersonModificationDateProperty) {
                        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];//
                    } else {
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];//yyyyMMddHHmmss
                    }
                    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *timeStr = [dateFormatter stringFromDate:(NSDate*)value];
                    if ([timeStr hasPrefix:@"1604-"]) {
                        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"1604-" withString:@"--" ];
                    }
                    [formattedVcard appendString:[self vcardString:labelText value:timeStr]];
                } else {
                    if (customizeValus) {
                        [formattedVcard appendString:customizeValus(labelText,value)];
                    }
                }
            }
        } else if ([abValue isKindOfClass:[NSString class]]) {
            [formattedVcard appendString:title];
            [formattedVcard appendString:[self vcardStringValue:abValue]];
        } else if ([abValue isKindOfClass:[NSDate class]]) {
            [formattedVcard appendString:title];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];//yyyyMMddHHmmss
            dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            NSString *timeStr = [dateFormatter stringFromDate:(NSDate*)abValue];
            if ([timeStr hasPrefix:@"1604-"]) {
                timeStr = [timeStr stringByReplacingOccurrencesOfString:@"1604-" withString:@"--" ];
            }
            
            [formattedVcard appendString:[self vcardStringValue:timeStr]];
        }
    }
    
    return formattedVcard;
}

- (void)vcardStringToRecord:(NSString *)value property:(ABPropertyID)property label:(NSString *)label{
    VCardItem * item = [VCardItem itemWithString:value forceValueString:YES];// [VCardItem itemWithString:value];
    
//    if ([item.value.values isKindOfClass:[NSArray class]] && [item.value.values count] > 0) {
//        ABMutableMultiValue *values = [[ABMutableMultiValue alloc] initWithPropertyType:kABMultiStringPropertyType];
//        [values vcardStringToRecord:item.value.values label:label];
//        [self setValue:values forProperty:property error:nil];
//    } else {
//        if(property == kABPersonBirthdayProperty || kABPersonDateProperty == property) {
//           
//            NSDate *itemDate = [VCard dateFromVCardDateString:item.value.value];
//            if (itemDate) {
//                [self setValue:itemDate forProperty:property error:nil];
//            } else {
//                //日期格式不对
//            }
//        } else {
            BOOL quatedPrintable = [VCard isQuatedPrintable:item.label];
            
            if(quatedPrintable) {
                [self setValue:[VCard utf8Decode:item.value.value] forProperty:property error:nil];
            } else if(item.value.value){
                [self setValue:item.value.value forProperty:property error:nil];
            }
//        }
//    }
}

- (void)vcardStringToDateRecord:(NSString *)value property:(ABPropertyID)property {
    VCardItem * item = [VCardItem itemWithString:value];
    NSDate *itemDate = [VCard dateFromVCardDateString:item.value.value];
    if (itemDate) {
        [self setValue:itemDate forProperty:property error:nil];
    }
}

- (void)vcardStringToMultiRecord:(NSArray *)value property:(ABPropertyID)property outValues:(ToABMultiValue) outValus {
    if ([value isKindOfClass:[NSArray class]]) {
        if ([value count] > 0) {
            
            ABPropertyType type = kABMultiStringPropertyType;
            if (kABPersonAddressProperty == property
                || kABPersonInstantMessageProperty == property
                || kABPersonSocialProfileProperty == property) {
                type = kABMultiDictionaryPropertyType;
            } else if(kABPersonDateProperty == property) {
                type = kABMultiDateTimePropertyType;
            } else {
                
            } 
            __block ABMutableMultiValue *values = [[ABMutableMultiValue alloc] initWithPropertyType:type];
            if (outValus) {
                outValus(value,values);
            } else {
                [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    VCardItem * item = [VCardItem itemWithString:obj forceValueString:YES];
                    BOOL quatedPrintable = [VCard isQuatedPrintable:item.label];
                    NSString *valueToAdd = item.value.value;
                    if(quatedPrintable){
                        NSString *utf8String = [VCard utf8Decode:item.value.value];
                        valueToAdd = utf8String;
                    }
                    CFStringRef labelCategory = nil;
                    if (kABPersonPhoneProperty == property) {
                        labelCategory = [VCard telLabelCategory:item.label];
                    } else if(kABPersonDateProperty == property) {
                        labelCategory = [VCard dateLabelCategory:item.label];
                    } else {
                        labelCategory = [VCard labelPersonCategory:item.label];
                    }
                    
                    if (valueToAdd) {
                        if(property == kABPersonBirthdayProperty || kABPersonDateProperty == property
                           || kABPersonAlternateBirthdayProperty == property) {
                            NSDate *itemDate = [VCard dateFromVCardDateString:item.value.value];
                            if (itemDate) {
                                [values addValue:itemDate withLabel:(__bridge NSString *)(labelCategory) identifier:nil];
                            } else {
                                [values addValue:valueToAdd withLabel:(__bridge NSString *)(labelCategory) identifier:nil];
                            }
                        } else {
                            [values addValue:valueToAdd withLabel:(__bridge NSString *)(labelCategory) identifier:nil];
                        }
                    }
                }];
            }
            [self setValue:values forProperty:property error:nil];
        }
    } else {
        NSLog(@"class error");
    }
}

- (void)vcardStringToMultiRecord:(NSArray *)value property:(ABPropertyID)property {
    [self vcardStringToMultiRecord:value property:property outValues:nil];
}

@end
