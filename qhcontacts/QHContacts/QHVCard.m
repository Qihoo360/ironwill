//
//  VCardLabel.m
//  App360Contacts
//
//  Created by Zhang Liang on 5/13/11.
//  Copyright 2013 RebornInfo Co.,Ltd. All right reserved.
//

#import "QHVCard.h"
#import "QHABConfigure.h"
#import <AddressBook/AddressBook.h>
 
const unsigned char u_hex_upper[17] = "0123456789ABCDEF";

uint32_t u_quoted_printable_encode(const unsigned char* inptr, uint32_t len, unsigned char* output, BOOL *isRealQuoted)
{
    int n = 0;
    unsigned char ch, ws  = '\0';
    unsigned char* outptr = output;
    const unsigned char* inend  = inptr + len;
    BOOL isQuoted = NO;
    //    U_INTERNAL_TRACE("u_quoted_printable_encode(%.*s,%u,%p)", len, inptr, len, out)
    //    
    //    U_INTERNAL_ASSERT_POINTER(inptr)
    while (inptr < inend)
    {
        ch = *inptr++;
        switch (ch)
        {
//            case ' ':
            case '\t':
            {
                if (ws)
                {
                    *outptr++ = ws;
                    
                    n += 1;
                }
                
                ws = ch;
            }
                break;
                
//            case '\r':
//            case '\n':
//            {
//                if (ws)
//                {
//                    *outptr++ = '=';
//                    *outptr++ = u_hex_upper[(ws >> 4) & 0xf];
//                    *outptr++ = u_hex_upper[ ws       & 0xf];
//                    
//                    ws = '\0';
//                }
//                
//                *outptr++ = ch;
//                
//                n = 0;
//            }
//                break;
                
            default:
            {
                if (ws)
                {
                    *outptr++ = ws;
                    
                    n += 1;
                    ws = '\0';
                }
                
                if (ch > 126 ||
                    ch <  33 ||
                    ch == '=')
                {
                    *outptr++ = '=';
                    *outptr++ = u_hex_upper[(ch >> 4) & 0xf];
                    *outptr++ = u_hex_upper[ ch       & 0xf];
                    
                    n += 3;
                    
                    isQuoted = YES;
                }
                else
                {
                    *outptr++ = ch;
                    
                    n += 1;
                }
            }
                break;
        }
        
        if (n > 70)
        {
            if (ws)
            {
                *outptr++ = ws;
                
                ws = '\0';
            }
            
            *outptr++ = '=';
            *outptr++ = '\r';
            *outptr++ = '\n';
            
            n = 0;
        }
    }
    
    *outptr = 0;
    if(isRealQuoted){
        *isRealQuoted = isQuoted;
    }
    return (int)(outptr - output);
}


@implementation VCardProperty
@synthesize key, value;

+ (id)propertyWithString:(NSString *)propertyString{
	VCardProperty *p = [[VCardProperty alloc] init];
	NSArray *parts = [propertyString componentsSeparatedByString:@"="];
	int count = (int)[parts count];
	if(count > 0){
		p.key = [parts objectAtIndex:0];
	}
	if(count > 1){
		p.value = [parts objectAtIndex:1];
	}
	return p;
}
//
//- (void)dealloc{
//	[key release];
//	[value release];
//	[super dealloc];
//}
//
@end

@implementation VCardLabel
@synthesize name, properties;

+ (id)labelWithString:(NSString *)labelString{
	VCardLabel *label = [[VCardLabel alloc] init];
	NSMutableArray *ps = [NSMutableArray arrayWithCapacity:4];
	NSArray *parts = [labelString componentsSeparatedByString:@";"];
	int count = (int)[parts count];
	if(count > 0){
		label.name = [parts objectAtIndex:0];
	}
	if(count > 1){
		int i = 1;
		for(i=1; i<count; i++){
			NSString *propertyString = [parts objectAtIndex:i];
			[ps addObject:[VCardProperty propertyWithString:propertyString]];
		}
		label.properties = ps;
	}
	return label;
}
//
//- (void)dealloc{
//	[name release];
//	[properties release];
//	[super dealloc];
//}
//
@end

@implementation VCardValue
@synthesize value, values;

+ (NSArray *)componentsSeperatedBySemicolon:(NSString *)input{
    
    input = [input stringByReplacingOccurrencesOfString:@"\\;" withString:@"\b"];
    NSArray *components = [input componentsSeparatedByString:@";"];
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:10];
    int i = 0;
    int count = (int)[components count];
    for(i=0;i<count;i++){
        [ret addObject:[[components objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\b" withString:@";"]];
    }
    
    return ret;
}

+ (id)valueWithString:(NSString *)valueString forceValueString:(BOOL)force{
    VCardValue *value = [[VCardValue alloc] init];
    if(force){
        value.value = valueString;
    }else{
        NSMutableArray *vs = [NSMutableArray arrayWithCapacity:10];
        //	NSArray *parts = [valueString componentsSeparatedByString:@";"];
        NSArray *parts = [VCardValue componentsSeperatedBySemicolon:valueString];
        int count = (int)[parts count];
        if(count > 0){
            if(count == 1){
                value.value = [parts objectAtIndex:0];
            }else{
                int i = 0;
                for(i=0; i<count; i++){
                    NSString *valueString = [parts objectAtIndex:i];
                    [vs addObject:valueString];
                }
                value.values = vs;			
            }
        }
    }
	return value;
}

+ (id)valueWithString:(NSString *)valueString{
	return [VCardValue valueWithString:valueString forceValueString:NO];
}
//
//- (void)dealloc{
//	[value release];
//	[values release];
//	[super dealloc];
//}
//
//
@end

@implementation VCardItem
@synthesize label, value;

+ (id)itemWithString:(NSString *)itemString forceValueString:(BOOL)force{
    VCardItem *item = [[VCardItem alloc] init];
	NSArray *parts = [itemString componentsSeparatedByString:@":"];
	int count = (int)[parts count];
	if(count > 2){
        NSString *labelString = [parts objectAtIndex:0];
        NSMutableString *valueString = [NSMutableString stringWithCapacity:10];
        int i = 1;
        for (i=1; i<count; i++) {
            if(i!=1){
                [valueString appendString:@":"];
            }
            [valueString appendString:[parts objectAtIndex:i]];
        }
		item.label = [VCardLabel labelWithString:labelString];
        item.value = [VCardValue valueWithString:valueString forceValueString:force];
    }else if(count > 1){
		NSString *labelString = [parts objectAtIndex:0];
		NSString *valueString = [parts objectAtIndex:1];
		item.label = [VCardLabel labelWithString:labelString];
		item.value = [VCardValue valueWithString:valueString forceValueString:force];
	}
    return item;
}

+ (id)itemWithString:(NSString *)itemString{
	return [VCardItem itemWithString:itemString forceValueString:NO];
}

- (BOOL)isQuotedPrintable{
    return [VCard isQuatedPrintable:self.label];
}
//
//- (void)dealloc{
//	[label release];
//	[value release];
//	[super dealloc];
//}
//
//
@end

@implementation VCard
+ (BOOL)isHexChar:(char)c
{
    if ((c >='0') && (c <='9')) {
        return YES;
    }else if((c >='A') && (c <='F')){
        return YES;
    }else if((c >='a') && (c <='f')){
        return YES;
    }
    return NO;
}
+ (id)utf8Decode:(NSString *)s{
	NSString *ret = s;
    ret = [ret stringByReplacingOccurrencesOfString:@"=\r\n" withString:@""];
    if (ret.length > 0) {
        NSString *string2 = [ret substringWithRange:NSMakeRange(ret.length -1,1)];
        if ([string2 isEqualToString:@"="]) {
            ret = [ret substringWithRange:NSMakeRange(0,ret.length -1)];
        }
    } 
    
    ret = [ret stringByReplacingOccurrencesOfString:@"=" withString:@"%"];
    
    ret = [ret stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return ret ? ret :@"unknown";
}

+ (id)quotatedDecode:(NSString *)s {
    NSString *replace = s;
    NSMutableString *ret = [NSMutableString stringWithCapacity:512];
    replace = [replace stringByReplacingOccurrencesOfString:@"=\r\n" withString:@""];
    const char* ptrstr = [replace cStringUsingEncoding:NSASCIIStringEncoding];
    NSInteger i, count = [replace length];
    if (ptrstr[0] != '=') {
        return s;
    }
    for (i = 0; i<count; i ++) {
        if (ptrstr[i] != '=') {
            return ret;
        }else 
        {
            if((i + 2) < count)
            {
                char c1 = '0', c2 = '0';
                if ((ptrstr[i+1]>='0') && (ptrstr[i+1]<='9')) {
                    c1 = ptrstr[i+1] - '0';
                }else if((ptrstr[i+1]>='A') && (ptrstr[i+1]<='F')){
                    c1 = ptrstr[i+1] - 'A' + 10;
                }else if((ptrstr[i+1]>='a') && (ptrstr[i+1]<='f')){
                    c1 = ptrstr[i+1] - 'a' + 10;
                }
                if ((ptrstr[i+2]>='0') && (ptrstr[i+2]<='9')) {
                    c2 = ptrstr[i+2] - '0';
                }else if((ptrstr[i+2]>='A') && (ptrstr[i+2]<='F')){
                    c2 = ptrstr[i+2] - 'A' + 10;
                }else if((ptrstr[i+2]>='a') && (ptrstr[i+2]<='f')){
                    c2 = ptrstr[i+2] - 'a' + 10;
                }
                if ((c1 != '0' ) && (c2 != '0')) {
                    [ret appendFormat:@"%c", (((c1 << 4) & 0xF0) | (c2 & 0x0F))];
                }else
                {
                    return ret;
                }
                
            }else
            {
                return ret;
            }
            i+=2;
        }
    }
    return ret;
}

+ (id)utf8EncodeForVcard:(NSString *)s
{
    NSString *ret = s;
//    int len = 0,ptrpos = 0;
	ret = [ret stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	ret = [ret stringByReplacingOccurrencesOfString:@"%" withString:@"="];
//    len = [ret length] + ((int)([ret length]/ 70) + 1);
//    unsigned char *retPtr = [ret UTF8String];
//    char *replaceString = (char *)malloc(len);
//    if(retPtr[])
//    {
//        
//    }
	return ret;
}

+ (id)quotatedPrintableString:(NSString *)s isRealQuoted:(BOOL *)isRealQuoted{
    
    const char * cString = [s cStringUsingEncoding:NSUTF8StringEncoding];
    char *buffer = (char *)malloc([s length]*10);
    memset(buffer, 0, [s length]*10);
    if(buffer){
        BOOL _isRealQuoted = NO;
        int len = u_quoted_printable_encode((const unsigned char*)cString, (int)strlen(cString), (unsigned char *)buffer, &_isRealQuoted);
//        buffer[len+1] = '\0';
        NSString *ret = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
//        QSELog(@"utf8 = %@", ret);
//        NSString *ret = [NSString stringWithCString:buffer];

        //Caution: memory leaks [buffer] [ret] are not released
        free(buffer);
        if(isRealQuoted){
            *isRealQuoted = _isRealQuoted;
        }
        return ret;
    }
    return nil;
}

+ (BOOL)isQuatedPrintable:(VCardLabel *)label{
	for(VCardProperty *property in label.properties){
		if([property.key isEqualToString:@"ENCODING"] && [property.value isEqualToString:@"QUOTED-PRINTABLE"]){
			return YES;
		}
	}
	return NO;
}

+ (CFStringRef)labelCategory:(VCardLabel *)label{
    
    for(VCardProperty *property in label.properties){
		if([property.key isEqualToString:LabelCategoryHome]){
			return kABHomeLabel;
		}else if([property.key isEqualToString:LabelCategoryWork]){
			return kABWorkLabel;
		} else if([property.key isEqualToString:LabelCategoryOther]){
            return kABOtherLabel;
		}else {
            if([property.key isEqualToString:@"INTERNET"]) {
                continue;
            } else if([property.key isEqualToString:@"ENCODING"]) {
                continue;
            } else if([property.key isEqualToString:@"CHARSET"]) {
                continue;
            } else if([property.key isEqualToString:CUSTOM]) {
                if ([property.value length] == 0) {
                    return nil;
                }
                return (__bridge CFStringRef)[property.value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            } else {
                if ([property.key length] == 0) {
                    if ([property.value length] == 0) {
                        return nil;
                    }
                    return (__bridge CFStringRef)property.value;
                } else {
                    if ([property.key hasPrefix:CUSTOM_ANDROID]) {
                        NSString *key = [property.key substringFromIndex:2];
                        return (__bridge CFStringRef)[key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    }
                }
                return (__bridge CFStringRef)property.key;
            }
        }
	}
	return nil;
}

+ (CFStringRef)labelPersonCategory:(VCardLabel *)label{
	for(VCardProperty *property in label.properties){
        if([property.key isEqualToString:LabelCategoryHome]){
			return kABHomeLabel;
		}else if([property.key isEqualToString:LabelCategoryWork]){
			return kABWorkLabel;
		}else if([property.key isEqualToString:FATHER]){
			return kABPersonFatherLabel;
		}else if([property.key isEqualToString:MOTHER]){
			return kABPersonMotherLabel;
		}else if([property.key isEqualToString:PARENT]){
			return kABPersonParentLabel;
		}else if([property.key isEqualToString:BROTHER]){
			return kABPersonBrotherLabel;
		}else if([property.key isEqualToString:SISTER]){
			return kABPersonSisterLabel;
		}else if([property.key isEqualToString:CHILD]){
			return kABPersonChildLabel;
		}else if([property.key isEqualToString:FRIEND]){
			return kABPersonFriendLabel;
		}else if([property.key isEqualToString:SPOUSE]){
			return kABPersonSpouseLabel;
		}else if([property.key isEqualToString:PARTNER]){
			return kABPersonPartnerLabel;
		}else if([property.key isEqualToString:ASSISTANT]){
			return kABPersonAssistantLabel;
		}else if([property.key isEqualToString:MANAGER]){
			return kABPersonManagerLabel;
		}else if([property.key isEqualToString:OTHER]){
			return kABOtherLabel;
		} else if([property.key isEqualToString:@"INTERNET"]) {
            continue;
        } else if([property.key isEqualToString:@"ENCODING"]) {
            continue;
        } else if([property.key isEqualToString:@"CHARSET"]) {
            continue;
        } else  if ([property.key isEqualToString:CUSTOM]) {
            if ([property.value length] == 0) {
                return nil;
            }
            return (__bridge CFStringRef)[property.value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        } else {
            
            return  [self labelCategory:label];
            
//            if ([property.key length] == 0) {
//                if ([property.value length] == 0) {
//                    return nil;
//                }
//                return (__bridge CFStringRef)property.value;
//            } else {
//                if ([property.key hasPrefix:CUSTOM_ANDROID]) {
//                    NSString *key = [property.key substringFromIndex:2];
//                    return (__bridge CFStringRef)[key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                }
//            }
//            return (__bridge CFStringRef)property.key;
        }
	}
	return nil;
}


+ (CFStringRef)dateLabelCategory:(VCardLabel *)label{
	int i, count = (int)[label.properties count];
    
	for(i=0; i<count; i++){
		VCardProperty *property = [label.properties objectAtIndex:i];
        if([property.key isEqualToString:LabelCategoryAnniversary]){
			return kABPersonAnniversaryLabel;
		}else if([property.key isEqualToString:LabelCategoryOther]){
            return kABOtherLabel;
		} else  if([property.key isEqualToString:@"INTERNET"]) {
            continue;
        } else if([property.key isEqualToString:@"ENCODING"]) {
            continue;
        } else if([property.key isEqualToString:@"CHARSET"]) {
            continue;
        } else if ([property.key isEqualToString:CUSTOM]) {
            if ([property.value length] == 0) {
                return nil;
            }
            return (__bridge CFStringRef)[property.value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }  else {
            if ([property.key length] == 0) {
                if ([property.value length] == 0) {
                    return nil;
                }
                return (__bridge CFStringRef)property.value;
            } else {
                if ([property.key hasPrefix:CUSTOM_ANDROID]) {
                    NSString *key = [property.key substringFromIndex:2];
                    return (__bridge CFStringRef)[key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }
            }
            return (__bridge CFStringRef)property.key;
        }
	}
	return nil;
}

+ (CFStringRef)telLabelCategory:(VCardLabel *)label{
	int i, count = (int)[label.properties count];
	for(i=0; i<count; i++){
		VCardProperty *property = [label.properties objectAtIndex:i];
        if([property.key isEqualToString:LabelCategoryIPhone]){
			return kABPersonPhoneIPhoneLabel;
		}else if([property.key isEqualToString:LabelCategoryMain]){
            return kABPersonPhoneMainLabel;
		}else if([property.key isEqualToString:LabelCategoryCell]){
            return kABPersonPhoneMobileLabel;
             
		}else if([property.key isEqualToString:LabelCategoryFax]){
			int j = i+1;
			//fax
			if(j<count){
				VCardProperty *p = [label.properties objectAtIndex:j];
				if([p.key isEqualToString:LabelCategoryHome]){
					return kABPersonPhoneHomeFAXLabel;
				}else if([p.key isEqualToString:LabelCategoryWork]){
					return kABPersonPhoneWorkFAXLabel;
				}
			}
			return kABPersonPhoneWorkFAXLabel;
		}else if([property.key isEqualToString:LabelCategoryPager]){
			int j = i+1;
			//pager
			if(j<count){
				VCardProperty *p = [label.properties objectAtIndex:j];
				if([p.key isEqualToString:LabelCategoryHome]){
					return kABPersonPhonePagerLabel;
				}else if([p.key isEqualToString:LabelCategoryWork]){
					return kABPersonPhonePagerLabel;
				}
			}
			return kABPersonPhonePagerLabel;
		}else if([property.key isEqualToString:LabelCategoryHome]){//add new
			int j = i+1;
			//fax
			if(j<count){
				VCardProperty *p = [label.properties objectAtIndex:j];
				if([p.key isEqualToString:LabelCategoryFax]){
					return kABPersonPhoneHomeFAXLabel;
				}
			}
			return kABHomeLabel;
		} else if([property.key isEqualToString:LabelCategoryWork]){//add new
			int j = i+1;
			//fax
			if(j<count){
				VCardProperty *p = [label.properties objectAtIndex:j];
				if([p.key isEqualToString:LabelCategoryFax]){
					return kABPersonPhoneWorkFAXLabel;
				}
			}
			return kABWorkLabel;
		} else if([property.key isEqualToString:LabelCategoryOtherFAX]){//add new
                return kABPersonPhoneOtherFAXLabel;
		} else {
            int j = i;
			//mobile
			if(j<count){
				VCardProperty *p = [label.properties objectAtIndex:j];
				if([p.key isEqualToString:LabelCategoryHome]){
					return kABHomeLabel;
				}else if([p.key isEqualToString:LabelCategoryWork]){
					return kABWorkLabel;
				} else if([property.key isEqualToString:LabelCategoryOther]){
                    return kABOtherLabel;
                } else if([property.key isEqualToString:@"ENCODING"]) {
                    return nil;
                } else if([property.key isEqualToString:@"ENCODING"]) {
                    continue;
                } else if([property.key isEqualToString:@"CHARSET"]) {
                    continue;
                } else if ([property.key isEqualToString:CUSTOM]) {
                    if ([property.value length] == 0) {
                        return nil;
                    }
                    return (__bridge CFStringRef)[property.value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }  else {
                    if ([property.key length] == 0) {
                        if ([property.value length] == 0) {
                            return nil;
                        }
                        return (__bridge CFStringRef)property.value;
                    } else {
                        if ([property.key hasPrefix:CUSTOM_ANDROID]) {
                            NSString *key = [property.key substringFromIndex:2];
                            return (__bridge CFStringRef)[key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        }
                    }
                    return (__bridge CFStringRef)property.key;
                }
            }
        }
	}
	return nil;
}

+ (NSDate *)dateFromVCardDateString:(NSString *)vcardDateString{
    NSDateFormatter  *vcardDateFormatter = [[NSDateFormatter alloc] init];
    [vcardDateFormatter setDateFormat:@"yyyy-MM-dd"];//yyyyMMddHHmmss
    if ([vcardDateString hasPrefix:@"--"]) {
        //vcardDateString = [vcardDateString stringByReplacingOccurrencesOfString:@"--" withString:@"1604-"]; 
        vcardDateString = [@"1604-" stringByAppendingString:[vcardDateString substringFromIndex:2]];
        
    } else {
        NSRange rang = [vcardDateString rangeOfString:@"-"];
        if (rang.length == 0 || rang.location == NSNotFound) {
            [vcardDateFormatter setDateFormat:@"yyyyMMdd"];//yyyyMMddHHmmss
        }
    }
    vcardDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *date = [vcardDateFormatter dateFromString:vcardDateString]; 
    return date;
}

+ (NSDictionary *)dictionaryFromVCardDateString:(VCardValue *)value {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *str in value.values) {
        
        NSString *strValue = str;
        NSRange range = [strValue rangeOfString:@"ENCODING"];
        if(range.location != kCFNotFound && range.length > 0){
            
            NSArray *parts = [str componentsSeparatedByString:@":"];
            if ([parts count] > 2 ) {
                strValue = [VCard utf8Decode:[parts objectAtIndex:[parts count]-1]];
                [dic setObject:strValue forKey:[parts objectAtIndex:0]];
            }
        } else {
            
            NSArray *parts = [str componentsSeparatedByString:@":"];
            if ([parts count] == 2) {
                [dic setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
            }
        }
        
        
    }
    return dic;
}

@end

#undef LabelCategoryHome
#undef LabelCategoryWork
#undef LabelCategoryOther
#undef LabelCategoryIPhone
#undef LabelCategoryCell
#undef LabelCategoryFax
#undef LabelCategoryPager
#undef LabelCategoryMain
#undef LabelCategoryAnniversary

