//
//  TDSTableViewCell.h
//  icePhone
//
//  Created by zhong sheng on 12-4-9.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDSTableViewCell : UITableViewCell
{
    id _object;
}

@property (nonatomic, retain) id		object;
@property (nonatomic, copy) NSIndexPath *indexPath;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object;

@end
