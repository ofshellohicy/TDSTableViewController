//
//  TDSTableViewLoadMoreItem.h
//  icePhone
//
//  Created by zhong sheng on 12-6-6.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDSTableViewLoadMoreItem : NSObject


@property (nonatomic, assign) BOOL	isLoading;
@property (nonatomic, retain) NSString		*title;

+ (TDSTableViewLoadMoreItem *)itemWithTitle:(NSString *)title;

@end
