//
//  TDSTextTableViewItem.h
//  icePhone
//
//  Created by zhong sheng on 12-6-8.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSTableViewItem.h"

@interface TDSTextTableViewItem : TDSTableViewItem
@property (nonatomic, copy) NSString *text;
+ (TDSTextTableViewItem*)itemWithText:(NSString*)newText;
@end
