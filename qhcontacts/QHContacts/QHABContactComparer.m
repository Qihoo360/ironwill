//
//  ABContactComparer.m
//  QHContacts
//
//  Created by yanzhanlong on 16/3/3.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABContactComparer.h"
#import "QHABPerson+compare.h"
#import "QHABConfigure.h"
#import "QHABAddressBook+vCard.h"
#import "QHABPerson+vCard.h"

@implementation ABContactComparer

+ (id)comparerWithContacts:(NSArray *)leftContacts
               andContacts:(NSArray *)rightContacts {
    if (!leftContacts || !rightContacts) {
        return nil;
    }
    
    ABContactComparer * comparer = [[self alloc] init];
    if (comparer) {
        comparer.leftContacts = [leftContacts sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [[obj1 name] compare:[obj2 name]];
        }];
        comparer.rightContacts = [rightContacts sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [[obj1 name] compare:[obj2 name]];
        }];
    }
    return comparer;
}

+ (id)comparerWithVCard:(NSString *)vCard {
    
    NSArray *array = [vCard componentsSeparatedByString:ENDVCARD];
    if ([array count]== 0) {
        return nil;
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
        return nil;
    }
 
    NSMutableArray *vCardPeoples = [NSMutableArray array];
    
    for (id vcard in vcardArray) {
        if ([vcard isKindOfClass:[NSString class]]) {
            ABPerson *abPerson = [ABPerson vcardStringToPerson:vcard];
            [vCardPeoples addObject:abPerson];
        }
    }
    if ([vCardPeoples count] == 0) {
        return nil;
    }
   
    ABAddressBookRef abRef = [ABAddressBook copyAddressBookCreate];
    ABAddressBook *addressBook = [[ABAddressBook alloc] initWithABRef:abRef];
    NSArray *peopls = [addressBook allPeople];
    CFRELEASE(abRef);
    if ([peopls count] == 0) {
        return nil;
    }
    return [self comparerWithContacts:peopls andContacts:vCardPeoples];
}

#pragma mark methods

- (BOOL)compare {
    if (!_leftContacts || !_rightContacts) {
        return NO;
    }
    
    _resultSame = [NSMutableArray array];
    _resultSimilar = [NSMutableArray array];
    _resultLeft = [NSMutableArray array];
    _resultRight = [NSMutableArray array];
    
    NSInteger leftCount = [_leftContacts count];
    NSInteger rightCount = [_rightContacts count];
 
    if (leftCount < rightCount) {
        
        __block NSMutableArray *rightMutableArray = [NSMutableArray arrayWithArray:_rightContacts];
        
        [_leftContacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            __block ABPerson *leftPerson = obj;
            __block ABPerson *rightPerson = nil;
            __block NSInteger iSameCount = 0;
            __block NSInteger iMaxCount = 0;
            
            [rightMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
 
                NSComparisonResult hr = [[leftPerson name] compare:[obj name]];
                switch (hr) {
                    case NSOrderedSame: {
                        //如果完全相同，则停止循环，否则检查下一个
                        [leftPerson similarity:obj callback:^(NSInteger molecular, NSInteger denominator) {
                            if (molecular == denominator) {
                                iSameCount = molecular;
                                iMaxCount = denominator;
                                rightPerson = obj;
                                *stop = YES;
                            } else {
                                if (iSameCount < molecular) {
                                    iSameCount = molecular;
                                    iMaxCount = denominator;
                                    rightPerson = obj;
                                }
                            }
                        }];
                    }
                        break;
                    case NSOrderedAscending: {
                        *stop = YES;
                    }
                        break;
                    case NSOrderedDescending: {
                        if ([[obj name] length] > 0) {
                            [_resultRight addObject:obj];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }];
            if (rightPerson) {
                //添加相同或相似中
                if (iSameCount == iMaxCount) {
                    //完全相同
                    [_resultSame addObject:@[leftPerson, rightPerson]];
                } else {
                    [_resultSimilar addObject:@[leftPerson, rightPerson]];
                }
                
                [rightMutableArray removeObject:rightPerson];
            } else {
                [_resultLeft addObject:obj];
            }
            rightPerson = nil;
            [rightMutableArray removeObjectsInArray:_resultRight];
        }];
        
        if([rightMutableArray count] > 0) {
           [_resultRight addObjectsFromArray:rightMutableArray];
        }
        
    } else {
        __block NSMutableArray *leftMutableArray = [NSMutableArray arrayWithArray:_leftContacts];
 
        [_rightContacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __block ABPerson *leftPerson = nil;
            __block ABPerson *rightPerson = obj;
            __block NSInteger iSameCount = 0;
            __block NSInteger iMaxCount = 0;
            
            [leftMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSComparisonResult hr = [[rightPerson name] compare:[obj name]];
                switch (hr) {
                    case NSOrderedSame: {
                        //如果完全相同，则停止循环，否则检查下一个
                        [rightPerson similarity:obj callback:^(NSInteger molecular, NSInteger denominator) {
                            if (molecular == denominator) {
                                iSameCount = molecular;
                                iMaxCount = denominator;
                                leftPerson = obj;
                                *stop = YES;
                            } else if(iSameCount < molecular) {
                                iSameCount = molecular;
                                iMaxCount = denominator;
                                leftPerson = obj;
                            }
                        }];
                    }
                        break;
                    case NSOrderedAscending: {
                        *stop = YES;
                    }
                        break;
                    case NSOrderedDescending: {
                        if ([[obj name] length] > 0) {
                            [_resultLeft addObject:obj];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }];
            if (leftPerson) {
                //添加相同或相似中
                if (iSameCount == iMaxCount) {
                    //完全相同
                    [_resultSame addObject:@[leftPerson, rightPerson]];
                } else {
                    [_resultSimilar addObject:@[leftPerson, rightPerson]];
                }
                
                [leftMutableArray removeObject:leftPerson];
            } else {
                [_resultRight addObject:obj];
            }
            leftPerson = nil;
            [leftMutableArray removeObjectsInArray:_resultLeft];
        }];
        if([leftMutableArray count] > 0) {
            [_resultLeft addObjectsFromArray:leftMutableArray];
        }
    }
 
    return YES;
}

@end
