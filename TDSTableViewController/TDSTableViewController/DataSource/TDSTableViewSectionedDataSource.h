//
//  RSSectionedDataSource.h
//  icePhone
//
//  Created by zhong sheng on 12-5-31.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSTableViewDataSource.h"

@interface TDSTableViewSectionedDataSource : TDSTableViewDataSource {
	NSMutableArray *_sections;
}

@property (nonatomic, retain) NSMutableArray	*sections;			// TDSTableViewSectionObject对象数组
@property (nonatomic, readonly) NSMutableArray	*firstSectionItems;	// 返回第一个section的items数组
@end