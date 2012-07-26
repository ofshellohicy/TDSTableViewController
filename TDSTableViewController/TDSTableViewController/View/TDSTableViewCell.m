//
//  TDSTableViewCell.m
//  icePhone
//
//  Created by zhong sheng on 12-4-9.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSTableViewCell.h"

#define TABLE_DETAIL_TEXT_LINE_COUNT 2


@implementation TDSTableViewCell

@synthesize object = _object;
@synthesize indexPath = _indexPath;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object
{
    return 44;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];//TTSTYLEVAR(tableFont);
        self.textLabel.textColor = [UIColor blackColor];//TTSTYLEVAR(textColor);
        self.textLabel.highlightedTextColor = [UIColor whiteColor];//TTSTYLEVAR(highlightedTextColor);
        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];//TTSTYLEVAR(font);
        self.detailTextLabel.textColor = [UIColor blackColor];//TTSTYLEVAR(tableSubTextColor);
        self.detailTextLabel.highlightedTextColor = [UIColor whiteColor];//TTSTYLEVAR(highlightedTextColor);
        self.detailTextLabel.textAlignment = UITextAlignmentLeft;
        self.detailTextLabel.contentMode = UIViewContentModeTop;
        self.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.detailTextLabel.numberOfLines = TABLE_DETAIL_TEXT_LINE_COUNT;
    }
    
    return self;
}

- (void)dealloc
{
    self.object = nil;
    RELEASE(_object);
    self.indexPath = nil;
    [super dealloc];
}

- (void)setObject:(id)object
{
	if (object != _object) {
		RELEASE(_object);
		_object = [object retain];
	}
}

@end
