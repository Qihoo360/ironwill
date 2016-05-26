//
//  SEJSMethodExit.h
//  SEJavaScriptSDK
//
//  Created by aizhongyuan on 15/3/4.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "SEJSMethod.h"
#import "SEJSMethodExitDelegate.h"

@interface SEJSMethodExit : SEJSMethod

@property(nonatomic, weak) id<SEJSMethodExitDelegate> delegate;

@end
