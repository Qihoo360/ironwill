//
//  ABMultiValue.m
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABMultiValue.h"

@interface ABMultiValue ()

@end

@implementation ABMultiValue
@synthesize multiValueRef=_ref;

- (id) initWithABRef: (CFTypeRef) ref
{
    assert(ref);
    self = [super init];
    if ( self ) {
        _ref = (ABMultiValueRef) CFRetain(ref);
    }
    return self;
}

- (void) dealloc
{
    CFRELEASE( _ref );
}

- (id) copyWithZone: (NSZone *) zone
{
    return (self);
}

- (id) mutableCopyWithZone: (NSZone *) zone
{
    ABMultiValueRef ref = ABMultiValueCreateMutableCopy( _ref );
    ABMutableMultiValue * result = [[ABMutableMultiValue allocWithZone: zone] initWithABRef: (CFTypeRef)ref];
    CFRELEASE( ref );
    return ( result );
}

- (ABPropertyType) propertyType
{
    return ( ABMultiValueGetPropertyType(_ref) );
}

- (NSUInteger) count
{
    return ( (NSUInteger) ABMultiValueGetCount(_ref) );
}

- (id) valueAtIndex: (NSUInteger) index
{
    return (__bridge_transfer id) ABMultiValueCopyValueAtIndex( _ref, (CFIndex)index );
}

- (NSArray *) allValues
{
    return (__bridge_transfer NSArray *) ABMultiValueCopyArrayOfAllValues( _ref );
}

- (NSString *) labelAtIndex: (NSUInteger) index
{
    return (__bridge_transfer NSString *) ABMultiValueCopyLabelAtIndex( _ref, (CFIndex)index );
}

- (NSString *) localizedLabelAtIndex: (NSUInteger) index
{
   return (__bridge_transfer NSString *) ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)[self labelAtIndex: index] );
}

- (NSUInteger) indexForIdentifier: (ABMultiValueIdentifier) identifier
{
    return ( (NSUInteger) ABMultiValueGetIndexForIdentifier(_ref, identifier) );
}

- (ABMultiValueIdentifier) identifierAtIndex: (NSUInteger) index
{
    return ( ABMultiValueGetIdentifierAtIndex(_ref, (CFIndex)index) );
}

- (NSUInteger) indexOfValue: (id) value
{
    return ( (NSUInteger) ABMultiValueGetFirstIndexOfValue(_ref, (__bridge CFTypeRef)value) );
}

@end

#pragma mark -

@implementation ABMutableMultiValue

- (id) initWithPropertyType: (ABPropertyType) type
{
    assert(type&kABMultiValueMask);
    ABMutableMultiValueRef ref = ABMultiValueCreateMutable(type);//kABMultiStringPropertyType
    ABMutableMultiValue * mv = [self initWithABRef: (CFTypeRef)ref];
    CFRELEASE(ref);
    return mv;
}

- (id) copyWithZone: (NSZone *) zone
{
    // no AB method to create an immutable copy, so we do a mutable copy but wrap it in an immutable class
    CFTypeRef _obj = ABMultiValueCreateMutableCopy(_ref);
    ABMultiValue * result = [[ABMultiValue allocWithZone: zone] initWithABRef: _obj];
    CFRELEASE( _obj );
    return ( result );
}

- (ABMutableMultiValueRef) _mutableRef
{
    return ( (ABMutableMultiValueRef)_ref );
}

- (BOOL) addValue: (id) value
        withLabel: (NSString *) label
       identifier: (ABMultiValueIdentifier *) outIdentifier
{
    return ( (BOOL) ABMultiValueAddValueAndLabel([self _mutableRef], (__bridge CFTypeRef)value, (__bridge CFStringRef)label, outIdentifier) );
}

- (BOOL) insertValue: (id) value
           withLabel: (NSString *) label
             atIndex: (NSUInteger) index
          identifier: (ABMultiValueIdentifier *) outIdentifier
{
    return ( (BOOL) ABMultiValueInsertValueAndLabelAtIndex([self _mutableRef], (__bridge CFTypeRef)value, (__bridge CFStringRef)label, (CFIndex)index, outIdentifier) );
}

- (BOOL) addMultiValue: (ABMultiValue *)multivalue
{
    for(int i=0;i < [multivalue count];i++) {
        id value = [multivalue valueAtIndex:i];
        if (value) {
            NSString *label = [multivalue labelAtIndex: i];
            if ([label length] == 0) {
                label = @"";
            }
            
            [self addValue:value  withLabel:label identifier: nil];
        }
    }
    return YES;
}


- (BOOL) removeValueAndLabelAtIndex: (NSUInteger) index
{
    return ( (BOOL) ABMultiValueRemoveValueAndLabelAtIndex([self _mutableRef], (CFIndex)index) );
}

- (BOOL) replaceValueAtIndex: (NSUInteger) index withValue: (id) value
{
    return ( (BOOL) ABMultiValueReplaceValueAtIndex([self _mutableRef], (__bridge CFTypeRef)value, (CFIndex)index) );
}

- (BOOL) replaceLabelAtIndex: (NSUInteger) index withLabel: (NSString *) label
{
    return ( (BOOL) ABMultiValueReplaceLabelAtIndex([self _mutableRef], (__bridge CFStringRef)label, (CFIndex)index) );
}

- (NSString*) description {
    return [NSString stringWithFormat: @"ABMultiValue with %lu elements",(unsigned long)[self count]];
}

@end
