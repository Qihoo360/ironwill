//
//  SysUtils.h
//  Safe360Main
//
//  Created by guowei on 11-4-26.
//  Copyright 2011 Qihoo 360. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, QHMobileGeneration){
    QHMobileUnknown,
    QHMobile2G,
    QHMobile3G,
    QHMobile4G,
};


#define IPHONE5 (SysUtilsScreenSize40Inch == [SysUtils screenSize])

@interface SysUtils : NSObject

+ (BOOL)getAvaliMem:(uint64_t *) freeSpace andTotalMem:(uint64_t *)totalSpace;
+ (BOOL)totalMem:(uint64_t *)totalMem availMem:(uint64_t *)availMem wiredMem:(uint64_t *)wiredMem activeMem:(uint64_t *)activeMem;
+ (BOOL)getAvaliSpace:(uint64_t *) freeSpace andTotalSpace:(uint64_t *)totalSpace;

+ (NSString *)platform;

// 给文件添加SkipBackup属性，避免文件被备份到iCloud，同时避免被系统删除
+ (BOOL)addSkipBackupAttribute:(NSString *)path;
// 获取SkipBackup属性
+ (BOOL)getSkipBackupAttribute:(NSString *)fileName;

+ (NSString *)uniqueIdentifier;

// 获取当前ios的版本号
+ (int)getIOSVersion;

// 是否越狱
+ (BOOL)isBreaked;

// 获取应用版本(不含BuildNumber)
+ (NSString *)GetAppVer;

// 获取应用版本(含BuildNumber)
+ (NSString *)GetAppFullVer;

// 获取数据网络类型
+ (QHMobileGeneration)GetMobileGenerationNumber;
+ (QHMobileGeneration)GetMobileGenerationNumber:(NSString *)radioAccessTechnology;

// 获取WiFi信息
+(NSArray *)getWiFiInfos;

@end
