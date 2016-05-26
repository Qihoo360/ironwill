//
//  QHABRecord.m
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABRecord.h"
#import "QHABMultiValue.h"

static NSMutableIndexSet * __multiValuePropertyIDSet = nil;


@implementation ABRecord

@synthesize recordRef=_ref;

+ (void) load
{
    if ( self != [ABRecord class] )
        return;
}

+ (Class<ABRefInitialization>) wrapperClassForPropertyID: (ABPropertyID) propID
{
    if (!__multiValuePropertyIDSet) {
        __multiValuePropertyIDSet = [[NSMutableIndexSet alloc] init];
        [__multiValuePropertyIDSet addIndex: kABPersonEmailProperty];
        [__multiValuePropertyIDSet addIndex: kABPersonAddressProperty];
        [__multiValuePropertyIDSet addIndex: kABPersonDateProperty];
        [__multiValuePropertyIDSet addIndex: kABPersonPhoneProperty];
        [__multiValuePropertyIDSet addIndex: kABPersonInstantMessageProperty];
        [__multiValuePropertyIDSet addIndex: kABPersonURLProperty];
        [__multiValuePropertyIDSet addIndex: kABPersonRelatedNamesProperty];
        [__multiValuePropertyIDSet addIndex: kABPersonSocialProfileProperty];
    }
    if ( [__multiValuePropertyIDSet containsIndex: propID] ){
        return ( [ABMultiValue class] );
    }
  
    return ( Nil );
}

- (id) initWithABRef: (CFTypeRef) recordRef
{
    assert(recordRef);
    if (self = [super init] ) {
        _ref = (ABRecordRef) CFRetain(recordRef);
    }
    return ( self );
}

- (void) dealloc
{
    CFRELEASE( _ref );
}

- (ABRecordID) recordID
{
    return ( ABRecordGetRecordID(_ref) );
}

- (ABRecordType) recordType
{
    return ( ABRecordGetRecordType(_ref) );
}
 
- (id) valueForProperty: (ABPropertyID) property
{
    id idValue = (__bridge_transfer id)(ABRecordCopyValue( _ref, property ));
    if (idValue == nil) {
        return nil;
    }
    
    Class<ABRefInitialization> wrapperClass = [[self class] wrapperClassForPropertyID: property];
    if ( wrapperClass != Nil ) {
        return [[wrapperClass alloc] initWithABRef: (__bridge CFTypeRef)idValue];
    } else {
        return idValue;
    }
}

- (BOOL) setValue: (id) value forProperty: (ABPropertyID) property error: (NSError **) error
{
    CFTypeRef ref = Nil;
    if ([value isKindOfClass:[ABMultiValue class]]) {
        ref = [value getMultiValueRef];
    } else {
        ref = (__bridge CFTypeRef)value;
    }
    CFErrorRef errorRef = NULL;
    
    BOOL hr = ( (BOOL) ABRecordSetValue(_ref, property, ref, &errorRef) );
    NSError * theError = (__bridge_transfer NSError *)(errorRef);
    if (error) {
        *error = theError;
        //NSLog(@"theError = %@",[theError localizedDescription]);
    }
    
    return hr;
}

- (BOOL) removeValueForProperty: (ABPropertyID) property error: (NSError **) error
{
    CFErrorRef errorRef = NULL;
    
    BOOL hr =  (BOOL) ABRecordRemoveValue(_ref, property, &errorRef);
    NSError * theError = (__bridge_transfer NSError *)(errorRef);
    if (error) {
        *error = theError;
         //NSLog(@"theError = %@",[theError localizedDescription]);
    }
    return hr;
    
}

- (NSString *) compositeName
{
    return (__bridge_transfer NSString *) ABRecordCopyCompositeName( _ref );
}
@end
