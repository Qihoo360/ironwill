//
//  ABRecord+vCard.h
//  QHContacts
//
//  Created by yanzhanlong on 16/2/18.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABRecord.h"
#import "QHABMultiValue.h"

typedef NSString *(^Customize)(id labels, id valus);
typedef void(^ToABMultiValue)(NSArray * value, ABMutableMultiValue *abValues);

@interface ABRecord (vCard)

//备份
- (NSString*)replaceString:(NSString*)realString;
- (NSString *)formateABRecordLabel:(CFStringRef)labelText;
- (NSString*)vcardString:(NSString *)title property:(ABPropertyID)property customizeValues:(Customize)valus; 
- (NSString *)vcardStringValue:(NSString *)value;
//恢复
- (void)vcardStringToRecord:(NSString *)value property:(ABPropertyID)property label:(NSString *)label;
- (void)vcardStringToMultiRecord:(NSArray *)value property:(ABPropertyID)property;
- (void)vcardStringToMultiRecord:(NSArray *)value property:(ABPropertyID)property outValues:(ToABMultiValue) outValus;
- (void)vcardStringToDateRecord:(NSString *)value property:(ABPropertyID)property;

@end
