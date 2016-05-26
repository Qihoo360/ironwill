//
//  SysUtils.m
//  Safe360Main
//
//  Created by guowei on 11-4-26.
//  Copyright 2011 Qihoo 360. All rights reserved.
//

#import "SysUtils.h"
#import <unistd.h>
#import <sys/param.h>
#import <sys/mount.h>
#import <sys/sysctl.h>
#import <sys/stat.h>

#import <sys/sysctl.h>
#import <net/if_dl.h>
#import <net/if.h>
#import <mach/vm_statistics.h>
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/mach.h>
#import <ftw.h>
#import <sys/stat.h>
#import <sys/ioctl.h>
#include <sys/xattr.h>

#import <UIKit/UIKit.h>

#import  <CoreTelephony/CTCarrier.h>
#import  <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import <Utils/NSString+md5.h>

#import "QHKeyChainHelper.h"

#define IOS_VM_PAGE_SIZE (4 * 1024)


typedef enum fileTypes_tag {
	MUSIC=0,
	VIDEO=1,
	PICTURE=2,
	VIDEOANDPIC=3
} FILETYPES;

FILETYPES fileType;

int musciCount;
uint64_t musciSize;

int picCount;
uint64_t picSize;

int videoCount;
uint64_t videoSize;

vm_size_t usedMemory(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

@implementation SysUtils

/////////////////////////
+ (NSString*)getSysInfoByName:(char *)typeSpecifier
{
	size_t size;
	sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
	char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
	free(answer);
	return results;
}
+ (NSInteger)getSysInfo:(uint) typeSpecifier
{
	size_t size = sizeof(int);
	int results;
	int mib[2] = {CTL_HW, typeSpecifier};
	sysctl(mib,2, &results, &size, NULL, 0);
	return (NSInteger)results;
}
+(NSUInteger) cpuFrequency
{
	return [self getSysInfo:HW_CPU_FREQ];
}
+(NSUInteger) totalMemory
{
	return [self getSysInfo:HW_PHYSMEM];
}
+(NSUInteger) userMemory
{
	return [self getSysInfo:HW_USERMEM];
}
+(BOOL)getAvaliSpace:(uint64_t *) fS andTotalSpace:(uint64_t *)tS {

    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
//        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    *fS = totalFreeSpace;
    *tS = totalSpace;
    
//	struct statfs buf;
//
//	*freeSpace = 0;
//	*totalSpace = 0;
//	NSString *fstab = [NSString stringWithContentsOfFile:@"/etc/fstab" encoding:NSASCIIStringEncoding error:nil];
//	if(fstab){
//		NSArray *lines = [fstab componentsSeparatedByString:@"\n"];
//		for (NSString *line in lines) {
//			NSArray *items = [line componentsSeparatedByString:@" "];
//			if([items count] > 1){
//				if ([[items objectAtIndex:1] length] > 3) {
//					if(statfs([[items objectAtIndex:1] UTF8String], &buf) >= 0){
//						*freeSpace += (long long)buf.f_bsize * buf.f_bfree;
//						*totalSpace += (long long)(buf.f_blocks * buf.f_bsize);
//					}
//				}
//			}
//		}
//	}
    
	return YES;
}

+(uint64_t)getMemSize{
	uint64_t memsize = -1;
	void *pMem = NULL;
	size_t len = 0;
	int err = sysctlbyname("hw.memsize", pMem, &len, NULL, 0);
	if(err != 0){
//		err = errno;
	}else{
		if(len > 0){
			pMem = malloc(len);
			sysctlbyname("hw.memsize", pMem, &len, NULL, 0);
            memsize = *(uint64_t*)pMem;
			free(pMem);
		}
	}
	return memsize;
}
+ (vm_statistics_data_t)vm_info
{
	mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
	vm_statistics_data_t vmstat;
	vmstat.wire_count = 0;
	if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS)
	{
		// failed
	}
	
	return vmstat;
}

+(BOOL)getAvaliMem:(uint64_t *) availMem andTotalMem:(uint64_t *)totalMem
{
	uint64_t memsize = [self getMemSize];
	vm_statistics_data_t vm_stat = [self vm_info];
    
	*totalMem =  memsize;
	uint64_t used = memsize-(vm_stat.free_count/*+vm_stat.inactive_count*/)*IOS_VM_PAGE_SIZE;
	*availMem = *totalMem - used;
	return YES;
}

+(BOOL)totalMem:(uint64_t *)totalMem availMem:(uint64_t *)availMem wiredMem:(uint64_t *)wiredMem activeMem:(uint64_t *)activeMem
{
	uint64_t memsize = [self getMemSize];
	vm_statistics_data_t vm_stat = [self vm_info];
    
	*totalMem =  memsize;
	uint64_t used = memsize-(vm_stat.free_count/*+vm_stat.inactive_count*/)*IOS_VM_PAGE_SIZE;
	*availMem = *totalMem - used;
    *wiredMem = vm_stat.wire_count * IOS_VM_PAGE_SIZE;
    *activeMem = vm_stat.active_count * IOS_VM_PAGE_SIZE;
    
	return YES;
}

+ (NSString *)platform {
	size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname("hw.machine", answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
	free(answer);
	return results;
}

+ (BOOL)addSkipBackupAttribute:(NSString *)fileName {
    
    if ([self getIOSVersion] >= __IPHONE_5_1) { // iOS5.1.0
        NSURL * url = [NSURL fileURLWithPath:fileName];
        
        NSError *error = nil;
        BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
        }
        return success;
    }
    else if ([self getIOSVersion] >= 50001) { // iOS 5.0.1
        
        
        const char* filePath = [fileName UTF8String];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    else {
        // other ios is not supported
        return FALSE;
    }
}

// 获取SkipBackup属性
+ (BOOL)getSkipBackupAttribute:(NSString *)fileName
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        return FALSE;
    }
    
    if ([self getIOSVersion] >= __IPHONE_5_1) { // iOS5.1.0
        NSURL * url = [NSURL fileURLWithPath:fileName];
        
        NSError *error = nil;
        NSNumber * value = nil;
        BOOL success = [url getResourceValue: &value
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
        }
        return value == nil ? NO : [value boolValue];
    }
    else if ([self getIOSVersion] >= 50001) { // iOS 5.0.1
        
        
        const char* filePath = [fileName UTF8String];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 0;
        
        getxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return attrValue ? YES : NO;
    }
    else {
        // other ios is not supported
        return FALSE;
    }
}

+(NSString *) localMacAddress
{
    int mib[6];
    size_t len;
    char  *buf;
    unsigned char  *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+ (NSString *) getDeviceId
{
    if ([SysUtils getIOSVersion] >= 70000) {
        NSUUID * aid = [[UIDevice currentDevice] identifierForVendor];
        NSString *uniqueIdentifier = [[aid UUIDString] md5String];
        return uniqueIdentifier;
    }
    else {
        NSString *macaddress = [self localMacAddress];
        NSString *uniqueIdentifier = [macaddress md5String];
        return uniqueIdentifier;
    }
}

// 获取唯一设备ID
+ (NSString *)uniqueIdentifier {
    return [self uniqueIdentifier:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
}

// 获取唯一设备ID
+ (NSString *)uniqueIdentifier:(NSString *)service {
    static NSString * deviceId = nil;
    
    @synchronized(self) {
        if (deviceId == nil) {
            // 先通过keychain获取
            QHKeyChainHelper * keyChain = [QHKeyChainHelper keyChainHelperForService:service];
            NSString * errorMsg = nil;
            NSData * data = [keyChain queryItem:&errorMsg];
            
            if (data != nil) {
                // keychain中已经存在
                deviceId = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
            else {
                // keychain中不存在
                // 计算deviceId
                deviceId = [self getDeviceId];
                // 保存到keychain中
                if ([keyChain addItem:[deviceId dataUsingEncoding:NSUTF8StringEncoding] errorMsg:&errorMsg protection:NULL] == errSecDuplicateItem) {
                    // 已经存在，先删除
                    [keyChain deleteItemAndReturnErrorMsg:&errorMsg];
                    
                    [keyChain addItem:[deviceId dataUsingEncoding:NSUTF8StringEncoding] errorMsg:&errorMsg protection:NULL];
                }
                
            }
        }
        return deviceId;
    }
}

// 获取当前ios的版本号
+ (int)getIOSVersion
{
    static int version = -1;
    
    if (version == -1) {
        int ver1 = 0;
        int ver2 = 0;
        int ver3 = 0;
        
        NSString* iosVersion = [[UIDevice currentDevice] systemVersion];
        NSArray* versions = [iosVersion componentsSeparatedByString:@"."];
        
        ver1 = [[versions objectAtIndex:0] intValue];
        ver2 = [[versions objectAtIndex:1] intValue];
        if ([versions count] == 3) {
            ver3 = [[versions objectAtIndex:2] intValue];
        }
        version = ver1*10000 + ver2*100 + ver3;
    }
    
    return version;
}

// 是否越狱
+ (BOOL)isBreaked
{
    static BOOL first = YES;
    static BOOL breaked = NO;
    
    @synchronized(self) {
        if (first) {

#if !TARGET_IPHONE_SIMULATOR
            NSArray *paths = @[[NSString stringWithFormat:@"/Applications/%@.app", @"Cydia"],
                               // 越狱过的设备，升级后，变为未越狱，此文件依然存在，所以不能以此来判断越狱
//                               [NSString stringWithFormat:@"/%@/%@/%@/%@/", @"private", @"var", @"lib", @"apt"],
                               [NSString stringWithFormat:@"/%@/%@", @"bin", @"bash"]];

            for (NSString *path in paths) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    breaked = YES;
                    break;
                }
            }
#endif

            first = NO;
        }
        
        return breaked;
    }
}

+ (NSString *)GetAppVer
{
    static NSString *ret = nil;
    if (ret == nil) {
        ret = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return ret;
}

+ (NSString *)GetAppFullVer
{
    static NSString *ret = nil;
    if (ret == nil) {
        ret = [NSString stringWithFormat:@"%@.%@",
         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    }
    return ret;
}

// 获取数据网络类型
+ (QHMobileGeneration)GetMobileGenerationNumber
{
    if ([SysUtils getIOSVersion] < __IPHONE_7_0) {
        return QHMobileUnknown;
    }
    
    CTTelephonyNetworkInfo * telNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString * radioAccessTechnology = telNetworkInfo.currentRadioAccessTechnology;
    
    if (radioAccessTechnology == nil) {
        return QHMobileUnknown;
    }
    
    return [self GetMobileGenerationNumber:radioAccessTechnology];
}

+ (QHMobileGeneration)GetMobileGenerationNumber:(NSString *)radioAccessTechnology
{
    if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] ||
        [radioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] ||
        [radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        return QHMobile2G;
    }
    
    if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA] ||
        [radioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA] ||
        [radioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA] ||
        [radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
        [radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
        [radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
        [radioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        return QHMobile3G;
    }
    
    if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
        return QHMobile4G;
    }
    
    return QHMobileUnknown;
}

+(NSArray *)getWiFiInfos
{
    NSArray *ifs = (__bridge_transfer NSArray*)CNCopySupportedInterfaces();
    if ([ifs count] <= 0) {
        return nil;
    }
    
    NSMutableArray * wifis = [NSMutableArray array];
    for (NSString *ifname in ifs)
    {
        NSDictionary * info = (__bridge_transfer NSDictionary*)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        if ([info count] <= 0)
        {
            break;
        }
        NSString * bssid = info[(__bridge NSString*)kCNNetworkInfoKeyBSSID];
        NSString * ssid = info[(__bridge NSString*)kCNNetworkInfoKeySSID];
        
        if ([bssid length] > 0 && [ssid length] > 0) {
            [wifis addObject:info];
        }
    }
    
    return wifis;
}

@end
