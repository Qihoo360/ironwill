//
//  ABPerson+vCard.h
//  QHContacts
//
//  Created by yanzhanlong on 16/2/18.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABPerson.h"

@interface ABPerson (vCard)

+ (id)vcardStringToPerson:(NSString *)vCard;

- (NSString*)vcardString;
- (NSString*)vcardStringByGroupInfo:(NSArray *)groups;
- (BOOL)updataPersonByVcardString:(NSString *)vCard;

@end
