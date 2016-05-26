//
//  ABPerson+vCard.m
//  QHContacts
//
//  Created by yanzhanlong on 16/2/18.
//  Copyright © 2016年 Qihoo. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "QHABPerson+vCard.h"
#import "QHVCard.h"
#import "QHABRecord+vCard.h"
#import "QHABConfigure.h"
#import "QHABPerson.h"

@implementation ABPerson (vCard)

+ (id)vcardStringToPerson:(NSString *)vCard {
    
    ABPerson *person = [ABPerson creatABPerson];
    [person updataPersonByVcardString:vCard];
    return person;
}


+ (NSArray *)resolveVCard:(NSString *)vCardString{
    NSString *s = vCardString;
    BOOL start = NO;
    uint8_t  last = 0, current = 0,secondCurrent = 0;
    int startIndex = 0;
    int i = 0;
    NSInteger length = [s length];
    NSRange range;
    NSMutableArray *lines = [NSMutableArray array];
    for (i=0; i<length; i++) {
        current = [s characterAtIndex:i];
        if (i+1 < length) {
            secondCurrent = [s characterAtIndex:i+1];
        } else {
            secondCurrent = 0;
        }
        if(!start){
            if(current == ' ' || current == '\r' || current == '\n'){
                //trim white space characters
                //NSLog(@"trim white space characters");
            }else{
                start = YES;
                startIndex = i;
            }
        }
        if(start){
            //read all lines
            if(current == '\r' && secondCurrent == '\n'){
                if(last == '='){
                } else{
                    range.location = startIndex;
                    range.length = i-startIndex+1;
                    [lines addObject:[s substringWithRange:range]];
                    startIndex = i+2;					
                }
            }
        }
        last = current;
    }
    if ([lines count] == 0) {
        NSArray *array = [vCardString componentsSeparatedByString:@"\n"];
        if ([array count] > 0) {
            [lines addObjectsFromArray:array];
        }
    }
    return lines;
}

+ (NSDictionary*)vCardStringToDictionary:(NSString *)vCardString {
    NSMutableDictionary *Vcardictionary = [NSMutableDictionary dictionary];
    NSMutableArray *dateArray = [NSMutableArray array]; 
    NSMutableArray *eventArray = [NSMutableArray array];
    NSMutableArray *telArray = [NSMutableArray array];
    NSMutableArray *urlArray = [NSMutableArray array];
    NSMutableArray *addrArray = [NSMutableArray array];
    NSMutableArray *eMailArray = [NSMutableArray array];
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *propertyArray = [NSMutableArray array];
    NSMutableArray *namePropertyArray = [NSMutableArray array];
    NSMutableArray *profilepropertyArray = [NSMutableArray array];
    NSMutableArray *groupArray = [NSMutableArray array];
    NSMutableArray *photoArray = [NSMutableArray array];
    
    NSArray *lines = [self resolveVCard:vCardString];
    for (NSString * line in lines) {
        
        NSString *vcardLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([vcardLine hasPrefix:BEGIN] || [vcardLine hasPrefix:BEGIN1]) {
            [Vcardictionary setValue:vcardLine forKey:BEGIN];
        } else if([vcardLine hasPrefix:VERSION] || [vcardLine hasPrefix:VERSION1]){
            [Vcardictionary setValue:vcardLine forKey:VERSION];
        } else if([vcardLine hasPrefix:END] || [vcardLine hasPrefix:END1]){
            [Vcardictionary setValue:vcardLine forKey:END];
        } else if ([vcardLine hasPrefix:REV] || [vcardLine hasPrefix:REV1]) {
            [Vcardictionary setValue:vcardLine forKey:REV];
        } else if([vcardLine hasPrefix:NOTE] || [vcardLine hasPrefix:NOTE1]){
            [Vcardictionary setValue:vcardLine forKey:NOTE];
        } else if([vcardLine hasPrefix:N] || [vcardLine hasPrefix:N1]){
            [Vcardictionary setValue:vcardLine forKey:N];
        } else if([vcardLine hasPrefix:FN] || [vcardLine hasPrefix:FN1]){
            [Vcardictionary setValue:vcardLine forKey:FN];
        } else if([vcardLine hasPrefix:ORG] || [vcardLine hasPrefix:ORG1]){
            [Vcardictionary setValue:vcardLine forKey:ORG];
        } else if ([vcardLine hasPrefix:ROLE] || [vcardLine hasPrefix:ROLE1]) {
            [Vcardictionary setValue:vcardLine forKey:ROLE];
        } else if([vcardLine hasPrefix:AGENT] || [vcardLine hasPrefix:AGENT1]){
            [Vcardictionary setValue:vcardLine forKey:AGENT];
        } else if([vcardLine hasPrefix:NICKNAME] || [vcardLine hasPrefix:NICKNAME1]){
            [Vcardictionary setValue:vcardLine forKey:NICKNAME];
        } else if([vcardLine hasPrefix:ANNIVERSARY] || [vcardLine hasPrefix:DATE]
                 || [vcardLine hasPrefix:ANNIVERSARY1] || [vcardLine hasPrefix:DATE1]){
            [dateArray addObject:vcardLine];
        } else if([vcardLine hasPrefix:XEVENT] || [vcardLine hasPrefix:XEVENT1]){
            [eventArray addObject:vcardLine];
        } else if([vcardLine hasPrefix:BDAY] || [vcardLine hasPrefix:BDAY1]){
            [Vcardictionary setValue:vcardLine forKey:BDAY];
        } else if([vcardLine hasPrefix:TITLE] || [vcardLine hasPrefix:TITLE1]){
            //[titleArray addObject:vcardLine];
             [Vcardictionary setValue:vcardLine forKey:TITLE];
        } else if([vcardLine hasPrefix:ADR] || [vcardLine hasPrefix:ADR1]){
            [addrArray addObject:vcardLine];
        } else if([vcardLine hasPrefix:TEL]||[vcardLine hasPrefix:TEL1]){
            [telArray addObject:vcardLine];
        } else if([vcardLine hasPrefix:EMAIL]||[vcardLine hasPrefix:EMAIL1]){
            [eMailArray addObject:vcardLine];
        } else if([vcardLine hasPrefix:URL] || [vcardLine hasPrefix:URL1]){
            [urlArray addObject:vcardLine];
        } else if([vcardLine hasPrefix:BRITHDAY]){
            [Vcardictionary setValue:vcardLine forKey:BRITHDAY];
        } else if([vcardLine hasPrefix:FIRSTNAMEPHONETHIC]){
            [Vcardictionary setValue:vcardLine forKey:FIRSTNAMEPHONETHIC];
        } else if([vcardLine hasPrefix:LASTNAMEPHONETHIC]){
            [Vcardictionary setValue:vcardLine forKey:LASTNAMEPHONETHIC];
        } else if([vcardLine hasPrefix:MIDDLENAMEPHONETHIC]){
            [Vcardictionary setValue:vcardLine forKey:MIDDLENAMEPHONETHIC];
        } else if([vcardLine hasPrefix:IM]|| [vcardLine hasPrefix:IM1]
                  ||[vcardLine hasPrefix:SNS]|| [vcardLine hasPrefix:SNS1]){
            [propertyArray addObject:vcardLine];
        } else if([vcardLine hasPrefix:XRELATION] || [vcardLine hasPrefix:XRELATION1]){
            [namePropertyArray addObject:vcardLine];
        } else if([vcardLine hasPrefix:PROFILEPROPERTY]){
            [profilepropertyArray addObject:vcardLine];
        } else if([vcardLine hasPrefix:LASTSAVEDATE]){
            [Vcardictionary setValue:vcardLine forKey:LASTSAVEDATE];
        } else if([vcardLine hasPrefix:XGROUPCODE] || [vcardLine hasPrefix:XGROUPCODE]){
            [groupArray addObject:vcardLine];
        } else if([vcardLine hasPrefix:GROUP] || [vcardLine hasPrefix:GROUP1]){
            [groupArray addObject:vcardLine];
        } else if([vcardLine hasPrefix:PHOTO] || [vcardLine hasPrefix:PHOTO1]){
            [photoArray addObject:vcardLine];
        } else {
            //NSLog(@"%@",vcardLine);
        }
    }
    if ([telArray count] > 0) {
        [Vcardictionary setValue:telArray forKey:TEL];
    }
    if ([addrArray count] > 0) {
        [Vcardictionary setValue:addrArray forKey:ADR];
    }
    if ([urlArray count] > 0) {
        [Vcardictionary setValue:urlArray forKey:URL];
    }
    if ([eMailArray count] > 0) {
        [Vcardictionary setValue:eMailArray forKey:EMAIL];
    }
    if ([titleArray  count] > 0) {
        [Vcardictionary setValue:titleArray forKey:TITLE];
    }
    if ([dateArray count] > 0) {
        [Vcardictionary setValue:dateArray forKey:DATE];
    }
    if ([eventArray count] > 0) {
        [Vcardictionary setValue:eventArray forKey:XEVENT];
    }
    if ([propertyArray count] > 0) {
        [Vcardictionary setValue:propertyArray forKey:IM];
    }
    if ([namePropertyArray count] > 0) {
        [Vcardictionary setValue:namePropertyArray forKey:XRELATION];
    }
    if ([profilepropertyArray count] > 0) {
        [Vcardictionary setValue:profilepropertyArray forKey:PROFILEPROPERTY];
    }
    
    if ([groupArray count] > 0) {
        [Vcardictionary setValue:groupArray forKey:GROUPCODE];
    }
    if ([photoArray count] > 0) {
        [Vcardictionary setValue:photoArray forKey:PHOTO];
    }
    return Vcardictionary;
}

- (NSString*)vcardString {
   return [self vcardStringByGroupInfo:self.groups];
}

- (NSString*)vcardStringByGroupInfo:(NSArray *)groups {
    
     NSMutableString *formattedVcard = [NSMutableString string];
     [formattedVcard setString:@"BEGIN:VCARD\r\nVERSION:2.1\r\n"];
     
     NSString *FirstName = [self getFirstName];
     NSString * MiddleName =  [self getMiddleName];
     NSString * LastName = [self getLastName];
     NSString * OrgName =  CFBridgingRelease(ABRecordCopyValue([self getRecordRef], kABPersonOrganizationProperty)) ;
     NSString * Department =  CFBridgingRelease(ABRecordCopyValue([self getRecordRef], kABPersonDepartmentProperty));
     NSString * Prefix =  CFBridgingRelease(ABRecordCopyValue([self getRecordRef], kABPersonPrefixProperty));
     NSString * Suffix =  CFBridgingRelease(ABRecordCopyValue([self getRecordRef], kABPersonSuffixProperty));
     
     NSMutableString *Name =  [NSMutableString string];
     if(LastName != nil) {
         [Name appendFormat:@"%@;", [self replaceString:LastName]];
     } else {
         [Name appendString:@";"];
     }
     if(FirstName != nil) {
         [Name appendFormat:@"%@;", [self replaceString:FirstName]];
     } else {
         [Name appendString:@";"];
     }
     if(MiddleName != nil) {
         [Name appendFormat:@"%@;",[self replaceString:MiddleName]];
     }else {
         [Name appendString:@";"];
     }
     if(Prefix != nil) {
         [Name appendFormat:@"%@;",[self replaceString:Prefix]];
     } else {
         [Name appendString:@";"];
     }
     if(Suffix != nil) {
         [Name appendFormat:@"%@",[self replaceString:Suffix]];
     } else {
         
     }
    
    BOOL isRealQuoted = NO;
    NSString *ret =  [VCard quotatedPrintableString:Name isRealQuoted:&isRealQuoted];
    
    if(isRealQuoted) {
        [formattedVcard appendString:@"N;CHARSET=UTF-8;ENCODING=QUOTED-PRINTABLE:"];
    }else {
        [formattedVcard appendString:@"N;ENCODING=QUOTED-PRINTABLE:"];
    }
    [formattedVcard appendString:ret];
    [formattedVcard appendString:@"\r\n"];
    
    // FN
    {
        NSString * strFn = (__bridge_transfer NSString *)ABRecordCopyCompositeName([self getRecordRef]);
        if (strFn) {
            [formattedVcard appendString:@"FN"];
            [formattedVcard appendString:[self vcardStringValue:strFn]];
        }
    }
 
     //ORG
    if((OrgName != nil && [OrgName length] > 0)) {
        [formattedVcard appendString:@"ORG:"];
        [formattedVcard appendString:[self replaceString:OrgName]];
        [formattedVcard appendString:@"\r\n"];
    }
    
    if((Department != nil && [Department length] > 0)) {
        [formattedVcard appendString:@"ROLE:"];
        [formattedVcard appendString:[self replaceString:Department]];
        [formattedVcard appendString:@"\r\n"];
    }
    
     //昵称
     [formattedVcard appendString:[self vcardString:@"NICKNAME" property:kABPersonNicknameProperty customizeValues:nil]];
     //job title
     [formattedVcard appendString:[self vcardString:@"TITLE" property:kABPersonJobTitleProperty customizeValues:nil]];
     //NOTE
     [formattedVcard appendString:[self vcardString:@"NOTE" property:kABPersonNoteProperty customizeValues:nil]];
     
     //BRITHDAY
    [formattedVcard appendString:[self vcardString:@"BADY" property:kABPersonBirthdayProperty customizeValues:nil]];
 
//     [formattedVcard appendString:[self vcardString:@"BRITHDAY" property:kABPersonBirthdayProperty customizeValues:nil]];
     //FIRSTNAMEPHONETHIC
     [formattedVcard appendString:[self vcardString:FIRSTNAMEPHONETHIC property:kABPersonFirstNamePhoneticProperty customizeValues:nil]];
     //LASTNAMEPHONETHIC
     [formattedVcard appendString:[self vcardString:LASTNAMEPHONETHIC property:kABPersonLastNamePhoneticProperty customizeValues:nil]];
     //MIDDLENAMEPHONETHIC
     [formattedVcard appendString:[self vcardString:MIDDLENAMEPHONETHIC property:kABPersonMiddleNamePhoneticProperty customizeValues:nil]];
     
     //LASTSAVEDATE
     [formattedVcard appendString:[self vcardString:LASTSAVEDATE property:kABPersonModificationDateProperty customizeValues:nil]];
 
     //DATE
      [formattedVcard appendString:[self vcardString:@"X-EVENT" property:kABPersonDateProperty customizeValues:nil]];
 
     //URLs
     [formattedVcard appendString:[self vcardString:@"URL" property:kABPersonURLProperty customizeValues:nil]];
     
     //NAMESPROPERTY 关联人
     [formattedVcard appendString:[self vcardString:@"X-RELATION" property:kABPersonRelatedNamesProperty customizeValues:nil]];
     //
     
     //EMAIL
     [formattedVcard appendString:[self vcardString:@"EMAIL;INTERNET" property:kABPersonEmailProperty customizeValues:nil]];
     //Phone Number
     [formattedVcard appendString:[self vcardString:@"TEL" property:kABPersonPhoneProperty customizeValues:nil]];
 
     //address
     [formattedVcard appendString:[self vcardString:@"ADR" property:kABPersonAddressProperty customizeValues:^NSString *(id labels, id valus) {
         NSMutableString *formattedVcard = [NSMutableString string];
         
         if ([valus isKindOfClass:[NSDictionary class]]) {
             NSDictionary *addressInfo = valus;
             
             NSMutableString *OthereAddr = [NSMutableString string];
             [OthereAddr appendString:@";"];
             
             NSString *countryCode = [(NSDictionary *)addressInfo objectForKey:@"CountryCode"];
             if(countryCode) {
                 [OthereAddr appendString: [self replaceString:countryCode]];
             }
             
             [OthereAddr appendString:@";"];
             
             NSString *street = [(NSDictionary *)addressInfo objectForKey:@"Street"];
             if(street) {
                 [OthereAddr appendString:[self replaceString:[street stringByReplacingOccurrencesOfString: @"\r\n" withString: @" "]]];
             }
             
             [OthereAddr appendString:@";"];
             
             NSString *city = [(NSDictionary *)addressInfo objectForKey:@"City"];
             if(city) {
                 [OthereAddr appendString: [self replaceString:city]];
             }
             
             [OthereAddr appendString:@";"];
             
             NSString *state = [(NSDictionary *)addressInfo objectForKey:@"State"];
             if(state) {
                 [OthereAddr appendString:[self replaceString:state]];
             }
             
             [OthereAddr appendString:@";"];
             
             NSString *ZIP = [(NSDictionary *)addressInfo objectForKey:@"ZIP"];
             if(ZIP) {
                 [OthereAddr appendString: [self replaceString:ZIP]];
             }
             [OthereAddr appendString:@";"];
             NSString *Country = [(NSDictionary *)addressInfo objectForKey:@"Country"] ;
             if(Country ) {
                 //NSLog(@"%@",Country);
                 [OthereAddr appendString: [self replaceString:Country]];
                 //NSLog(@"%@",OthereAddr);
             }
             [OthereAddr appendString:@";"];
             
             BOOL isRealQuoted = NO;
             NSString*ret = [VCard quotatedPrintableString:OthereAddr isRealQuoted:&isRealQuoted];
             if(isRealQuoted) {
                 if (labels) {
                     NSString *value = [NSString stringWithFormat:@";%@;ENCODING=QUOTED-PRINTABLE;CHARSET=UTF-8:",
                                        [self formateABRecordLabel:(__bridge CFStringRef)(labels)]];
                     [formattedVcard appendString:value];
                 } else {
                     [formattedVcard appendFormat:@";%@;ENCODING=QUOTED-PRINTABLE;CHARSET=UTF-8:",
                      [self formateABRecordLabel:(__bridge CFStringRef)(labels)]];
                 }
                 
             }else {
                 if (labels) {
                     NSString *value = [NSString stringWithFormat:@";%@:",[self formateABRecordLabel:(__bridge CFStringRef)(labels)]];
                     
                     [formattedVcard appendString:value];
                 }else {
                     [formattedVcard appendString:@":"];
                 }
             }
             [formattedVcard appendString:ret];
             [formattedVcard appendString:@"\r\n"];
         }
         return formattedVcard;
     }]];
 
     //IM
     [formattedVcard appendString:[self vcardString:@"X-SNS" property:kABPersonInstantMessageProperty customizeValues:^NSString *(id labels, id valus) {
         NSMutableString *formattedVcard = [NSMutableString string];
         
         if ([valus isKindOfClass:[NSDictionary class]]) {
             NSDictionary *instantMessageContent = valus;
             NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
             
             NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
             if (service) {
                 BOOL isRealQuoted = NO;
                 NSString* ret =  [VCard quotatedPrintableString:[self replaceString:(NSString*)service] isRealQuoted:&isRealQuoted];
                 if (isRealQuoted) {
                     [formattedVcard appendFormat:@";ENCODING=QUOTED-PRINTABLE:CHARSET=UTF-8:%@:", ret];
                 } else {
                     [formattedVcard appendFormat:@";%@:", ret];
                 }
             } else {
                 if (labels) {
                     [formattedVcard appendFormat:@";%@:", [self formateABRecordLabel:(__bridge CFStringRef)(labels)]];
                 } else {
                     [formattedVcard appendString:@";:"];
                 }
             }
             
             if (username) {
                 BOOL isRealQuoted = NO;
                 NSString* ret =  [VCard quotatedPrintableString:[self replaceString:(NSString*)username] isRealQuoted:&isRealQuoted];
                 if (isRealQuoted) {
                     [formattedVcard appendFormat:@"ENCODING=QUOTED-PRINTABLE:CHARSET=UTF-8:%@", ret];
                     
                 }else {
                     [formattedVcard appendFormat:@"%@", ret];
                 }
             }
             [formattedVcard appendFormat:@"\r\n"];
         }
         return formattedVcard;
     }]];
    
    [formattedVcard appendString:[self vcardString:@"X-SNS" property:kABPersonSocialProfileProperty customizeValues:^NSString *(id labels, id valus) {
        NSMutableString *formattedVcard = [NSMutableString string];
        
        if ([valus isKindOfClass:[NSDictionary class]]) {
            NSDictionary *socialContent = valus;
   
            NSString* service = [socialContent valueForKey:(NSString *)kABPersonSocialProfileServiceKey];
            NSString* username = [socialContent valueForKey:(NSString *)kABPersonSocialProfileUsernameKey];

            if (service) {
                NSString*ret = [VCard utf8EncodeForVcard:service];
                if (ret) {
                    [formattedVcard appendFormat:@";%@:", ret];
                } else {
                    [formattedVcard appendFormat:@";%@:", service];
                }
            } else {
                if (labels) {
                    [formattedVcard appendFormat:@";%@:", [self formateABRecordLabel:(__bridge CFStringRef)(labels)]];
                } else {
                    [formattedVcard appendString:@";:"];
                }
            }
         
            if (username) {
                BOOL isRealQuoted = NO;
                NSString* ret =  [VCard quotatedPrintableString:[self replaceString:(NSString*)username] isRealQuoted:&isRealQuoted];
                if (isRealQuoted) {
                    [formattedVcard appendFormat:@"ENCODING=QUOTED-PRINTABLE;CHARSET=UTF-8:%@", ret];
                } else {
                    [formattedVcard appendFormat:@"%@", ret];
                }
            }
            [formattedVcard appendString:@"\r\n"];
        }
        return formattedVcard;
    }]];
    
     //PROFILEPROPERTY
     [formattedVcard appendString:[self vcardString:@"PROFILEPROPERTY" property:kABPersonSocialProfileProperty customizeValues:^NSString *(id labels, id valus) {
         NSMutableString *formattedVcard = [NSMutableString string];
         
         if ([valus isKindOfClass:[NSDictionary class]]) {
             NSDictionary *socialContent = valus;
             
             
             NSString* service = [socialContent valueForKey:(NSString *)kABPersonSocialProfileServiceKey];
             NSString* url = [socialContent valueForKey:(NSString *)kABPersonSocialProfileURLKey];
             NSString* username = [socialContent valueForKey:(NSString *)kABPersonSocialProfileUsernameKey];
             NSString* UserIdentifie = [socialContent valueForKey:(NSString *)kABPersonSocialProfileUserIdentifierKey];
             
             if (labels) {
                 [formattedVcard appendFormat:@";%@:", [self formateABRecordLabel:(__bridge CFStringRef)(labels)]];
             } else {
                 [formattedVcard appendString:@":"];
             }
             
             if (service) {
                 NSString*ret = [VCard utf8EncodeForVcard:service];
                 if (ret) {
                     [formattedVcard appendFormat:@"PROFILESERVICEKEY:%@;", ret];
                 } else {
                     [formattedVcard appendString:@"PROFILESERVICEKEY:;"];
                 }
             }
             if (url) {
                 url = [url stringByReplacingOccurrencesOfString:@":" withString:@"："];
                 NSString*ret = [VCard utf8EncodeForVcard:url];
                 [formattedVcard appendFormat:@"PROFILEURLKEY:%@;", ret];
             }
             if (username) {
                 BOOL isRealQuoted = NO;
                 NSString* ret =  [VCard quotatedPrintableString:[self replaceString:(NSString*)username] isRealQuoted:&isRealQuoted];
                 if (isRealQuoted) {
                     [formattedVcard appendFormat:@"PROFILEUSERNAMEKEY;ENCODING=QUOTED-PRINTABLE;CHARSET=UTF-8:%@;", ret];
                 } else {
                     [formattedVcard appendFormat:@"PROFILEUSERNAMEKEY:%@;", ret];
                 }
             }
             if (UserIdentifie && ![UserIdentifie isEqualToString:@"(Not Known)"]) {
                 
                 NSString*ret = [VCard utf8EncodeForVcard:UserIdentifie];
                 if (ret) {
                     [formattedVcard appendFormat:@"PROFILEUSERIDENTIFIERKEY:%@;", ret];
                 } else {
                     [formattedVcard appendString:@"PROFILEUSERIDENTIFIERKEY:;"];
                 }
             }
             [formattedVcard appendString:@"\r\n"];
         }
         return formattedVcard;
     }]];

    //photo
    if(self.photoID) {
        NSMutableString *formattedPhoto = [NSMutableString string];
        [formattedPhoto appendString:@"PHOTO;ENCODING=QUOTED-PRINTABLE:"];
        NSString*ret = [VCard utf8EncodeForVcard:self.photoID];
        if (ret) {
            [formattedPhoto appendFormat:@"%@", ret];
        } else {
            [formattedPhoto appendFormat:@"%@",self.photoID];
        }
        [formattedPhoto appendString:@"\r\n"];
        [formattedVcard appendString:formattedPhoto];
    }
    
    if ([groups count] > 0) {
        for (NSString *name in groups) {
            [formattedVcard appendString:@"X-GROUP"];
            [formattedVcard appendString:[self vcardStringValue:name]]; 
        }
    }

    [formattedVcard appendString:@"END:VCARD\r\n"];
    return formattedVcard;
}
 
- (BOOL)updataPersonByVcardString:(NSString *)vCardString {
    NSDictionary *VcardDictionary = [ABPerson vCardStringToDictionary:vCardString];
    
    if (VcardDictionary) {
        //BOOL isName = NO;
        if ([VcardDictionary objectForKey:N] != nil) {
            VCardItem * item = [VCardItem itemWithString:[VcardDictionary objectForKey:N]];
            BOOL quatedPrintable = [VCard isQuatedPrintable:item.label];
            NSString *strLastName = nil;
            NSString *strFirstName = nil;
            NSString *strMiddleName = nil;
            NSString *strPrefix = nil;
            NSString *strSuffix = nil;
            if ([item.value.values count] > 0) {
                strLastName = [item.value.values objectAtIndex:0];
            }
            if ([item.value.values count] > 1) {
                strFirstName = [item.value.values objectAtIndex:1];
            }
            if ([item.value.values count] > 2) {
                strMiddleName = [item.value.values objectAtIndex:2];
            }
            if ([item.value.values count] > 3) {
                strPrefix = [item.value.values objectAtIndex:3];
            }
            if ([item.value.values count] > 4) {
                strSuffix = [item.value.values objectAtIndex:4];
            }
            if(quatedPrintable)
            {
                if ([strLastName length] > 0) {
                    strLastName = [VCard utf8Decode:strLastName];
                }
                if ([strFirstName length] > 0) {
                    strFirstName = [VCard utf8Decode:strFirstName];
                }
                if ([strMiddleName length] > 0) {
                    strMiddleName = [VCard utf8Decode:strMiddleName];
                }
                if ([strPrefix length] > 0) {
                    strPrefix = [VCard utf8Decode:strPrefix];
                }
                if ([strSuffix length] > 0) {
                    strSuffix = [VCard utf8Decode:strSuffix];
                }
            }

            
            [self setLastName:strLastName];
            [self setFirstName:strFirstName];
            [self setMiddleName:strMiddleName];
            
            [self setValue:strPrefix forProperty:kABPersonPrefixProperty error:nil];
            [self setValue:strSuffix forProperty:kABPersonSuffixProperty error:nil];
        }
        if([VcardDictionary objectForKey:NOTE] != nil)
        {
            [self vcardStringToRecord:[VcardDictionary objectForKey:NOTE] property:kABPersonNoteProperty label:nil];
        }
        if([VcardDictionary objectForKey:XEVENT] != nil)//// DATE
        {
           [self vcardStringToMultiRecord:[VcardDictionary objectForKey:XEVENT] property:kABPersonDateProperty];
        }
//        if([VcardDictionary objectForKey:ANNIVERSARY] != nil)// ANNIVERSARY
//        {
//            [self vcardStringToRecord:[VcardDictionary objectForKey:ANNIVERSARY] property:kABPersonAlternateBirthdayProperty label:(id)kABPersonAnniversaryLabel];
//        } 
        
        if ([VcardDictionary objectForKey:BDAY] != nil) {
            ///BDAY
            [self vcardStringToDateRecord:[VcardDictionary objectForKey:BDAY] property:kABPersonBirthdayProperty];
            
//            [self vcardStringToRecord:[VcardDictionary objectForKey:BDAY] property:kABPersonDateProperty label:(id)kABPersonAnniversaryLabel];
        }
        if ([VcardDictionary objectForKey:FN] != nil) {
            //////
//            if (!isName) {
//                [self vcardStringToRecord:[VcardDictionary objectForKey:FN] property:kABPersonFirstNameProperty label:nil];
//            }
        }
        if ([VcardDictionary objectForKey:ORG] != nil) {
            [self vcardStringToRecord:[VcardDictionary objectForKey:ORG] property:kABPersonOrganizationProperty label:nil];
//            
//            VCardItem * item = [VCardItem itemWithString:[VcardDictionary objectForKey:ORG]];
//            BOOL quatedPrintable = [VCard isQuatedPrintable:item.label];
//            if(quatedPrintable) {
//                if(item.value.value) {
//                    [self setValue:[VCard utf8Decode:item.value.value] forProperty:kABPersonOrganizationProperty error:nil];
//                } else {
//                    if (([item.value.values count] > 0)&&([[item.value.values objectAtIndex:0] length] > 0)) {
//                        id itemValue = [VCard utf8Decode:[item.value.values objectAtIndex:0]];
//                        if (itemValue) {
//                            [self setValue:itemValue forProperty:kABPersonOrganizationProperty error:nil];
//                        }
//                    }
//                    if (([item.value.values count] > 1)&&([[item.value.values objectAtIndex:1] length] > 0)) {
//                        id itemValue = [VCard utf8Decode:[item.value.values objectAtIndex:1]];
//                        if (itemValue) {
//                            [self setValue:itemValue forProperty:kABPersonDepartmentProperty error:nil];
//                        }
//                    }
//                }
//            }else{
//                if(item.value.value) {
//                    [self setValue:item.value.value forProperty:kABPersonOrganizationProperty error:nil];
//                } else {
//                    if (([item.value.values count] > 0)&&([[item.value.values objectAtIndex:0] length] > 0)) {
//                        id itemValue = [item.value.values objectAtIndex:0];
//                        if (itemValue) {
//                            [self setValue:itemValue forProperty:kABPersonOrganizationProperty error:nil];
//                        }
//                    }
//                    if (([item.value.values count] > 1)&&([[item.value.values objectAtIndex:1] length] > 0)) {
//                        id itemValue = [item.value.values objectAtIndex:1];
//                        if (itemValue) {
//                            [self setValue:itemValue forProperty:kABPersonDepartmentProperty error:nil];
//                        }
//                    }
//                }
//            }
        }
        if ([VcardDictionary objectForKey:ROLE] != nil ) {
            [self vcardStringToRecord:[VcardDictionary objectForKey:ROLE] property:kABPersonDepartmentProperty label:nil];
        }
        if ([VcardDictionary objectForKey:TITLE] != nil) {
            [self vcardStringToRecord:[VcardDictionary objectForKey:TITLE] property:kABPersonJobTitleProperty label:nil];
        }
        if ([VcardDictionary objectForKey:AGENT] != nil) {
            //
        }
        if ([VcardDictionary objectForKey:NICKNAME] != nil) {
            [self vcardStringToRecord:[VcardDictionary objectForKey:NICKNAME] property:kABPersonNicknameProperty label:nil];
        }
        if ([VcardDictionary objectForKey:TEL] != nil) {
           [self vcardStringToMultiRecord:[VcardDictionary objectForKey:TEL] property:kABPersonPhoneProperty];
        }
        if ([VcardDictionary objectForKey:ADR] != nil) {
             [self vcardStringToMultiRecord:[VcardDictionary objectForKey:ADR] property:kABPersonAddressProperty outValues:^(NSArray *value, ABMutableMultiValue *abValues) {
                 
                 [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     
                     NSString *addr = obj;
                     
                     VCardItem * item = [VCardItem itemWithString:addr];
                     BOOL quatedPrintable = [VCard isQuatedPrintable:item.label];
                     CFStringRef labelCategory = [VCard labelCategory:item.label];
                     NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionary];
                     if(quatedPrintable){
                         if ([item.value.values count] > 1) {
                             NSString *value = [VCard utf8Decode:[item.value.values objectAtIndex:1]];
                             if (value) {
                                 [addressDictionary setObject:value forKey:(NSString*)kABPersonAddressCountryCodeKey];
                             }
                         }
                         if([item.value.values count] > 2){
                             NSString *value = [VCard utf8Decode:[item.value.values objectAtIndex:2]];
                             if (value) {
                                 [addressDictionary setObject:value forKey:(NSString*)kABPersonAddressStreetKey];
                             }
                         }
                         if([item.value.values count] > 3){
                             NSString *value = [VCard utf8Decode:[item.value.values objectAtIndex:3]];
                             if (value) {
                                 [addressDictionary setObject:value forKey:(NSString*)kABPersonAddressCityKey];
                             }
                         }
                         if([item.value.values count] > 4){
                             NSString *value = [VCard utf8Decode:[item.value.values objectAtIndex:4]];
                             if (value) {
                                 [addressDictionary setObject:value forKey:(NSString*)kABPersonAddressStateKey];
                             }
                         }
                         if([item.value.values count] > 5){
                             NSString *value = [VCard utf8Decode:[item.value.values objectAtIndex:5]];
                             if (value) {
                                 [addressDictionary setObject:value forKey:(NSString*)kABPersonAddressZIPKey];
                             }
                             if([item.value.values count] > 6){
                                 NSString *value = [VCard utf8Decode:[item.value.values objectAtIndex:6]];
                                 if (value) {
                                     [addressDictionary setObject:value forKey:(NSString*)kABPersonAddressCountryKey];
                                 }
                             }
                         }
                         
                     } else {
                         if ([item.value.values count] > 1) {
                             NSString *value = [VCard utf8Decode:[item.value.values objectAtIndex:1]];
                             if (value) {
                                 [addressDictionary setObject:value forKey:(NSString*)kABPersonAddressCountryCodeKey];
                             }
                         }
                         if([item.value.values count] > 2){
                             NSString *value = [VCard utf8Decode:[item.value.values objectAtIndex:2]];
                             if (value) {
                                 [addressDictionary setObject:value forKey:(NSString*)kABPersonAddressStreetKey];
                             }
                         }
                         if([item.value.values count] > 3){
                             NSString *value = [VCard utf8Decode:[item.value.values objectAtIndex:3]];
                             if (value) {
                                 [addressDictionary setObject:value forKey:(NSString*)kABPersonAddressCityKey];
                             }
                         }
                         
                         if([item.value.values count] > 4){
                             NSString *value = [VCard utf8Decode:[item.value.values objectAtIndex:4]];
                             if (value) {
                                 [addressDictionary setObject:value forKey:(NSString*)kABPersonAddressStateKey];
                             }
                         }
                         if([item.value.values count] > 5){
                             NSString *value = [VCard utf8Decode:[item.value.values objectAtIndex:5]];
                             if (value) {
                                 [addressDictionary setObject:value forKey:(NSString*)kABPersonAddressZIPKey];
                             }
                         }
                         if([item.value.values count] > 6){
                             NSString *value = [VCard utf8Decode:[item.value.values objectAtIndex:6]];
                             if (value) {
                                 [addressDictionary setObject:value forKey:(NSString*)kABPersonAddressCountryKey];
                             }
                         }
                     }
                     [abValues addValue:addressDictionary withLabel:(__bridge NSString *)(labelCategory) identifier:NULL];
                  
                 }];
                     
             }];
        }
        if ([VcardDictionary objectForKey:URL] != nil) {
              [self vcardStringToMultiRecord:[VcardDictionary objectForKey:URL] property:kABPersonURLProperty];
        }
        if ([VcardDictionary objectForKey:EMAIL] != nil) {
              [self vcardStringToMultiRecord:[VcardDictionary objectForKey:EMAIL] property:kABPersonEmailProperty];
        }
        
        if ([VcardDictionary objectForKey:IM]) {
            [self vcardStringToMultiRecord:[VcardDictionary objectForKey:IM] property:kABPersonInstantMessageProperty outValues:^(NSArray *value, ABMutableMultiValue *abValues) {
                [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *vcardLine = obj;
                    VCardItem *item = [VCardItem itemWithString:vcardLine];
                    
                    NSString * labelCategory = (__bridge NSString *)([VCard labelCategory:item.label]);
                    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
                    NSDictionary *dic = [VCard dictionaryFromVCardDateString:item.value];
                    if ([dic count]) {
                        NSString *serviveName = [dic objectForKey:SERVICEKEY];
                        if (serviveName) {
                            [mutDic setObject:serviveName forKey:(id)kABPersonInstantMessageServiceKey];
                        }
                        NSString *user = [dic objectForKey:USERNAMEKEY];
                        if (user) {
                            [mutDic setObject:user forKey:(id)kABPersonInstantMessageUsernameKey];
                        }
                    } else {
                        if ([labelCategory length] > 0) {
                            [mutDic setObject:labelCategory forKey:(id)kABPersonInstantMessageServiceKey];
                        } else {
                            if ([item.label.properties count] > 1) {
                                VCardProperty *property = item.label.properties[1];
                                NSString *serviveName = property.key;
                                if (serviveName) {
                                    [mutDic setObject:serviveName forKey:(id)kABPersonInstantMessageServiceKey];
                                }
                            }
                        }
                        BOOL quatedPrintable = [VCard isQuatedPrintable:item.label];
                        NSString *valueToAdd = item.value.value;
                        if(quatedPrintable){
                            NSString *utf8String = [VCard utf8Decode:item.value.value];
                            valueToAdd = utf8String;
                        }
                        if (valueToAdd) {
                            [mutDic setObject:valueToAdd forKey:(id)kABPersonInstantMessageUsernameKey];
                        }
                    }
                    [abValues addValue:mutDic withLabel:labelCategory identifier:nil];
                }];
            }];
        }
        
//        if ([VcardDictionary objectForKey:IM]) {
//             [self vcardStringToMultiRecord:[VcardDictionary objectForKey:IM] property:kABPersonInstantMessageProperty outValues:^(NSArray *value, ABMutableMultiValue *abValues) {
//                 [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                     
//                     NSString *vcardLine = obj;
//                     VCardItem *item = [VCardItem itemWithString:vcardLine];
//                     
//                     CFStringRef labelCategory = [VCard labelCategory:item.label];
//                     
//                     NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
//                     NSDictionary *dic = [VCard dictionaryFromVCardDateString:item.value];
//                     if ([dic count]) {
//                         NSString *serviveName = [dic objectForKey:SERVICEKEY];
//                         if (serviveName) {
//                             [mutDic setObject:serviveName forKey:(id)kABPersonInstantMessageServiceKey];
//                         }
//                         NSString *user = [dic objectForKey:USERNAMEKEY];
//                         if (user) {
//                             [mutDic setObject:user forKey:(id)kABPersonInstantMessageUsernameKey];
//                         }
//                     } else {
//                         if ([item.label.properties count] > 1) {
//                             VCardProperty *property = item.label.properties[1];
//                             NSString *serviveName = property.key;
//                             if (serviveName) {
//                                 [mutDic setObject:serviveName forKey:(id)kABPersonInstantMessageServiceKey];
//                             }
//                         }
//                         BOOL quatedPrintable = [VCard isQuatedPrintable:item.label];
//                         NSString *valueToAdd = item.value.value;
//                         if(quatedPrintable){
//                             NSString *utf8String = [VCard utf8Decode:item.value.value];
//                             valueToAdd = utf8String;
//                         }else{
//                         }
//                         if (valueToAdd) {
//                             [mutDic setObject:valueToAdd forKey:(id)kABPersonInstantMessageUsernameKey];
//                         }
//                     }
//                     
//                     [abValues addValue:mutDic withLabel:(__bridge NSString *)(labelCategory) identifier:nil];
//                 }];
//             }];
//        }
        
        if ([VcardDictionary objectForKey:XRELATION]) {
            [self vcardStringToMultiRecord:[VcardDictionary objectForKey:XRELATION] property:kABPersonRelatedNamesProperty];
        }
        
        if ([VcardDictionary objectForKey:PROFILEPROPERTY]) {
           [self vcardStringToMultiRecord:[VcardDictionary objectForKey:PROFILEPROPERTY] property:kABPersonSocialProfileProperty outValues:^(NSArray *value, ABMutableMultiValue *abValues) {
               NSMutableArray *spFromVCard =  [NSMutableArray array];
              [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  VCardItem *item = [VCardItem itemWithString:obj];
                  [spFromVCard addObject:item];
              }];
               for(VCardItem *item in spFromVCard) {
                   NSDictionary *dic = [VCard dictionaryFromVCardDateString:item.value];
                   CFStringRef labelCategory = [VCard labelPersonCategory:item.label];
                   if ([dic count]) {
                       
                       NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
                       NSString *serviveName = [VCard utf8Decode:[dic objectForKey:PROFILESERVICEKEY]];
                       if (serviveName) {
                           [mutDic setObject:serviveName forKey:(id)kABPersonSocialProfileServiceKey];
                       }
                       NSString *user = [dic objectForKey:PROFILEUSERNAMEKEY];
                       if (user) {
                           [mutDic setObject:user forKey:(id)kABPersonSocialProfileUsernameKey];
                       }
                       NSString *userUrl = [VCard utf8Decode:[dic objectForKey:PROFILEURLKEY]];
                       if (userUrl) {
                           //userUrl = [VCard utf8Decode:userUrl];
                           userUrl = [userUrl stringByReplacingOccurrencesOfString:@"：" withString:@":"];
                           [mutDic setObject:userUrl forKey:(id)kABPersonSocialProfileURLKey];
                       }
                       NSString *UserIdentifie = [VCard utf8Decode:[dic objectForKey:PROFILEUSERIDENTIFIERKEY]];
                       if (UserIdentifie) {
                           [mutDic setObject:UserIdentifie forKey:(id)kABPersonSocialProfileUserIdentifierKey];
                       }
                       
                       [abValues addValue:mutDic withLabel:(__bridge NSString *)(labelCategory) identifier:nil];
                   } 
               }
           }];
        }
        
        if ([VcardDictionary objectForKey:FIRSTNAMEPHONETHIC] != nil) {
             [self vcardStringToRecord:[VcardDictionary objectForKey:FIRSTNAMEPHONETHIC] property:kABPersonFirstNamePhoneticProperty label:nil];
        }
        
        if ([VcardDictionary objectForKey:LASTNAMEPHONETHIC] != nil) {
            [self vcardStringToRecord:[VcardDictionary objectForKey:LASTNAMEPHONETHIC] property:kABPersonLastNamePhoneticProperty label:nil];
        }
        
        if ([VcardDictionary objectForKey:MIDDLENAMEPHONETHIC] != nil) {
             [self vcardStringToRecord:[VcardDictionary objectForKey:MIDDLENAMEPHONETHIC] property:kABPersonMiddleNamePhoneticProperty label:nil];
        }
        
        if ([VcardDictionary objectForKey:BRITHDAY] != nil) {
           [self vcardStringToDateRecord:[VcardDictionary objectForKey:BRITHDAY] property:kABPersonBirthdayProperty];
        }
        NSArray *photos = [VcardDictionary objectForKey:PHOTO];
        
        if ([photos count] > 0) {
            
            VCardItem * item = [VCardItem itemWithString:photos.firstObject];
 
            BOOL quatedPrintable = [VCard isQuatedPrintable:item.label];
            id value = nil;
            if(quatedPrintable)
            {
                value = [VCard utf8Decode:item.value.value];
            } else if(item.value.value){
                 value = item.value.value;
            }
            if ([value isKindOfClass:[NSString class]]) {
                self.photoID = value;
            } else if ([value isKindOfClass:[NSData class]]) {
                if (value && ((NSData *)value).length > 0) {
                    [self setImageData:value error:nil];
                }
            }
        }
        
        NSArray *groupValues = [VcardDictionary objectForKey:GROUPCODE];
        if (groupValues && [groupValues isKindOfClass:[NSArray class]]) {
            if ([groupValues count] > 0) {
                __block NSMutableArray *groupIDs = [NSMutableArray array];
                [groupValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    VCardItem * item = [VCardItem itemWithString:obj];
                    BOOL quatedPrintable = [VCard isQuatedPrintable:item.label];
                    id value = nil;
                    if(quatedPrintable)
                    {
                        value = [VCard utf8Decode:item.value.value];
                    } else if(item.value.value){
                        value = item.value.value;
                    }
                    if (value) {
                        [groupIDs addObject:value];
                    }
                }];
                self.groups = groupIDs;
            } else {
                self.groups = nil;
            }
        }
    }
    
    return YES;
}

@end
