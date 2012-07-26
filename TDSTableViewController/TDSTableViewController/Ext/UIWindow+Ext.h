//
//  UIWindow+UIWindow_Ext.h
//
//  Created by zhong sheng on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (ext)
/**
 * Searches the view hierarchy recursively for the first responder, starting with this window.
 */
- (UIView*)findFirstResponder;

/**
 * Searches the view hierarchy recursively for the first responder, starting with topView.
 */
- (UIView*)findFirstResponderInView:(UIView*)topView;

@end
