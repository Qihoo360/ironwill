//
//  ABAddressBook.m
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//
#import <libkern/OSAtomic.h>
#import "QHABAddressBook.h"
#import "QHABPerson.h"
#import "QHABGroup.h"
#import "QHABSource.h"

NSString *ABAddressBookDidChangeNotification = @"ABAddressBookDidChange";
NSArray * WrappedArrayOfRecords( NSArray * records, Class<ABRefInitialization> wrapperClass )
{
    NSMutableArray * wrapped = [NSMutableArray array];
    for ( id record in records )
    {
        id obj = [[wrapperClass alloc] initWithABRef: (CFTypeRef)record];
        [wrapped addObject: obj];
    }
    return ( wrapped);
}
 
@interface ABAddressBook ()
- (void) _handleExternalChangeCallback;
@end

static void _ExternalChangeCallback(ABAddressBookRef bookRef, CFDictionaryRef info, void * context )
{
    ABAddressBook * obj = (__bridge ABAddressBook *) context;
    [obj _handleExternalChangeCallback];
}

@implementation ABAddressBook
@synthesize addressBookRef=_ref;

+ (ABAddressBook *) sharedAddressBook
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
        [obj startMonitorAddressBook];
    });
    return obj;
}

+ (ABAddressBookRef)copyAddressBookCreate {
    @synchronized(self) {
        ABAddressBookRef addressbook = nil;
        
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (kABAuthorizationStatusDenied != status) {
            addressbook = ABAddressBookCreateWithOptions(NULL, NULL);
        }
        if (status != kABAuthorizationStatusAuthorized) {
            __block BOOL accessGranted = NO;
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            //dispatch_release(sema);
            
            if (!accessGranted) {
                CFRELEASE(addressbook);
                addressbook = nil;
            }
        } 
        return addressbook;
    }
}



//清空通讯录
+ (void)cleanEmptyContacts:(void (^)(enumCleanState state))resultState {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ABAddressBookRef addressBook = [self copyAddressBookCreate];
        if (addressBook) {
            if (resultState) {
                resultState(CleanStateBegin);
            }
            
            CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
            if (people) {
                CFIndex count = CFArrayGetCount(people);
                for (CFIndex index = 0; index < count; index++) {
                    ABRecordRef record = CFArrayGetValueAtIndex(people, index);
                    ABAddressBookRemoveRecord(addressBook, record, NULL);
                }
                CFRELEASE(people);
            }
            
            CFArrayRef groups = ABAddressBookCopyArrayOfAllGroups(addressBook);
            if (groups) {
                CFIndex countGroups = CFArrayGetCount(groups);
                for (CFIndex index = 0; index < countGroups; index++) {
                    ABRecordRef record = CFArrayGetValueAtIndex(groups, index);
                    ABAddressBookRemoveRecord(addressBook, record, NULL);
                }
                CFRELEASE(groups);
            }
            
            if (resultState) {
                resultState(CleanStateSaveing);
            }
            
            ABAddressBookSave(addressBook, NULL);
            CFRELEASE(addressBook);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultState) {
                resultState(CleanStateEnd);
            }
        });
    });
}

- (id) initWithABRef: (CFTypeRef) ref
{
    assert(ref!= NULL);
    
    self = [super init];
    if (self) {
        // we can't to CFTypeID checking on AB types, so we have to trust the user
        _ref = (ABAddressBookRef) CFRetain(ref);
        //[self startMonitorAddressBook];
    }
    return (self);
}

- (void)startMonitorAddressBook {
    if ([NSThread isMainThread]) {
        ABAddressBookRegisterExternalChangeCallback(  _ref, _ExternalChangeCallback, (__bridge void *)(self) );
    } else {
        [self performSelectorOnMainThread:@selector(startMonitorAddressBook) withObject:nil waitUntilDone:NO];
    } 
}

- (id) init
{
    self = [super init];
    if (self) {
        CFTypeRef ref = [ABAddressBook copyAddressBookCreate];
        if (ref) {
            _ref = (ABAddressBookRef) CFRetain(ref);
            CFRELEASE(ref);
        }  else {
            return nil;
        }
    }
    return self; 
}

- (void) dealloc
{
    ABAddressBookUnregisterExternalChangeCallback(_ref,_ExternalChangeCallback,(__bridge void *)(self));
    self.delegate = nil;
    CFRELEASE( _ref);
}


- (BOOL) save: (NSError **) error
{
    @synchronized(self) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ABAddressBookDidChangeNotification object:self];
        
        CFErrorRef errorRef = NULL;
        
        BOOL result = (BOOL) ABAddressBookSave( _ref, &errorRef);
        NSError * theError = (__bridge_transfer NSError *)(errorRef);
        if (error) {
            *error = theError;
             //NSLog(@"theError = %@",[theError localizedDescription]);
        }
        return ( result );
    }
}

- (BOOL) hasUnsavedChanges
{
    @synchronized(self) {
        return ( (BOOL) ABAddressBookHasUnsavedChanges( _ref) );
    }
}

- (BOOL) addRecord: (ABRecord *) record error: (NSError **) error
{
    @synchronized(self) {
        CFErrorRef errorRef = NULL;
        BOOL hr = (BOOL) ABAddressBookAddRecord( _ref, record.recordRef, &errorRef);
        NSError * theError = (__bridge_transfer NSError *)(errorRef);
        if (error) {
            *error = theError;
             //NSLog(@"theError = %@",[theError localizedDescription]);
        }
        
        return hr;
    }
}

- (BOOL) removeRecord: (ABRecord *) record error: (NSError **) error
{
    @synchronized(self) {
        CFErrorRef errorRef = NULL;
        BOOL hr = (BOOL) ABAddressBookRemoveRecord( _ref, record.recordRef, &errorRef);
        NSError * theError = (__bridge_transfer NSError *)(errorRef);
        if (error) {
            *error = theError;
             //NSLog(@"theError = %@",[theError localizedDescription]);
        }
        
        return hr;
    }
}

- (NSString *) localizedStringForLabel: (NSString *) label
{
    @synchronized(self) {
        return (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)label );
    }
}

- (void) revert
{
    @synchronized(self) {
        ABAddressBookRevert(  _ref );
    }
}

- (void) _handleExternalChangeCallback
{
    @synchronized(self) {
    if(_delegate && [_delegate respondsToSelector:@selector(addressBookDidChange:)])
        [_delegate addressBookDidChange: self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ABAddressBookDidChangeNotification object:self];
    }
}

@end

@implementation ABAddressBook (People)

- (NSUInteger) personCount
{
    @synchronized(self) {
        return ( (NSUInteger) ABAddressBookGetPersonCount( _ref) );
    }
}

-(ABPerson *) personWithRecordRef:(ABRecordRef) recordRef
{
    @synchronized(self) {
    return ([[ABPerson alloc] initWithABRef: recordRef]);
    }
}

- (ABPerson *) personWithRecordID: (ABRecordID) recordID
{
    @synchronized(self) {
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(_ref, recordID);
        if ( person == NULL )
            return ( nil );
        
        return ( [[ABPerson alloc] initWithABRef: person] );
    }
}

- (NSArray *) allPeople
{
    @synchronized(self) {
        NSArray * people = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(_ref);
        if ( [people count] == 0 )
        {
            return ( nil );
        }
        
        return WrappedArrayOfRecords( people, [ABPerson class]);
    }
}

- (NSArray *) allPeopleSorted
{
    @synchronized(self) {
        NSArray *peoples = [self allPeople];
        NSArray *result = [peoples sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        return ( result );
    }
}

- (NSArray *) allPeopleWithName: (NSString *) name
{
    @synchronized(self) {
        NSArray * people = (__bridge_transfer NSArray *) ABAddressBookCopyPeopleWithName(  _ref, (__bridge CFStringRef)name );
        if ( [people count] == 0 ) {
            return ( nil );
        }
        
        return WrappedArrayOfRecords(people, [ABPerson class]);
    }
}

@end

@implementation ABAddressBook (Groups)

- (NSUInteger) groupCount
{
    @synchronized(self) {
        return ( (NSUInteger) ABAddressBookGetGroupCount( _ref) );
    }
}

- (ABGroup *) groupWithRecordID: (ABRecordID) recordID
{
    @synchronized(self) {
        ABRecordRef group = ABAddressBookGetGroupWithRecordID(_ref, recordID);
        if ( group == NULL )
            return ( nil );
        
        return ( [[ABGroup alloc] initWithABRef: group] );
    }
}

- (NSArray *) allGroups
{
    @synchronized(self) {
        NSArray * groups = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllGroups(  _ref );
        if ( [groups count] == 0 ) {
            return ( nil );
        }
        
       return WrappedArrayOfRecords(groups, [ABGroup class]);
    }
}

@end

@implementation ABAddressBook (Sources)

- (ABSource *) sourceWithRecordID: (ABRecordID) recordID
{
    @synchronized(self) {
        ABRecordRef source = ABAddressBookGetSourceWithRecordID(_ref, recordID);
        if ( source == NULL )
            return ( nil );
        
        return ([[ABSource alloc] initWithABRef: source] );
    }
}

- (ABSource *) defaultSource
{
    @synchronized(self) {
        ABRecordRef source = ABAddressBookCopyDefaultSource(_ref);
        if ( source == NULL ) {
            return ( nil );
        }
        
        ABSource *abSource = ([[ABSource alloc] initWithABRef: source] );
        CFRELEASE(source);
        return abSource;
    }
}

- (NSArray *) allSources
{
    @synchronized(self) {
        NSArray * sources = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllSources(  _ref );
        if ( [sources count] == 0 ) {
            return ( nil );
        } 
        return WrappedArrayOfRecords( sources, [ABSource class] );
    }
}


@end
