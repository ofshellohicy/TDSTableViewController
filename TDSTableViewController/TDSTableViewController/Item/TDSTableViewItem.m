//
//  RSTableItem.m
//  icePhone
//
//  Created by zhong sheng on 12-4-10.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSTableViewItem.h"

@implementation TDSTableViewItem
@synthesize cellHeight = _cellHeight;
@synthesize userInfo = _userInfo;

- (void)dealloc
{
    RELEASE(_userInfo)
    [super dealloc];
}

@end
