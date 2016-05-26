//
//  SEJSMethodOpenURL.h
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/3/4.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethod.h"
#import "SEJSMethodOpenURLDelegate.h"

@interface SEJSMethodOpenURL : SEJSMethod
@property (nonatomic, weak) id<SEJSMethodOpenURLDelegate> delegate;
@end
