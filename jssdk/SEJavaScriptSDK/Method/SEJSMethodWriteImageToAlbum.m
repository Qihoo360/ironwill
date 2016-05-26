//
//  SEJSMethodWriteImageToAlbum.m
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/4/28.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethodWriteImageToAlbum.h"
#import "SEJSCallWriteImageToAlbum.h"

@implementation SEJSMethodWriteImageToAlbum

// 返回接口名
- (NSString *)getName
{
    return @"writeImageToAlbum";
}

- (SEJSCall *)createCall
{
    return [[SEJSCallWriteImageToAlbum alloc] init];
}

@end
