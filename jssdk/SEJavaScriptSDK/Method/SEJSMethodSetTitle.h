//
//  SEJSMethodSetTitle.h
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/5.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethod.h"
#import "SEJSMethodSetTitleDelegate.h"

@interface SEJSMethodSetTitle : SEJSMethod
@property(nonatomic, weak) id<SEJSMethodSetTitleDelegate> delegate;
@end
