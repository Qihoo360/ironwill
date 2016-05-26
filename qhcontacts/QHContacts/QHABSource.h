//
//  ABSource.h
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABRecord.h"

@interface ABSource : ABRecord

- (NSArray *) allGroups;
- (NSArray *) allPeoples;


+ (BOOL)isExchange;
+ (BOOL)isAllExchange;

@end
