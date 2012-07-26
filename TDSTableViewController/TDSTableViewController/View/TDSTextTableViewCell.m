//
//  TDSTextTableViewCell.m
//  icePhone
//
//  Created by zhong sheng on 12-6-8.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSTextTableViewCell.h"
#import "TDSTextTableViewItem.h"

@implementation TDSTextTableViewCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	return 50.0f;
}

- (void) layoutSubviews {
	[super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setObject:(id)object {
    [super setObject:object];
    if (object == nil) return;
    
    TDSTextTableViewItem* tableItem = (TDSTextTableViewItem*)object;
    
    if (tableItem.text != nil && ![tableItem.text isEqualToString:@""]) {
        self.detailTextLabel.text = tableItem.text;
        self.detailTextLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.detailTextLabel.textColor = [UIColor blackColor];//[[RSResManager getInstance] colorForKey:@"colorOfNavigationBtnItem"];
    }        
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
}


@end
