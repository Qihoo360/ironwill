//
//  NSCalendar+equalWithGranularity.h
//  QHContacts
//
//  Created by yanzhanlong on 16/3/17.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (equalWithGranularity)

- (BOOL)isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 withGranularity:(NSCalendarUnit)granularity;

@end
