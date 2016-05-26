//
//  ABPerson+compare.h
//  QHContacts
//
//  Created by yanzhanlong on 16/3/3.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABPerson.h"

typedef void(^SimilarityCompare)(NSInteger molecular, NSInteger denominator);

@interface ABPerson (compare)
 
- (void)similarity:(ABPerson *)other callback:(SimilarityCompare) block;
- (void)updateByABPerson:(ABPerson *)other;
- (void)recoveryByABPerson:(ABPerson *)other;

- (BOOL)isEqualToContact:(ABPerson *)other;
- (BOOL)isEqualToContact:(ABPerson *)other byType:(ABPropertyID) typeID;
- (void)similarity:(ABPerson *)other byType:(ABPropertyID) typeID callback:(SimilarityCompare) block;

@end
