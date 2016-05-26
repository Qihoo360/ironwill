//
//  ABPerson.m
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABPerson.h"

@implementation ABPerson

+ (ABPropertyType) typeOfProperty: (ABPropertyID) property
{
    return ( ABPersonGetTypeOfProperty(property) );
}

+ (NSString *) localizedNameOfProperty: (ABPropertyID) property
{
   return(__bridge_transfer NSString *) ABPersonCopyLocalizedPropertyName(property);
}

+ (ABPersonSortOrdering) sortOrdering
{
    return ( ABPersonGetSortOrdering() );
}

+ (ABPersonCompositeNameFormat) compositeNameFormat
{
    return ( ABPersonGetCompositeNameFormat() );
}

+ (instancetype)creatABPerson {
    ABRecordRef person = ABPersonCreate();
    ABPerson *abPerson = [[ABPerson alloc] initWithABRef: person];
    CFRELEASE(person);
    return (abPerson);
}
 
//- (id) init
//{
//    ABRecordRef person = ABPersonCreate();
//    if ( person == NULL )
//    {
//        return ( nil );
//    }
//    
//    if (self = [super initWithABRef: person] ){
//        CFRELEASE(person);
//        
//        return (self);
//    }
//    return ( nil );
//}

- (NSString*) description
{
    return [NSString stringWithFormat: @"ABPerson %d - %@",[self recordID], [self compositeName]];
}

- (BOOL) setImageData: (NSData *) imageData error: (NSError **) error
{
    CFErrorRef errorRef = NULL;
    BOOL hr = ( (BOOL) ABPersonSetImageData(_ref, (__bridge CFDataRef)imageData, &errorRef) );
    NSError * theError = (__bridge_transfer NSError *)(errorRef);
    if (error) {
        *error = theError;
         //NSLog(@"theError = %@",[theError localizedDescription]);
    }
    
    return hr;
}

- (NSData *) imageData
{
   return (__bridge_transfer NSData *) ABPersonCopyImageData( _ref );
}

- (NSData *) thumbnailImageData
{
   return (__bridge_transfer NSData *) ABPersonCopyImageDataWithFormat( _ref, kABPersonImageFormatThumbnail );
}

- (BOOL) hasImageData
{
    return ( (BOOL) ABPersonHasImageData(_ref) );
}

- (BOOL) removeImageData: (NSError **) error
{
    CFErrorRef errorRef = NULL;
    BOOL hr = ( (BOOL) ABPersonRemoveImageData(_ref, &errorRef) );
    NSError * theError = (__bridge_transfer NSError *)(errorRef);
    if (error) {
        *error = theError;
        // NSLog(@"theError = %@",[theError localizedDescription]);
    }
    return hr;
}

- (NSComparisonResult) compare: (ABPerson *) otherPerson
{
    return [[self name] compare:[otherPerson name]]; 
}

- (NSComparisonResult) compare: (ABPerson *) otherPerson sortOrdering: (ABPersonSortOrdering) order
{
    return [[self name] compare:[otherPerson name]]; 
}

-(NSString*)getFirstName
{
    NSString *firstName = [self valueForProperty:kABPersonFirstNameProperty];
    if (firstName == nil) {
        firstName = @"";
    }
    return firstName;
}

- (void)setFirstName:(NSString *)firstName {
    [self setValue:firstName forProperty:kABPersonFirstNameProperty error:nil];
}

-(NSString*)getLastName
{
    NSString * lastName = [self valueForProperty:kABPersonLastNameProperty];
    if (lastName == nil) {
        lastName = @"";
    }
    return lastName;
}

- (void)setLastName:(NSString *)lastName {
    [self setValue:lastName forProperty:kABPersonLastNameProperty error:nil];
}

- (NSString *)getMiddleName {
    NSString *name = [self valueForProperty:kABPersonMiddleNameProperty];
    
    if (name == nil) {
        name = @"";
    }
    return name;
}

- (void)setMiddleName:(NSString *)middleName {
    [self setValue:middleName forProperty:kABPersonMiddleNameProperty error:nil];
}

- (ABPersonCompositeNameFormat) compositeNameFormat {
    return ABPersonGetCompositeNameFormatForRecord([self getRecordRef]);
}

- (void)clearAllName {
    [self removeValueForProperty:kABPersonFirstNameProperty error:nil];
    [self removeValueForProperty:kABPersonMiddleNameProperty error:nil];
    [self removeValueForProperty:kABPersonLastNameProperty error:nil];
    [self removeValueForProperty:kABPersonPrefixProperty error:nil];
    [self removeValueForProperty:kABPersonSuffixProperty error:nil];
}

- (NSString *)name {
    @autoreleasepool {
        NSString *fullName = [self compositeName];
        if ([fullName length] > 0) {
            fullName = [fullName stringByReplacingOccurrencesOfString:@"[\\s]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, fullName.length)];
        }
        
        if ([fullName length] == 0) {
            fullName = @"";
        }
        
        //    if (ABPersonGetCompositeNameFormat() == kABPersonCompositeNameFormatFirstNameFirst) {
        //        fullName = [NSString stringWithFormat:@"%@%@%@", self.firstName, self.middleName, self.lastName];
        //    }
        //    else{
        //        fullName = [NSString stringWithFormat:@"%@%@%@", self.lastName, self.middleName, self.firstName];
        //    }
        return fullName;
    } 
}

@end
