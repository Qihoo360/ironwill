//
//  ABContactComparer.h
//  QHContacts
//
//  Created by yanzhanlong on 16/3/3.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABContactComparer : NSObject
#pragma mark instance

+ (id)comparerWithContacts:(NSArray *)leftContacts
               andContacts:(NSArray *)rightContacts;

+ (id)comparerWithVCard:(NSString *)vCard;

#pragma mark properties

@property (nonatomic, strong) NSArray * leftContacts;
@property (nonatomic, strong) NSArray * rightContacts;

#pragma mark properties # comparison result

//
// allow writing -> caller can release memory ASAP
//
@property (nonatomic, strong) NSMutableArray * resultSame;
@property (nonatomic, strong) NSMutableArray * resultSimilar;
@property (nonatomic, strong) NSMutableArray * resultLeft;
@property (nonatomic, strong) NSMutableArray * resultRight;

#pragma mark methods

- (BOOL)compare;

@end
