//
//  QHABRecord.h
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABRefInitialization.h"

@interface ABRecord : NSObject<ABRefInitialization>
{
    ABRecordRef     _ref;
}
@property (nonatomic, readonly, getter=getRecordRef) ABRecordRef recordRef;

@property (nonatomic, readonly) ABRecordID recordID;
@property (nonatomic, readonly) ABRecordType recordType;

- (id) valueForProperty: (ABPropertyID) property;
- (BOOL) setValue: (id) value forProperty: (ABPropertyID) property error: (NSError **) error;
- (BOOL) removeValueForProperty: (ABPropertyID) property error: (NSError **) error;

@property (nonatomic, readonly) NSString * compositeName;

@end
