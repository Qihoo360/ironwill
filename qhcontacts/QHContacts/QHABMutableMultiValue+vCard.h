//
//  ABMutableMultiValue+vCard.h
//  QHContacts
//
//  Created by yanzhanlong on 16/3/1.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABMultiValue.h"

@interface ABMutableMultiValue (vCard)

//恢复
- (void)vcardStringToRecord:(NSArray *)values label:(NSString *)label;

@end
