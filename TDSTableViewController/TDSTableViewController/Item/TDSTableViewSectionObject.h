//
//  RSSectionObject.h
//  icePhone
//
//  Created by zhong sheng on 12-5-31.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDSTableViewSectionObject : NSObject {
    NSString *_letter;
    NSString *_title;
    id _userInfo;
    NSMutableArray *_items;
}

@property (nonatomic, copy) NSString *letter;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) id userInfo;
@property (nonatomic, retain) NSMutableArray *items;

@end
