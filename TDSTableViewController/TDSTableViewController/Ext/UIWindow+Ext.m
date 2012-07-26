//
//  UIWindow+UIWindow_Ext.m
//
//  Created by zhong sheng on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIWindow+Ext.h"

@implementation UIWindow (ext)
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)findFirstResponder {
    return [self findFirstResponderInView:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)findFirstResponderInView:(UIView*)topView {
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView* firstResponderCheck = [self findFirstResponderInView:subView];
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}

@end
