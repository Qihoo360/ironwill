//
//  SEJSMethodSetNavigationRightBarButton.h
//  SEJavaScriptSDK
//
//  Created by zero on 15/3/5.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethod.h"
#import "SEJSMethodSetNavigationRightBarButtonDelegate.h"

@interface SEJSMethodSetNavigationRightBarButton : SEJSMethod
@property(nonatomic, weak) id<SEJSMethodSetNavigationRightBarButtonDelegate> delegate;
@end
