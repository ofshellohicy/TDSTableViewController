//
//  RSTableItem.h
//  icePhone
//
//  Created by zhong sheng on 12-4-10.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDSTableViewItem : NSObject

@property (nonatomic, assign) float cellHeight;	// 缓存cell的高度,主要用于高度可变的cell

@property (nonatomic, retain) id userInfo;		// 用户数据

@end
