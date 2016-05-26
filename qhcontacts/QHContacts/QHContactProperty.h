//
//  QHContactProperty.h
//  QHContacts
//
//  Created by yanzhanlong on 16/4/1.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface QHContactProperty : NSObject <NSCopying>
@property (nonatomic, assign) ABPropertyID propertyID;
@property (nonatomic, strong) NSString *propertyLabel;
@property (nonatomic, strong) id propertyValue;

// properties for display
@property (readonly) NSString *displayName;
@property (nonatomic, strong, readonly) NSString *displayLabel;
@property (nonatomic, strong, readonly) NSString *displayValue;

#if SHOW_PHONE_NUMBER_LOCATION
@property (nonatomic, strong, readonly) NSString *displayLabelWithLocation;
#else
@property (readonly, getter=displayLabel) NSString *displayLabelWithLocation;
#endif

+ (instancetype)propertyByType:(ABPropertyID)propertyID
                      withValue:(id)propertyValue
                       forLabel:(NSString *)propertyLabel;

+ (instancetype)property:(ABPropertyID)propertyID
               withValue:(id)propertyValue
                forLabel:(NSString *)propertyLabel;

+ (NSString *)trimPhoneNumber:(NSString *)sourcePhoneNumber;

+ (NSArray *)sortDescriptors;
@end
