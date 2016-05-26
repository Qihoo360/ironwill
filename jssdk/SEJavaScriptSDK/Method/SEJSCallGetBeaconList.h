//
//  SEJSCallGetBeaconList.h
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/11/6.
//  Copyright © 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSCall.h"

typedef NS_ENUM(NSInteger, JSGetBeaconListResult) {
    JSGetBeaconList_Success = 0, // 成功
    JSGetBeaconList_NotSupport = 1, // 不支持
    JSGetBeaconList_LocationNotEnable = 2, // 定位服务未开启
    JSGetBeaconList_BlueToothNotEnable = 3, // 蓝牙未开启
    JSGetBeaconList_Other = 4, // 其他错误
};

@interface SEJSCallGetBeaconList : SEJSCall


@end
