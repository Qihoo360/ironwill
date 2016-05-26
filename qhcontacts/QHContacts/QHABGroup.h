//
//  ABGroup.h
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABRecord.h"

@class ABPerson;
@class ABSource;

@interface ABGroup : ABRecord

// use -init to create a new group

@property (nonatomic, readonly) ABSource *source;
+ (instancetype)crateABGroup;

- (NSArray *) allMembers;
- (NSArray *) allMembersSortedInOrder: (ABPersonSortOrdering) order;

- (BOOL) addMember: (ABPerson *) person error: (NSError **) error;
- (BOOL) removeMember: (ABPerson *) person error: (NSError **) error;

- (NSIndexSet *) indexSetWithAllMemberRecordIDs;

@end
