//
//  ABMultiValue.h
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABRefInitialization.h"

@interface ABMultiValue : NSObject<ABRefInitialization, NSCopying, NSMutableCopying>
{
    ABMultiValueRef _ref;
}
@property (nonatomic, readonly, getter=getMultiValueRef) ABMultiValueRef multiValueRef;

@property (nonatomic, readonly) ABPropertyType propertyType;
@property (nonatomic, readonly) NSUInteger count;

- (id) valueAtIndex: (NSUInteger) index;
- (NSArray *) allValues;

- (NSString *) labelAtIndex: (NSUInteger) index;
- (NSString *) localizedLabelAtIndex: (NSUInteger) index;

- (NSUInteger) indexForIdentifier: (ABMultiValueIdentifier) identifier;
- (ABMultiValueIdentifier) identifierAtIndex: (NSUInteger) index;

// returns the index of the first occurrence of the specified value
- (NSUInteger) indexOfValue: (id) value;

@end

#pragma mark -

@interface ABMutableMultiValue : ABMultiValue

- (id) initWithPropertyType: (ABPropertyType) type;

- (BOOL) addValue: (id) value withLabel: (NSString *) label identifier: (ABMultiValueIdentifier *) outIdentifier;
- (BOOL) insertValue: (id) value withLabel: (NSString *) label atIndex: (NSUInteger) index identifier: (ABMultiValueIdentifier *) outIdentifier;
- (BOOL) addMultiValue: (ABMultiValue *)multivalue;

- (BOOL) removeValueAndLabelAtIndex: (NSUInteger) index;

- (BOOL) replaceValueAtIndex: (NSUInteger) index withValue: (id) value;
- (BOOL) replaceLabelAtIndex: (NSUInteger) index withLabel: (NSString *) label;

@end
