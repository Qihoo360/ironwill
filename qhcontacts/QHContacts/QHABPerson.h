//
//  ABPerson.h
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABRecord.h"

@interface ABPerson : ABRecord

// use -init to create a new person
@property (nonatomic,strong, getter = getFirstName)     NSString *firstName;
@property (nonatomic,strong, getter = getLastName)      NSString *lastName;
@property (nonatomic,strong, getter = getMiddleName)    NSString *middleName;
@property (nonatomic,strong)                            NSString *name;
@property (nonatomic,strong)                            NSString *photoID;//照片ID
@property (nonatomic,strong)                            NSArray  *groups;//分组信息

@property (nonatomic, readonly)                         BOOL hasImageData;

+ (ABPropertyType) typeOfProperty: (ABPropertyID) property;
+ (NSString *) localizedNameOfProperty: (ABPropertyID) property;
+ (ABPersonSortOrdering) sortOrdering;
+ (ABPersonCompositeNameFormat) compositeNameFormat;

+ (instancetype)creatABPerson;

- (BOOL) setImageData: (NSData *) imageData error: (NSError **) error;
- (NSData *) imageData;
- (NSData *) thumbnailImageData;

- (BOOL) removeImageData: (NSError **) error;
- (ABPersonCompositeNameFormat) compositeNameFormat;

- (void)clearAllName;


- (NSComparisonResult) compare: (ABPerson *) otherPerson;
- (NSComparisonResult) compare: (ABPerson *) otherPerson sortOrdering: (ABPersonSortOrdering) order;

@end
