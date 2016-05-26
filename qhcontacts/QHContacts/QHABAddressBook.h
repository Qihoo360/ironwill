//
//  ABAddressBook.h
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABRefInitialization.h"
typedef enum {
    CleanStateBegin = 0,
    CleanStateSaveing,
    CleanStateEnd,
}enumCleanState;


extern NSString *ABAddressBookDidChangeNotification;

@class ABAddressBook,ABRecord, ABPerson, ABGroup, ABSource;
@protocol ABAddressBookDelegate <NSObject>
- (void) addressBookDidChange: (ABAddressBook *) addressBook;
@end

@interface ABAddressBook : NSObject <ABRefInitialization>
{
    ABAddressBookRef            _ref; 
}
+ (ABAddressBook *) sharedAddressBook;
+ (ABAddressBookRef)copyAddressBookCreate;
+ (void)cleanEmptyContacts:(void (^)(enumCleanState state))resultState;

@property (nonatomic, readonly, getter=getAddressBookRef) ABAddressBookRef addressBookRef;

@property (nonatomic, assign) id<ABAddressBookDelegate> delegate;

- (BOOL) save: (NSError **) error;
@property (nonatomic, readonly) BOOL hasUnsavedChanges;

- (BOOL) addRecord: (ABRecord *) record error: (NSError **) error;
- (BOOL) removeRecord: (ABRecord *) record error: (NSError **) error;

- (NSString *) localizedStringForLabel: (NSString *) labelName;

- (void) revert;

@end

@interface ABAddressBook (People)

@property (nonatomic, readonly) NSUInteger personCount;
 
- (ABPerson *) personWithRecordID: (ABRecordID) recordID;
- (ABPerson *) personWithRecordRef:(ABRecordRef) recordRef;
- (NSArray *) allPeople;
- (NSArray *) allPeopleSorted;
- (NSArray *) allPeopleWithName: (NSString *) name;

@end

@interface ABAddressBook (Groups)

@property (nonatomic, readonly) NSUInteger groupCount;

- (ABGroup *) groupWithRecordID: (ABRecordID) recordID;
- (NSArray *) allGroups;

@end

@interface ABAddressBook (Sources)

- (ABSource *) sourceWithRecordID: (ABRecordID) recordID;
- (ABSource *) defaultSource;
- (NSArray *) allSources;

@end