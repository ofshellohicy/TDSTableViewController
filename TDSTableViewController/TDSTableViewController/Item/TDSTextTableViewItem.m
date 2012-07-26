//
//  TDSTextTableViewItem.m
//  icePhone
//
//  Created by zhong sheng on 12-6-8.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSTextTableViewItem.h"

@implementation TDSTextTableViewItem
@synthesize text;

+ (TDSTextTableViewItem*)itemWithText:(NSString*)newText{
    TDSTextTableViewItem *item = [[TDSTextTableViewItem alloc] init];
    item.text = newText;
    return [item autorelease];
}
@end
