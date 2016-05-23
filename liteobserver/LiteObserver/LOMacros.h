//
//  LOMacros.h
//  LiteObserver
//
//  Created by zhangfusheng on 15/11/22.
//  Copyright © 2015年 kelvin7980@163.com. All rights reserved.
//

#ifndef LOMacros_h
#define LOMacros_h

#import <objc/runtime.h>

#define LO_PROPERTY_DEFINE(property, type) \
static const void *lo_##property##Key = &lo_##property##Key; \
- (type *)lo_##property { \
    id obj = objc_getAssociatedObject(self, lo_##property##Key); \
    if (!obj) { \
        obj = [[type alloc] init]; \
        objc_setAssociatedObject(self, lo_##property##Key, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
    } \
    return obj; \
}

#define LO_PROPERTY_GET(object, property) [object lo_##property]

#define LO_OBJECT_PROPERTY_DEFINE(property, type) \
static const void *lo_##property##Key = &lo_##property##Key; \
+ (type *)lo_##property:(id)object { \
    id obj = objc_getAssociatedObject(object, lo_##property##Key); \
    if (!obj) { \
        obj = [[type alloc] init]; \
        objc_setAssociatedObject(object, lo_##property##Key, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
    } \
    return obj; \
}

#define LO_OBJECT_PROPERTY_GET(class, object, property) [class lo_##property:object]

#endif /* LOMacros_h */
