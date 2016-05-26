//
//  ABMutableMultiValue+vCard.m
//  QHContacts
//
//  Created by yanzhanlong on 16/3/1.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABMutableMultiValue+vCard.h"

@implementation ABMutableMultiValue (vCard)

- (void)vcardStringToRecord:(NSArray *)values label:(NSString *)label {
    [values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) { 
        [self addValue:obj withLabel:label identifier:nil];
    }];
}

@end
