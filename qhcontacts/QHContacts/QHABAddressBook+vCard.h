//
//  ABAddressBook+vCard.h
//  QHContacts
//
//  Created by yanzhanlong on 16/2/19.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "QHABAddressBook.h"

@interface ABAddressBook (vCard)

+ (id)vcardStringToAddressBook:(NSString *)vCard;

- (NSString*)vcardString;
- (BOOL)updataAddressBookByVcardString:(NSString *)vCard;

@end
