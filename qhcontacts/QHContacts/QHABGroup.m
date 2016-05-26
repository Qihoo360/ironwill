//
//  ABGroup.m
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABGroup.h"

#import "QHABPerson.h"
#import "QHABSource.h"

extern NSArray * WrappedArrayOfRecords( NSArray * records, Class<ABRefInitialization> class );

@implementation ABGroup

+ (instancetype)crateABGroup {
    ABRecordRef group = ABGroupCreate(); 
    ABGroup *abGroup = [[ABGroup alloc] initWithABRef:group];
    CFRELEASE(group);
    return abGroup;
}

- (ABSource *) source
{
    ABRecordRef sourceRef = ABGroupCopySource( _ref );
    ABSource * source = [[ABSource alloc] initWithABRef: sourceRef];
    CFRELEASE(sourceRef);
    return source;
}

- (NSArray *) allMembers
{
    NSArray * members = (__bridge_transfer NSArray *) ABGroupCopyArrayOfAllMembers( _ref );
    if ( [members count] == 0 )
    {
        return ( nil );
    }
    
    return WrappedArrayOfRecords( members, [ABPerson class] );
}

- (NSArray *) allMembersSortedInOrder: (ABPersonSortOrdering) order
{
    NSArray * members = (__bridge_transfer NSArray *) ABGroupCopyArrayOfAllMembersWithSortOrdering( _ref, order );
    if ( [members count] == 0 )
    {
        return ( nil );
    }
    
    return WrappedArrayOfRecords( members, [ABPerson class] );
}

- (BOOL) addMember: (ABPerson *) person error: (NSError **) error
{
    CFErrorRef errorRef = NULL;
    BOOL hr = ( (BOOL) ABGroupAddMember(_ref, person.recordRef, &errorRef) );
    NSError * theError = (__bridge_transfer NSError *)(errorRef);
    if (error) {
        *error = theError;
         //NSLog(@"theError = %@",[theError localizedDescription]);
    }
    
    return hr;
}

- (BOOL) removeMember: (ABPerson *) person error: (NSError **) error
{
    CFErrorRef errorRef = NULL;
    BOOL hr = ( (BOOL) ABGroupRemoveMember(_ref, person.recordRef, &errorRef) );
    NSError * theError = (__bridge_transfer NSError *)(errorRef);
    if (error) {
        *error = theError;
        // NSLog(@"theError = %@",[theError localizedDescription]);
    }
   
    return hr;
}

- (NSIndexSet *) indexSetWithAllMemberRecordIDs
{
    NSArray * members = (__bridge_transfer NSArray *) ABGroupCopyArrayOfAllMembers( _ref );
    if ( [members count] == 0 )
    {
        return ( nil );
    }
    
    NSMutableIndexSet * mutable = [[NSMutableIndexSet alloc] init];
    for ( id person in members )
    {
        [mutable addIndex: (NSUInteger)ABRecordGetRecordID((__bridge ABRecordRef)person)];
    }
    
   
    return ( mutable );
}
@end
