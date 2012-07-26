//
//  TDSGlobal.h
//  TDSTableViewController
//
//  Created by zhong sheng on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>

#import "UIWindow+Ext.h"
#import "NSObject+Ext.h"
#import "SVPullToRefresh.h"

#define RELEASE(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }
#define RELEASE_CF(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }
