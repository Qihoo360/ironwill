//
//  ABAddressBook+vCard.m
//  QHContacts
//
//  Created by yanzhanlong on 16/2/19.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABAddressBook+vCard.h"
#import "QHABPerson+vCard.h"
#import "QHABConfigure.h"
#import "QHABContactComparer.h"
#import "QHABPerson+compare.h"

@implementation ABAddressBook (vCard)

+ (id)vcardStringToAddressBook:(NSString *)vCard {
  
    ABAddressBook *address = [[ABAddressBook alloc] init];
    [address updataAddressBookByVcardString:vCard];
    
    NSError *error = nil;
    [address save:&error];
    if (error.code != 0) {
        //NSLog(@"%@",error.localizedDescription);
    }
    
    return address;
}

- (NSString*)vcardString {
     NSMutableString *formattedVcard = [NSMutableString string];
    
    NSArray *peoples = [self allPeople];
    [peoples enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ABPerson *person = obj;
        [formattedVcard appendString:[person vcardStringByGroupInfo:nil]];
    }];
 
    return formattedVcard;
}

//- (BOOL)updataAddressBookByVcardString:(NSString *)vCard {
//    
//    NSArray *array = [vCard componentsSeparatedByString:ENDVCARD];
//    if ([array count]== 0) {
//        return NO;
//    }
//    NSMutableArray *vcardArray =[NSMutableArray arrayWithArray:array];
//    NSInteger count = [array count];
//    NSInteger flagLength = [VCARDFLAG length];
//    id lastItem = [array objectAtIndex:(count - 1)];
//    if ([lastItem length] <= flagLength) {
//        count --;
//        [vcardArray removeObject:lastItem];
//    }
//    
//   __block NSMutableArray *allPeoples = [NSMutableArray array];
//    
//    
//    NSArray *peoples = [self allPeopleSorted];
//    if (peoples) {
//        NSLog(@"peoples = %ld",[peoples count]);
//        
//        [allPeoples addObjectsFromArray:peoples];
//    }
//    
//    ABPerson * (^findSamePerson)(ABPerson *) =
//    ^ABPerson * (ABPerson * person) {
//        
//        __block ABPerson *findPerson = nil;
//        [allPeoples enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            ABPerson *addPerson = obj;
// 
//            NSComparisonResult hr = [[person name] compare:[addPerson name]];
//            
//            NSLog(@"%@ compare %@ = %ld",[person name],[addPerson name],(long)hr);
//            switch (hr) {
//                case NSOrderedSame: {
//                    findPerson = addPerson;
//                }
//                    break;
//                case NSOrderedAscending: {
//                    *stop = YES;
//                }
//                    break;
//                case NSOrderedDescending: {
//                    
//                }
//                    break;
//                default:
//                    break;
//            }
//        }];
//        
//        return findPerson;
//    };
// 
//    for (id vcard in vcardArray) {
//        if ([vcard isKindOfClass:[NSString class]]) {
//            ABPerson *abPerson = [ABPerson vcardStringToPerson:vcard];
//            //查找相同名字的联系人
//            ABPerson *addPerson = findSamePerson(abPerson);
//            if (addPerson) {
//                [addPerson updataPersonByVcardString:vcard];
//                [allPeoples removeObject:addPerson];
//            } else {
//                [self addRecord:abPerson error:nil];
//            }
//        }
//    }
//
//    return YES;
//}
- (BOOL)updataAddressBookByVcardString:(NSString *)vCard {
    
    NSArray *array = [vCard componentsSeparatedByString:ENDVCARD];
    if ([array count]== 0) {
        return NO;
    }
    NSMutableArray *vcardArray =[NSMutableArray arrayWithArray:array];
    NSInteger count = [array count];
    NSInteger flagLength = [VCARDFLAG length];
    id lastItem = [array objectAtIndex:(count - 1)];
    if ([lastItem length] <= flagLength) {
        count --;
        [vcardArray removeObject:lastItem];
    }
 
    if (count == 0) {
        return NO;
    }
    
    NSArray *peoples = [self allPeople];
  
    NSMutableArray *vCardPeoples = [NSMutableArray array];
    
    for (id vcard in vcardArray) {
        if ([vcard isKindOfClass:[NSString class]]) {
            ABPerson *abPerson = [ABPerson vcardStringToPerson:vcard];
            [vCardPeoples addObject:abPerson];
        }
    }
    if ([vCardPeoples count] == 0) {
        return NO;
    }
    
    if ([peoples count] == 0) {
        [vCardPeoples enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addRecord:obj error:nil];
        }];
    } else {
        
        ABContactComparer *comparer = [ABContactComparer comparerWithContacts:peoples andContacts:vCardPeoples];
        if ([comparer compare]) {
            if ([comparer.resultRight count] > 0) {
                [comparer.resultRight enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self addRecord:obj error:nil];
                }];
            }
            if ([comparer.resultSimilar count] > 0) {
                [comparer.resultSimilar enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSArray *array = obj;
                    ABPerson *leftPerson = array[0];
                    ABPerson *rightPerson = array[1];
                    [leftPerson updateByABPerson:rightPerson];
                }];
            }
        }
    }
    return YES;
}
@end
