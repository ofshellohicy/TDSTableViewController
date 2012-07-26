//
//  TDSTableViewLoadMoreItem.m
//  icePhone
//
//  Created by zhong sheng on 12-6-6.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSTableViewLoadMoreItem.h"

@implementation TDSTableViewLoadMoreItem
@synthesize isLoading = _isLoading;
@synthesize title = _title;

+ (TDSTableViewLoadMoreItem *)itemWithTitle:(NSString *)title
{
	TDSTableViewLoadMoreItem *item = [[[TDSTableViewLoadMoreItem alloc] init] autorelease];
	item.title = title;
	return item;
}

- (void)dealloc
{
    RELEASE(_title);
    [super dealloc];
}

@end
