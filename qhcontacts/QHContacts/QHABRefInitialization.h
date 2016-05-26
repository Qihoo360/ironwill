//
//  ABRefInitialization.h
//  QHContacts
//
//  Created by yanzhanlong on 16/2/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABMultiValue.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/ABGroup.h>

//Other
#define CFRELEASE(x) {if(x){CFRelease(x);(x)=nil;}}

@protocol ABRefInitialization <NSObject>
+ (id) alloc;       // this keeps the compiler happy
- (id) initWithABRef: (CFTypeRef) ref;
@end
