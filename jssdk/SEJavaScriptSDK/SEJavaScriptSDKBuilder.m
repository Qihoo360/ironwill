//
//  SEJavaScriptSDKBuilder.m
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/4.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJavaScriptSDKBuilder.h"
#import "SEJavaScriptSDK.h"
#import "SEJSMethodSetTitle.h"
#import "SEJSMethodExit.h"
#import "SEJSMethodCanOpenURL.h"
#import "SEJSMethodOpenURL.h"
#import "SEJSMethodSetNavigationRightBarButton.h"
#import "SEJSMethodGetNetworkStatus.h"
#import "SEJSMethodGetDeviceDiskInfo.h"
#import "SEJSMethodAlert.h"
#import "SEJSMethodWriteImageToAlbum.h"
#import "SEJSMethodGetAssetsAuthStatus.h"
#import "SEJSMethodGetCalendarAuthStatus.h"

#import "SEJSMethodGetBeaconList.h"
#import "SEJSMethodGetBatteryState.h"

@interface SEJavaScriptSDKBuilder ()
@property(nonatomic, readwrite) NSArray *methods;
@end

@implementation SEJavaScriptSDKBuilder

- (SEJavaScriptSDK *)build {
    NSParameterAssert(self.setTitleDelegate);
    NSParameterAssert(self.exitDelegate);
    NSParameterAssert(self.setNavigationRightBarButtonDelegate);
    
    NSParameterAssert(self.webView);
    NSParameterAssert(self.webViewDelegate);
    NSParameterAssert(self.bundle);
 
    [self buildMethods];
    
    return [[SEJavaScriptSDK alloc] initWithBuilder:self];
}

- (void)buildMethods
{
    NSMutableArray *methods = [NSMutableArray array];
    
    [self buildMethods:methods];
    
    self.methods = methods;
}

- (void)buildMethods:(NSMutableArray *)methods {
    
    // setTitle
    {
        SEJSMethodSetTitle *method = [[SEJSMethodSetTitle alloc] init];
        method.delegate = self.setTitleDelegate;
        [methods addObject:method];
    }
    
    // canOpenURL
    {
        SEJSMethodCanOpenURL * method = [[SEJSMethodCanOpenURL alloc] init];
        [methods addObject:method];
    }
    
    // openURL
    {
        SEJSMethodOpenURL * method = [[SEJSMethodOpenURL alloc] init];
        [methods addObject:method];
    }
    
    // exit
    {
        SEJSMethodExit * method = [[SEJSMethodExit alloc] init];
        method.delegate = self.exitDelegate;
        [methods addObject:method];
    }
    
    // setNavigationRightBarButton
    {
        SEJSMethodSetNavigationRightBarButton *method = [[SEJSMethodSetNavigationRightBarButton alloc] init];
        method.delegate = self.setNavigationRightBarButtonDelegate;
        [methods addObject:method];
    }
    
    // getNetworkStatus
    {
        SEJSMethodGetNetworkStatus *method = [[SEJSMethodGetNetworkStatus alloc] init];
        [methods addObject:method];
    }
    
    // getDeviceDiskInfo
    {
        SEJSMethodGetDeviceDiskInfo *method = [[SEJSMethodGetDeviceDiskInfo alloc] init];
        [methods addObject:method];
    }
    
    // alert
    {
        SEJSMethodAlert *method = [[SEJSMethodAlert alloc] init];
        [methods addObject:method];
    }
    
    // writeImageToAlbum
    {
        SEJSMethodWriteImageToAlbum *method = [[SEJSMethodWriteImageToAlbum alloc] init];
        [methods addObject:method];
    }
    
    // getAssetsAuthStatus
    {
        SEJSMethodGetAssetsAuthStatus * method = [[SEJSMethodGetAssetsAuthStatus alloc] init];
        [methods addObject:method];
    }
    
    // getCalendarAuthStatus
    {
        SEJSMethodGetCalendarAuthStatus * method = [[SEJSMethodGetCalendarAuthStatus alloc] init];
        [methods addObject:method];
    }
    
    // getBeaconList
    {
        SEJSMethodGetBeaconList * method = [[SEJSMethodGetBeaconList alloc] init];
        [methods addObject:method];
    }
    
    // getBatteryState
    {
        SEJSMethodGetBatteryState * method = [[SEJSMethodGetBatteryState alloc] init];
        [methods addObject:method];
    }
}

- (void)dealloc {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
