//
//  ABSource.m
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABSource.h"
#import "QHABAddressBook.h"
#import "QHABGroup.h"
#import "QHABPerson.h"

extern NSArray * WrappedArrayOfRecords( NSArray * records, Class<ABRefInitialization> class );


@implementation ABSource

- (NSArray *) allGroups
{
    NSArray * groups = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllGroupsInSource( [ABAddressBook sharedAddressBook].addressBookRef, _ref );
    if ( [groups count] == 0 )
    {
        return ( nil );
    }
    
    return WrappedArrayOfRecords( groups, [ABGroup class] );
}

- (NSArray *) allPeoples {
    NSArray * peoples = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeopleInSource( [ABAddressBook sharedAddressBook].addressBookRef, _ref );
    if ( [peoples count] == 0 )
    {
        return ( nil );
    }
    
    return WrappedArrayOfRecords( peoples, [ABPerson class] ); 
}



+ (BOOL)isExchange {
    __block BOOL isExchange = NO;
    NSArray *array = [[ABAddressBook sharedAddressBook] allSources];
    if (array) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ABSource *source = obj;
            NSNumber * type = [source valueForProperty:kABSourceTypeProperty];
            if (type) {
                ABSourceType sourceType = [type intValue];
                if (sourceType == kABSourceTypeExchange || sourceType == kABSourceTypeExchangeGAL) {
                    isExchange = YES;
                    *stop = YES;
                }
            }
        }];
    }
    return isExchange;
}

+ (BOOL)isAllExchange {
    __block BOOL isExchange = NO;
    __block BOOL isAllExchange = YES;
    NSArray *array = [[ABAddressBook sharedAddressBook] allSources];
    if (array) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ABSource *source = obj;
            NSNumber * type = [source valueForProperty:kABSourceTypeProperty];
            if (type) {
                ABSourceType sourceType = [type intValue];
                if (sourceType == kABSourceTypeExchange || sourceType == kABSourceTypeExchangeGAL) {
                    isExchange = YES;
                } else {
                    isAllExchange = NO;
                }
            }
        }];
    }
    return isAllExchange;
}

@end
